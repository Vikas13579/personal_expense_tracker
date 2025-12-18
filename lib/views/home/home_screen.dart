import 'package:flutter/material.dart' hide SearchBar;
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/transaction_model.dart';
import '../../shared/widgets/bento_section.dart';
import '../../shared/widgets/expense_list.dart';
import '../../shared/widgets/header_section.dart';
import '../../shared/widgets/search_bar.dart';
import '../../shared/widgets/expense_bottom_sheet.dart';
import '../charts/report_screen.dart';
import 'insights_screen.dart';

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
        .where(
          (t) =>
      t.date.month == selectedMonth.month &&
          t.date.year == selectedMonth.year &&
          t.title.toLowerCase().contains(searchQuery.toLowerCase()),
    )
        .toList()
        .reversed
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7B5CFA),
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

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1C1B2E), Color(0xFF2A2747)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation:
            Listenable.merge([box.listenable(), budgetBox.listenable()]),
            builder: (_, __) {
              final spent = total('Monthly');
              final percent = monthlyBudget == null
                  ? 0.0
                  : (spent / monthlyBudget!).clamp(0.0, 1.0);

              return Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1C1B2E),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                      ),
                      child: Column(
                        children: [
                          HeaderSection(spent, monthlyBudget, percent),
                          const SizedBox(height: 16),
                          BentoSection(total),
                          const SizedBox(height: 20),
                          SearchBar(
                            onChange: (v) =>
                                setState(() => searchQuery = v),
                          ),
                          const SizedBox(height: 12),
                          Expanded(child: ExpenseList(filteredList())),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // 🔷 HEADER
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A5AE0), Color(0xFF9D4EDD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Welcome back 👋",
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 4),
              Text(
                "Vikas",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Spacer(),
          const CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // 🔷 DRAWER
  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1C1B2E), Color(0xFF2A2747)],
          ),
        ),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A5AE0), Color(0xFF9D4EDD)],
                ),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Vikas Shetty",
                          style: TextStyle(color: Colors.white)),
                      Text("Expense Tracker",
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),


            _drawerItem(
              Icons.lightbulb,
              "Insights",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InsightsScreen(),
                  ),
                );
              },
            ),
            _drawerItem(
              Icons.account_balance_wallet,
              "Set Budget",

            ),

            // _drawerItem(
            //   Icons.bar_chart,
            //   "Reports",
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) => const ReportsScreen(),
            //       ),
            //     );
            //   },
            // ),

            const Spacer(),

            _drawerItem(
              Icons.logout,
              "Logout",
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  // 🔷 DRAWER ITEM
  Widget _drawerItem(
      IconData icon,
      String title, {
        bool isLogout = false,
        VoidCallback? onTap,
      }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : Colors.white70,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.white,
        ),
      ),
      onTap: onTap ?? () => Navigator.pop(context),
    );
  }
}
