import 'package:flutter/material.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';

class ReportsViewModel extends ChangeNotifier {
  final TransactionRepository _repo = TransactionRepository();

  Map<String, double> categoryData = {};
  double totalSpent = 0;
  int transactionCount = 0;
  String topCategory = '-';

  ReportsViewModel() {
    load();
  }

  void load() {
    final now = DateTime.now();
    final txns = _repo.getAll().where((t) =>
    t.date.month == now.month && t.date.year == now.year);

    categoryData.clear();
    totalSpent = 0;
    transactionCount = 0;

    for (final t in txns) {
      categoryData[t.category] =
          (categoryData[t.category] ?? 0) + t.amount;
      totalSpent += t.amount;
      transactionCount++;
    }

    double max = 0;
    categoryData.forEach((key, value) {
      if (value > max) {
        max = value;
        topCategory = key;
      }
    });

    notifyListeners();
  }
}
