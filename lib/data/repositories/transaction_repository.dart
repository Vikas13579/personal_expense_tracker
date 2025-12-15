import '../../core/hive/hive_boxes.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final _box = HiveBoxes.transactions();

  List<Transaction> all() => _box.values.toList();

  void add(Transaction tx) => _box.add(tx);

  void update(Transaction tx) => tx.save();

  void delete(Transaction tx) => tx.delete();

  void undoDelete(Transaction tx) => _box.add(tx);

  List<Transaction> byMonth(DateTime month) {
    return _box.values.where((t) =>
    t.date.month == month.month &&
        t.date.year == month.year).toList();
  }
}
