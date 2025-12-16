import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../data/models/transaction_model.dart';

enum InsightRange { daily, monthly, yearly }

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  InsightRange selectedRange = InsightRange.monthly;
  final box = Hive.box<Transaction>('transactions');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2E),
      appBar: AppBar(
        title: const Text("Insights"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor:  Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _rangeSelector(),
            const SizedBox(height: 24),
            _scrollableBarChart(),
            const SizedBox(height: 28),
            const Text(
              "Recently Used",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
            ),
            const SizedBox(height: 12),
            Expanded(child: _recentExpenses()),
          ],
        ),
      ),
    );
  }

  // 🔹 RANGE SELECTOR
  Widget _rangeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: InsightRange.values.map((range) {
          final selected = selectedRange == range;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedRange = range),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  range.name.capitalize(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 🔹 SCROLLABLE BAR CHART (POLISHED)
  Widget _scrollableBarChart() {
    final data = _groupedExpenseData();

    if (data.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text("No data available")),
      );
    }

    final maxValue = data.values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 220,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: data.length * 60,
          child: BarChart(
            BarChartData(
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              alignment: BarChartAlignment.spaceAround,
              titlesData: FlTitlesData(
                leftTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          data.keys.elementAt(value.toInt()),
                          style: const TextStyle(fontSize: 10,color: Colors.white,),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: List.generate(
                data.length,
                    (i) {
                  final amount = data.values.elementAt(i);
                  final intensity = (amount / maxValue).clamp(0.3, 1.0);

                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: amount,
                        width: 20,
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          colors: [
                            Colors.greenAccent.withOpacity(intensity),
                            Colors.redAccent.withOpacity(intensity),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 RECENT EXPENSES
  Widget _recentExpenses() {
    final list = box.values.toList().reversed.take(5).toList();

    if (list.isEmpty) {
      return const Center(child: Text("No recent expenses"));
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) {
        final t = list[i];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(t.title),
            subtitle: Text(DateFormat('dd MMM yyyy').format(t.date)),
            trailing: Text(
              "-₹${t.amount.toInt()}",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  // 🔹 DATA GROUPING
  Map<String, double> _groupedExpenseData() {
    final now = DateTime.now();
    final Map<String, double> map = {};

    for (final t in box.values) {
      String key;

      switch (selectedRange) {
        case InsightRange.daily:
          if (!DateUtils.isSameDay(t.date, now)) continue;
          key = DateFormat('HH').format(t.date);
          break;

        case InsightRange.monthly:
          if (t.date.month != now.month || t.date.year != now.year) continue;
          key = DateFormat('MMM').format(t.date);
          break;

        case InsightRange.yearly:
          if (t.date.year != now.year) continue;
          key = DateFormat('MMM').format(t.date);
          break;
      }

      map[key] = (map[key] ?? 0) + t.amount;
    }

    return map;
  }
}

// 🔹 STRING EXTENSION
extension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
