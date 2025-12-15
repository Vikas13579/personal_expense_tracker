import 'package:flutter/material.dart';

import 'budget_dialog.dart';

class HeaderSection extends StatelessWidget {
  final double spent;
  final double? budget;
  final double percent;

  const HeaderSection(this.spent, this.budget, this.percent, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Monthly Budget", style: TextStyle(color: Colors.grey)),
          Text(
            budget == null
                ? "Not set"
                : "₹${(budget! - spent).toInt()} left",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          if (budget != null)
            SizedBox(
              width: 140,
              child: LinearProgressIndicator(value: percent),
            ),
        ]),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => showBudgetDialog(context),
        ),
      ],
    );
  }
}
