import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/transaction_model.dart';

class CategoryPie extends StatelessWidget {
  final DateTime selectedMonth;

  const CategoryPie(this.selectedMonth, {super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Transaction>('transactions');
    final Map<String, double> data = {};

    for (var t in box.values) {
      if (t.date.month == selectedMonth.month &&
          t.date.year == selectedMonth.year) {
        data[t.category] = (data[t.category] ?? 0) + t.amount;
      }
    }

    if (data.isEmpty) return const SizedBox();

    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          sections: data.entries
              .map((e) => PieChartSectionData(
            value: e.value,
            title: e.key,
          ))
              .toList(),
        ),
      ),
    );
  }
}
