import 'package:flutter/material.dart';

class BentoSection extends StatelessWidget {
  final double Function(String) total;

  const BentoSection(this.total, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _tile("Today", total('Daily'), Icons.flash_on)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              _tile("Monthly", total('Monthly'), Icons.calendar_today),
              const SizedBox(height: 12),
              _tile("Yearly", total('Yearly'), Icons.bar_chart),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tile(String title, double value, IconData icon) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const Spacer(),
          Text(title, style: const TextStyle(fontSize: 12)),
          Text("₹${value.toInt()}",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
