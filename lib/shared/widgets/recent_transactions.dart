import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/transaction_model.dart';
import '../../data/models/dashboard_viewmodel.dart';

class RecentTransactions extends StatelessWidget {
  final List<Transaction> list;

  const RecentTransactions(this.list, {super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<DashboardViewModel>();

    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(
          child: Text(
            "No transactions yet",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) {
        final tx = list[index];

        return Dismissible(
          key: ValueKey(tx.key),
          direction: DismissDirection.endToStart,

          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.only(right: 20),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),

          onDismissed: (_) {
            // 🔹 Copy transaction (HiveObject can't be reused)
            final deletedCopy = Transaction(
              title: tx.title,
              amount: tx.amount,
              date: tx.date,
              category: tx.category,
            );

            final deletedIndex = index;

            vm.deleteTransaction(tx);

            final messenger = ScaffoldMessenger.of(context);
            messenger.clearSnackBars();

            Timer? forceCloseTimer;

            // 🔥 HARD FORCE close after 3 seconds
            forceCloseTimer = Timer(const Duration(seconds: 3), () {
              messenger.hideCurrentSnackBar();
            });

            messenger.showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),

                // ⛔ duration intentionally ignored
                duration: const Duration(days: 1),

                content: const Text("Transaction deleted"),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    forceCloseTimer?.cancel();
                    vm.undoDelete(deletedCopy, deletedIndex);
                    messenger.hideCurrentSnackBar();
                  },
                ),
              ),
            );
          },

          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                  Colors.deepPurple.withOpacity(0.12),
                  child: const Icon(
                    Icons.receipt_long,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tx.category,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "-₹${tx.amount.toInt()}",
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
