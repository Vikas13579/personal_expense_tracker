import 'package:hive_flutter/hive_flutter.dart';

class BudgetRepository {
  final Box<double> _box = Hive.box<double>('budget');

  double? getMonthlyBudget() {
    return _box.get('monthly');
  }

  void setMonthlyBudget(double value) {
    _box.put('monthly', value);
  }
}
