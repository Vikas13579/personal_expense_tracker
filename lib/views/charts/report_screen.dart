import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../data/models/transaction_model.dart';
import '../../shared/widgets/report_summary_cards.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final box = Hive.box<Transaction>('transactions');

    final Map<String, double> data = {};

    for (var t in box.values) {
      if (t.date.month == now.month && t.date.year == now.year) {
        data[t.category] = (data[t.category] ?? 0) + t.amount;
      }
    }

    final double totalSpent =
    data.values.fold(0.0, (sum, v) => sum + v);

    final int txCount = box.values.where((t) =>
    t.date.month == now.month &&
        t.date.year == now.year).length;

    String topCategory = '-';
    double maxValue = 0;

    data.forEach((key, value) {
      if (value > maxValue) {
        maxValue = value;
        topCategory = key;
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2E),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          "Reports",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: data.isEmpty
          ? const Center(
        child: Text(
          "No data available for this month",
          style: TextStyle(color: Colors.white70),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 SUMMARY CARDS
            Row(
              children: [
                ReportSummaryCard(
                  title: "Total Spent",
                  value: "₹${totalSpent.toInt()}",
                  icon: Icons.account_balance_wallet,
                ),
                const SizedBox(width: 12),
                ReportSummaryCard(
                  title: "Transactions",
                  value: txCount.toString(),
                  icon: Icons.receipt_long,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                ReportSummaryCard(
                  title: "Top Category",
                  value: topCategory,
                  icon: Icons.trending_up,
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              "Category-wise Expenses",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 260,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 50,
                  sectionsSpace: 4,
                  sections: data.entries.map((e) {
                    return PieChartSectionData(
                      value: e.value,
                      title: e.key,
                      radius: 70,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
