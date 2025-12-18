import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/insights_viewmodel.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InsightsViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1B2E),
        appBar: AppBar(
          centerTitle: true,

          title: const Text("Insights"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Consumer<InsightsViewModel>(
          builder: (_, vm, __) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rangeSelector(vm),
                  const SizedBox(height: 24),
                  _barChart(vm),
                  const SizedBox(height: 28),
                  const Text(
                    "Recent Usage",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(child: _recentList(vm)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // 🔹 RANGE SELECTOR
  Widget _rangeSelector(InsightsViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: InsightRange.values.map((range) {
          final selected = vm.selectedRange == range;
          return Expanded(
            child: GestureDetector(
              onTap: () => vm.changeRange(range),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  range.name.toUpperCase(),
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

  // 🔹 BAR CHART
  Widget _barChart(InsightsViewModel vm) {
    if (vm.chartData.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            "No data available",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final maxValue =
    vm.chartData.values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 220,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: vm.chartData.length * 60,
          child: BarChart(
            BarChartData(
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
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
                      final key =
                      vm.chartData.keys.elementAt(value.toInt());
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          key,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: List.generate(
                vm.chartData.length,
                    (i) {
                  final amount =
                  vm.chartData.values.elementAt(i);
                  final intensity =
                  (amount / maxValue).clamp(0.4, 1.0);

                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: amount,
                        width: 20,
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          colors: [
                            Colors.greenAccent
                                .withOpacity(intensity),
                            Colors.deepPurple
                                .withOpacity(intensity),
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

  // 🔹 RECENT LIST
  Widget _recentList(InsightsViewModel vm) {
    if (vm.recent.isEmpty) {
      return const Center(
        child: Text(
          "No recent expenses",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      itemCount: vm.recent.length,
      itemBuilder: (_, i) {
        final t = vm.recent[i];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            title: Text(t.title),
            subtitle: Text(t.category),
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
}
