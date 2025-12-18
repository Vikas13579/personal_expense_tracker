import 'package:flutter/material.dart';

class SummaryRow extends StatelessWidget {
  final double spent;

  const SummaryRow({super.key, required this.spent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _card("Spent", "₹${spent.toInt()}", Colors.redAccent),
        const SizedBox(width: 12),
        _card("Saved", "₹${(50000 - spent).toInt()}", Colors.green),
      ],
    );
  }

  Widget _card(String title, String value, Color color) {
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
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
