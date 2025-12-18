import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../data/models/reports_viewmodel.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportsViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1B2E),
        appBar: AppBar(
          centerTitle: true,

          title: const Text("Reports"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Consumer<ReportsViewModel>(
          builder: (_, vm, __) {
            if (vm.transactionCount == 0) {
              return const Center(
                child: Text(
                  "No data available for this month",
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _summaryRow(vm),
                  const SizedBox(height: 24),
                  const Text(
                    "Category Breakdown",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _pieChart(vm),
                  const SizedBox(height: 24),
                  _categoryList(vm),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // 🔹 SUMMARY
  Widget _summaryRow(ReportsViewModel vm) {
    return Row(
      children: [
        _summaryCard(
          "Total Spent",
          "₹${vm.totalSpent.toInt()}",
          Icons.account_balance_wallet,
        ),
        const SizedBox(width: 12),
        _summaryCard(
          "Transactions",
          vm.transactionCount.toString(),
          Icons.receipt_long,
        ),
      ],
    );
  }

  Widget _summaryCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2747),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 PIE CHART
  Widget _pieChart(ReportsViewModel vm) {
    return SizedBox(
      height: 260,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 50,
          sectionsSpace: 4,
          sections: vm.categoryData.entries.map((e) {
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
    );
  }

  // 🔹 CATEGORY LIST
  Widget _categoryList(ReportsViewModel vm) {
    return Column(
      children: vm.categoryData.entries.map((e) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2747),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  e.key,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Text(
                "₹${e.value.toInt()}",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
