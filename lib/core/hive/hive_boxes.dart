import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/transaction_model.dart';

class HiveBoxes {
  static Box<Transaction> transactions() =>
      Hive.box<Transaction>('transactions');

  static Box<double> budget() => Hive.box<double>('budget');

  static Box<String> meta() => Hive.box<String>('meta');
}
