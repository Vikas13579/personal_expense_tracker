import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';

enum InsightRange { daily, monthly, yearly }

class InsightsViewModel extends ChangeNotifier {
  final TransactionRepository _repo = TransactionRepository();

  InsightRange selectedRange = InsightRange.monthly;

  Map<String, double> chartData = {};
  List<Transaction> recent = [];

  InsightsViewModel() {
    load();
  }

  void changeRange(InsightRange range) {
    selectedRange = range;
    load();
  }

  void load() {
    chartData = _groupedData();
    recent = _repo.getAll().reversed.take(5).toList();
    notifyListeners();
  }

  Map<String, double> _groupedData() {
    final now = DateTime.now();
    final Map<String, double> map = {};

    for (final t in _repo.getAll()) {
      String key;

      switch (selectedRange) {
        case InsightRange.daily:
          if (!DateUtils.isSameDay(t.date, now)) continue;
          key = DateFormat('HH').format(t.date);
          break;

        case InsightRange.monthly:
          if (t.date.month != now.month || t.date.year != now.year) continue;
          key = DateFormat('dd').format(t.date);
          break;

        case InsightRange.yearly:
          if (t.date.year != now.year) continue;
          key = DateFormat('MMM').format(t.date);
          break;
      }

      map[key] = (map[key] ?? 0) + t.amount;
    }

    return map;
  }
}
