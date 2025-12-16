import 'package:flutter/material.dart';

import 'budget_dialog.dart';

class HeaderSection extends StatelessWidget {
  final double spent;
  final double? budget;
  final double percent;

  const HeaderSection(
      this.spent,
      this.budget,
      this.percent, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    final Color progressColor = percent >= 1.0
        ? Colors.red
        : percent >= 0.7
        ? Colors.orange
        : Colors.green;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Monthly Budget",
              style: TextStyle(color: Colors.white70),
            ),

            Text(
              budget == null
                  ? "Not set"
                  : "₹${(budget! - spent).toInt()} left",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            if (budget != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: SizedBox(
                  width: 160,
                  child: LinearProgressIndicator(
                    value: percent.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: Colors.white12,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                ),
              ),
          ],
        ),

        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () => showBudgetDialog(context),
        ),
      ],
    );
  }
}
