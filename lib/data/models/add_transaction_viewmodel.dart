import 'package:flutter/material.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';

class AddTransactionViewModel extends ChangeNotifier {
  final TransactionRepository _repo = TransactionRepository();

  String title = '';
  String category = 'Food';
  DateTime date = DateTime.now();
  double amount = 0;

  void setAmount(String value) {
    amount = double.tryParse(value) ?? amount;
    notifyListeners();
  }

  void appendDigit(String digit) {
    final current = amount.toStringAsFixed(0);
    amount = double.parse(current + digit);
    notifyListeners();
  }

  void clear() {
    amount = 0;
    notifyListeners();
  }

  void setCategory(String value) {
    category = value;
    notifyListeners();
  }

  void save() {
    if (amount <= 0) return;

    _repo.add(
      Transaction(
        title: category,
        amount: amount,
        category: category,
        date: date,
      ),
    );
  }
}
