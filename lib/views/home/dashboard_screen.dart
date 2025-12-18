import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/dashboard_viewmodel.dart';
import '../../../shared/widgets/balance_card.dart';
import '../../../shared/widgets/recent_transactions.dart';
import '../../shared/widgets/add_transaction_bottom_sheet.dart';
import 'add_transaction_screen.dart';
import 'budget_screen.dart';
import 'insight.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2E),

      // ✅ DRAWER IS HERE
      drawer: _buildDrawer(context),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text("Dashboard"),
        centerTitle: true,

      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        onPressed: () {
          showAddTransactionSheet(context);
        },

      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BalanceCard(
                budget: vm.budget,
                spent: vm.spent,
                saved: vm.saved,
              ),

              const SizedBox(height: 24),

              const Text(
                "Recent Transactions",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              RecentTransactions(vm.recentTransactions),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 MODERN DRAWER
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1C1B2E), Color(0xFF2A2747)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Vikas Shetty",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    "Expense Tracker",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            _drawerItem(
              context,
              icon: Icons.account_balance_wallet,
              title: "Budget",
              screen: const BudgetScreen(),
            ),
            _drawerItem(
              context,
              icon: Icons.insights,
              title: "Insights",
              screen: const InsightsScreen(),
            ),
            _drawerItem(
              context,
              icon: Icons.bar_chart,
              title: "Reports",
              screen: const ReportsScreen(),
            ),
            _drawerItem(
              context,
              icon: Icons.settings,
              title: "Settings",
              screen: const SettingsScreen(),
            ),

            const Spacer(),

            _drawerItem(
              context,
              icon: Icons.logout,
              title: "Logout",
              screen: const SettingsScreen(),
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Widget screen,
        bool isLogout = false,
      }) {
    return ListTile(
      leading: Icon(icon,
          color: isLogout ? Colors.redAccent : Colors.white70),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.redAccent : Colors.white,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
    );
  }
}
