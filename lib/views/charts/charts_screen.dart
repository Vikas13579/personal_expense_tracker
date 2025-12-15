import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../shared/widgets/app_drawer.dart';
import '../../viewmodels/charts_viewmodel.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChartsViewModel>();
    final data = vm.categoryData();

    return Scaffold(
      // drawer: const AppDrawer(),

      appBar: AppBar(title: const Text("Charts")),
      body: data.isEmpty
          ? const Center(child: Text("No data"))
          : PieChart(
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
