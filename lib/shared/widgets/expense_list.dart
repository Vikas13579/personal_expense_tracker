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
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final box = Hive.box<Transaction>('transactions');

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) {
        final t = list[i];

        return Dismissible(
          key: ValueKey(t.key),
          direction: DismissDirection.endToStart,

          onDismissed: (_) {
            // 1️⃣ COPY data (NOT HiveObject)
            final deletedCopy = Transaction(
              title: t.title,
              amount: t.amount,
              date: t.date,
              category: t.category,
            );

            // 2️⃣ Capture index BEFORE delete
            final deletedIndex = box.values.toList().indexOf(t);

            // 3️⃣ Delete original HiveObject
            t.delete();

            // 4️⃣ Show snackbar with REAL undo
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Expense deleted"),
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    // Restore safely
                    if (deletedIndex >= box.length) {
                      box.add(deletedCopy);
                    } else {
                      box.putAt(deletedIndex, deletedCopy);
                    }
                  },
                ),
              ),
            );
          },

          background: Container(
            alignment: Alignment.centerRight,
            color: Colors.red,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),

          child: ListTile(
            onLongPress: () => showExpenseSheet(context, edit: t),
            title: Text(t.title),
            subtitle: Text(t.category),
            trailing: Text(
              "-₹${t.amount.toInt()}",
              style: const TextStyle(color: Colors.red),
            ),
          ),
        );
      },
    );
  }
}
