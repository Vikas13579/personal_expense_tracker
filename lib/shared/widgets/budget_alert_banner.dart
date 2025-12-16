import 'package:flutter/material.dart';

class BudgetAlertBanner extends StatelessWidget {
  final double spent;
  final double budget;

  const BudgetAlertBanner({
    super.key,
    required this.spent,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final usage = spent / budget;

    if (usage < 0.7) return const SizedBox();

    final bool exceeded = usage >= 1.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: exceeded
            ? Colors.red.withOpacity(0.15)
            : Colors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: exceeded ? Colors.red : Colors.orange,
        ),
      ),
      child: Row(
        children: [
          Icon(
            exceeded ? Icons.warning_amber : Icons.info_outline,
            color: exceeded ? Colors.red : Colors.orange,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              exceeded
                  ? "Budget exceeded! You’ve spent more than your limit."
                  : "You’ve used over 70% of your monthly budget.",
              style: TextStyle(
                color: exceeded ? Colors.red : Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
