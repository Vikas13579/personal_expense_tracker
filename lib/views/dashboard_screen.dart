// import 'package:flutter/material.dart' hide SearchBar;
// import 'package:hive_flutter/hive_flutter.dart';
//
// import '../../data/models/transaction_model.dart';
// import '../../shared/widgets/bento_section.dart';
// import '../../shared/widgets/expense_list.dart';
// import '../../shared/widgets/header_section.dart';
// import '../../shared/widgets/search_bar.dart';
// import '../../shared/widgets/expense_bottom_sheet.dart';
// import '../../shared/widgets/budget_alert_banner.dart';
// import '../../shared/widgets/spending_comparison_card.dart';
//
// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   final box = Hive.box<Transaction>('transactions');
//   final budgetBox = Hive.box<double>('budget');
//   final metaBox = Hive.box<String>('meta');
//
//   String searchQuery = '';
//
//   double? get monthlyBudget => budgetBox.get('monthly');
//
//   @override
//   void initState() {
//     super.initState();
//     _checkMonthReset();
//   }
//
//   void _checkMonthReset() {
//     final key = '${DateTime.now().year}-${DateTime.now().month}';
//     metaBox.put('last_active_month', key);
//   }
//
//   double total(String type) {
//     final now = DateTime.now();
//
//     return box.values.where((t) {
//       if (type == 'Daily') {
//         return DateUtils.isSameDay(t.date, now);
//       }
//       if (type == 'Monthly') {
//         return t.date.month == now.month && t.date.year == now.year;
//       }
//       return t.date.year == now.year;
//     }).fold(0.0, (sum, t) => sum + t.amount);
//   }
//
//   double _monthlyTotal(DateTime month) {
//     return box.values
//         .where((t) =>
//     t.date.month == month.month &&
//         t.date.year == month.year)
//         .fold(0.0, (sum, t) => sum + t.amount);
//   }
//
//   List<Transaction> filteredList() {
//     final now = DateTime.now();
//
//     return box.values
//         .where((t) =>
//     t.date.month == now.month &&
//         t.date.year == now.year &&
//         t.title.toLowerCase().contains(searchQuery.toLowerCase()))
//         .toList()
//         .reversed
//         .toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation:
//       Listenable.merge([box.listenable(), budgetBox.listenable()]),
//       builder: (_, __) {
//         final spent = total('Monthly');
//         final percent = monthlyBudget == null
//             ? 0.0
//             : (spent / monthlyBudget!).clamp(0.0, 1.0);
//
//         final now = DateTime.now();
//         final lastMonth = DateTime(now.year, now.month - 1);
//
//         final currentMonthSpent = _monthlyTotal(now);
//         final lastMonthSpent = _monthlyTotal(lastMonth);
//
//         return Column(
//           children: [
//             HeaderSection(spent, monthlyBudget, percent),
//
//             if (monthlyBudget != null)
//               BudgetAlertBanner(
//                 spent: spent,
//                 budget: monthlyBudget!,
//               ),
//
//             SpendingComparisonCard(
//               currentMonth: currentMonthSpent,
//               lastMonth: lastMonthSpent,
//             ),
//
//             BentoSection(total),
//             const SizedBox(height: 16),
//
//             SearchBar(
//               onChange: (v) => setState(() => searchQuery = v),
//             ),
//             const SizedBox(height: 12),
//
//             Expanded(
//               child: ExpenseList(filteredList()),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
