import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthSelector extends StatelessWidget {
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onChange;

  const MonthSelector({
    super.key,
    required this.selectedMonth,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            onChange(DateTime(selectedMonth.year, selectedMonth.month - 1));
          },
        ),
        Text(
          DateFormat('MMMM yyyy').format(selectedMonth),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            final next =
            DateTime(selectedMonth.year, selectedMonth.month + 1);
            if (next.isAfter(DateTime.now())) return;
            onChange(next);
          },
        ),
      ],
    );
  }
}
