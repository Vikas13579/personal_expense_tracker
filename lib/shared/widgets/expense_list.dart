import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/transaction_model.dart';
import 'expense_bottom_sheet.dart';

class ExpenseList extends StatelessWidget {
  final List<Transaction> list;

  const ExpenseList(this.list, {super.key});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(
        child: Text(
          "No expenses found 💸",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    final box = Hive.box<Transaction>('transactions');
    final messenger = ScaffoldMessenger.of(context);

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final t = list[i];

        return Dismissible(
          key: ValueKey(t.key),
          direction: DismissDirection.endToStart,

          onDismissed: (_) {
            // 🔒 Create safe copy (HiveObject must not be reused)
            final deletedCopy = Transaction(
              title: t.title,
              amount: t.amount,
              date: t.date,
              category: t.category,
            );

            final deletedIndex = box.values.toList().indexOf(t);

            // Delete original
            t.delete();

            // Ensure only one snackbar exists
            messenger.clearSnackBars();

            // Show snackbar (BOTTOM, Material default)
            messenger.showSnackBar(
              SnackBar(
                content: const Text("Expense deleted"),
                duration: const Duration(seconds: 5), // visual hint
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    if (deletedIndex >= box.length) {
                      box.add(deletedCopy);
                    } else {
                      box.putAt(deletedIndex, deletedCopy);
                    }

                    // Close immediately on undo
                    messenger.hideCurrentSnackBar(
                      reason: SnackBarClosedReason.action,
                    );
                  },
                ),
              ),
            );

            // 🧨 HARD STOP — guarantees max 5 seconds
            Timer(const Duration(seconds: 5), () {
              messenger.hideCurrentSnackBar(
                reason: SnackBarClosedReason.timeout,
              );
            });
          },

          background: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),

          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

              onLongPress: () => showExpenseSheet(context, edit: t),

              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple.withOpacity(0.1),
                child: const Icon(
                  Icons.receipt_long,
                  color: Colors.deepPurple,
                ),
              ),

              title: Text(
                t.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),

              subtitle: Text(
                t.category,
                style: const TextStyle(color: Colors.black54),
              ),

              trailing: Text(
                "-₹${t.amount.toInt()}",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
