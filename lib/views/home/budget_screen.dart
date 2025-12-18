import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/dashboard_viewmodel.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2E),
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            const SizedBox(height: 30),
            _progress(vm),
            const SizedBox(height: 30),
            _stats(vm),
            const Spacer(),
            _setBudgetButton(context, vm),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A5AE0), Color(0xFF9D4EDD)],
        ),
        borderRadius:
        BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Text(
            "Monthly Budget",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _progress(DashboardViewModel vm) {
    final percent = vm.percent;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 180,
          width: 180,
          child: CircularProgressIndicator(
            value: percent,
            strokeWidth: 12,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation(
              vm.isOverLimit
                  ? Colors.redAccent
                  : Colors.greenAccent,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              vm.budget == 0
                  ? "No Budget"
                  : "${(percent * 100).toInt()}%",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text("Used",
                style: TextStyle(color: Colors.white70)),
          ],
        ),
      ],
    );
  }

  Widget _stats(DashboardViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _stat("Spent", vm.spent, Colors.redAccent),
          const SizedBox(width: 12),
          _stat("Budget", vm.budget, Colors.deepPurpleAccent),
          const SizedBox(width: 12),
          _stat("Remaining", vm.remaining, Colors.greenAccent),
        ],
      ),
    );
  }

  Widget _stat(String label, double value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF26243F),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            Text(
              "₹${value.toInt()}",
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _setBudgetButton(
      BuildContext context, DashboardViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: () => _showSetBudgetSheet(context, vm),
          child: const Text("Set / Update Budget"),
        ),
      ),
    );
  }

  void _showSetBudgetSheet(
      BuildContext context, DashboardViewModel vm) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF26243F),
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration:
                const InputDecoration(hintText: "Enter amount"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final value =
                  double.tryParse(controller.text);
                  if (value != null && value > 0) {
                    vm.setBudget(value);
                  }
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
        );
      },
    );
  }
}
