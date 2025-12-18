import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthlyLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2747),
        borderRadius: BorderRadius.circular(20),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(1, 2000),
                FlSpot(2, 3500),
                FlSpot(3, 2500),
                FlSpot(4, 4500),
                FlSpot(5, 3000),
              ],
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Colors.purpleAccent, Colors.deepPurple],
              ),
              barWidth: 4,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
