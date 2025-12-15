import 'package:flutter/material.dart' hide SearchBar;
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/transaction_model.dart';
import '../../shared/widgets/bento_section.dart';
import '../../shared/widgets/category_pie.dart';
import '../../shared/widgets/expense_list.dart';
import '../../shared/widgets/header_section.dart';
import '../../shared/widgets/month_selector.dart';
import '../../shared/widgets/search_bar.dart';
import '../../shared/widgets/expense_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final box = Hive.box<Transaction>('transactions');
  final budgetBox = Hive.box<double>('budget');
  final metaBox = Hive.box<String>('meta');

  DateTime selectedMonth = DateTime.now();
  String searchQuery = '';

  double? get monthlyBudget => budgetBox.get('monthly');

  @override
  void initState() {
    super.initState();
    _checkMonthReset();
  }

  void _checkMonthReset() {
    final key = '${DateTime.now().year}-${DateTime.now().month}';
    metaBox.put('last_active_month', key);
  }

  double total(String type) {
    return box.values.where((t) {
      if (type == 'Daily') {
        return DateUtils.isSameDay(t.date, DateTime.now());
      }
      if (type == 'Monthly') {
        return t.date.month == selectedMonth.month &&
            t.date.year == selectedMonth.year;
      }
      return t.date.year == selectedMonth.year;
    }).fold(0.0, (sum, t) => sum + t.amount);
  }

  List<Transaction> filteredList() {
    return box.values
        .where((t) =>
    t.date.month == selectedMonth.month &&
        t.date.year == selectedMonth.year &&
        t.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList()
        .reversed
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          if (monthlyBudget == null && box.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please set the budget before adding expenses"),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          showExpenseSheet(context);
        },
      ),

      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([box.listenable(), budgetBox.listenable()]),
          builder: (_, __) {
            final spent = total('Monthly');
            final percent = monthlyBudget == null
                ? 0.0
                : (spent / monthlyBudget!).clamp(0.0, 1.0);

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  MonthSelector(
                    selectedMonth: selectedMonth,
                    onChange: (d) => setState(() => selectedMonth = d),
                  ),
                  const SizedBox(height: 16),
                  HeaderSection(spent, monthlyBudget, percent),
                  const SizedBox(height: 20),
                  BentoSection(total),
                  const SizedBox(height: 20),
                  SearchBar(onChange: (v) => setState(() => searchQuery = v)),
                  const SizedBox(height: 10),
                  Expanded(child: ExpenseList(filteredList())),
                  const SizedBox(height: 10),
                  CategoryPie(selectedMonth),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
