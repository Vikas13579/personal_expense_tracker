import 'package:hive/hive.dart';

import '../models/transaction_model.dart';

class TransactionRepository {
  final _box = Hive.box<Transaction>('transactions');

  List<Transaction> getAll() =>
      _box.values.toList().reversed.toList();

  int indexOf(Transaction tx) {
    return _box.values.toList().indexOf(tx);
  }

  void add(Transaction tx) {
    _box.add(tx);
  }

  void insertAt(int? index, Transaction tx) {
    if (index == null || index < 0 || index >= _box.length) {
      _box.add(tx);
    } else {
      _box.putAt(index, tx);
    }
  }

  void delete(Transaction tx) {
    tx.delete();
  }

  double totalForMonth(DateTime date) {
    return _box.values
        .where((t) =>
    t.date.month == date.month &&
        t.date.year == date.year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }
}
