import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/transaction_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TransactionAdapter());
    }

    await Hive.openBox<Transaction>('transactions');
    await Hive.openBox<double>('budget');
    await Hive.openBox<String>('meta');
  }
}
