
import 'package:flutter/material.dart';
import '../core/hive/hive_boxes.dart';

class ChartsViewModel extends ChangeNotifier {
  DateTime selectedMonth = DateTime.now();

  Map<String, double> categoryData() {
    final data = <String, double>{};

    for (final t in HiveBoxes.transactions().values) {
      if (t.date.month == selectedMonth.month &&
          t.date.year == selectedMonth.year) {
        data[t.category] = (data[t.category] ?? 0) + t.amount;
      }
    }
    return data;
  }

  void changeMonth(int offset) {
    selectedMonth =
        DateTime(selectedMonth.year, selectedMonth.month + offset);
    notifyListeners();
  }
}
