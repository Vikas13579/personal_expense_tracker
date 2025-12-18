import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'transaction_model.dart';

class BudgetViewModel extends ChangeNotifier {
  final Box<double> _budgetBox = Hive.box<double>('budget');
  final Box<Transaction> _txBox = Hive.box<Transaction>('transactions');

  /// ✅ NEVER NULL — UI FRIENDLY
  double get budget => _budgetBox.get('monthly') ?? 0.0;

  double get spent {
    final now = DateTime.now();
    return _txBox.values
        .where(
          (t) =>
      t.date.year == now.year &&
          t.date.month == now.month,
    )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get remaining {
    final value = budget - spent;
    return value > 0 ? value : 0.0;
  }

  double get percent {
    if (budget == 0) return 0.0;
    return (spent / budget).clamp(0.0, 1.0);
  }

  bool get isOverLimit => spent > budget;

  void setBudget(double value) {
    _budgetBox.put('monthly', value);
    notifyListeners();
  }
}
