import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'transaction_model.dart';

class DashboardViewModel extends ChangeNotifier {
  final Box<Transaction> _txBox =
  Hive.box<Transaction>('transactions');
  final Box<double> _budgetBox =
  Hive.box<double>('budget');

  DashboardViewModel() {
    _txBox.listenable().addListener(_onDataChanged);
    _budgetBox.listenable().addListener(_onDataChanged);
  }

  void _onDataChanged() {
    notifyListeners();
  }

  // 🔹 BUDGET (never null)
  double get budget => _budgetBox.get('monthly') ?? 0.0;

  // 🔹 MONTHLY SPENT
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

  // 🔹 REMAINING (budget - spent, never negative)
  double get remaining {
    final value = budget - spent;
    return value > 0 ? value : 0.0;
  }

  // 🔹 SAVED (alias of remaining – semantic clarity)
  double get saved => remaining;

  // 🔹 PROGRESS %
  double get percent {
    if (budget == 0) return 0.0;
    return (spent / budget).clamp(0.0, 1.0);
  }

  bool get isOverLimit => spent > budget;

  // 🔹 RECENT TRANSACTIONS
  List<Transaction> get recentTransactions {
    return _txBox.values.toList().reversed.take(5).toList();
  }

  // 🔹 ACTIONS
  void addTransaction(Transaction tx) {
    _txBox.add(tx);
  }

  void deleteTransaction(Transaction tx) {
    tx.delete();
  }

  void undoDelete(Transaction tx, int index) {
    if (index >= _txBox.length) {
      _txBox.add(tx);
    } else {
      _txBox.putAt(index, tx);
    }
  }

  void setBudget(double value) {
    _budgetBox.put('monthly', value);
  }

  @override
  void dispose() {
    _txBox.listenable().removeListener(_onDataChanged);
    _budgetBox.listenable().removeListener(_onDataChanged);
    super.dispose();
  }
}
