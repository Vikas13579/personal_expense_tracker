import 'package:flutter/material.dart';

class SpendingComparisonCard extends StatelessWidget {
  final double currentMonth;
  final double lastMonth;

  const SpendingComparisonCard({
    super.key,
    required this.currentMonth,
    required this.lastMonth,
  });

  @override
  Widget build(BuildContext context) {
    if (lastMonth <= 0) return const SizedBox();

    final difference = currentMonth - lastMonth;
    final percent =
    ((difference.abs() / lastMonth) * 100).clamp(0, 999);

    final bool isIncrease = difference > 0;

    final Color color = isIncrease ? Colors.red : Colors.green;
    final IconData icon =
    isIncrease ? Icons.trending_up : Icons.trending_down;

    final String message = isIncrease
        ? "You spent ₹${difference.toInt()} more than last month"
        : "You saved ₹${difference.abs().toInt()} compared to last month";

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2747),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${percent.toStringAsFixed(1)}% ${isIncrease ? "increase" : "decrease"}",
                  style: TextStyle(
                    color: color.withOpacity(0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
