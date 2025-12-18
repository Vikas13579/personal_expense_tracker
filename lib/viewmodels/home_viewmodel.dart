// import 'package:flutter/material.dart';
// import '../data/models/transaction_model.dart';
// import '../data/repositories/transaction_repository.dart';
// import '../core/hive/hive_boxes.dart';
//
// class HomeViewModel extends ChangeNotifier {
//   final repo = TransactionRepository();
//
//   DateTime selectedMonth = DateTime.now();
//   String searchQuery = '';
//
//   Transaction? lastDeleted;
//
//   double? get budget => HiveBoxes.budget().get('monthly');
//
//   List<Transaction> get transactions {
//     return repo.byMonth(selectedMonth).where((t) =>
//         t.title.toLowerCase().contains(searchQuery.toLowerCase())
//     ).toList().reversed.toList();
//   }
//
//   double totalMonthly() =>
//       transactions.fold(0, (s, t) => s + t.amount);
//
//   void setBudget(double value) {
//     HiveBoxes.budget().put('monthly', value);
//     notifyListeners();
//   }
//
//   bool canAddExpense() {
//     return !(budget == null && HiveBoxes.transactions().isEmpty);
//   }
//
//   void addExpense(Transaction tx) {
//     repo.add(tx);
//     notifyListeners();
//   }
//
//   void deleteExpense(Transaction tx) {
//     lastDeleted = tx;
//     repo.delete(tx);
//     notifyListeners();
//   }
//
//   void undoDelete() {
//     if (lastDeleted != null) {
//       repo.undoDelete(lastDeleted!);
//       lastDeleted = null;
//       notifyListeners();
//     }
//   }
//
//   void changeMonth(int offset) {
//     selectedMonth =
//         DateTime(selectedMonth.year, selectedMonth.month + offset);
//     notifyListeners();
//   }
// }
