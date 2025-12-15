import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/transaction_model.dart';

void showExpenseSheet(BuildContext context, {Transaction? edit}) {
  final box = Hive.box<Transaction>('transactions');
  final title = TextEditingController(text: edit?.title ?? '');
  final amount =
  TextEditingController(text: edit?.amount.toString() ?? '');
  String category = edit?.category ?? 'Food';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(edit == null ? "Add Expense" : "Edit Expense"),
          TextField(controller: title, decoration: const InputDecoration(labelText: "Title")),
          TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Amount")),
          Wrap(
            spacing: 8,
            children: ['Food', 'Travel', 'Recharges', 'Entertainment']
                .map((e) => ChoiceChip(
              label: Text(e),
              selected: category == e,
              onSelected: (_) => setState(() => category = e),
            ))
                .toList(),
          ),
          ElevatedButton(
            onPressed: () {
              if (edit == null) {
                box.add(Transaction(
                  title: title.text,
                  amount: double.parse(amount.text),
                  date: DateTime.now(),
                  category: category,
                ));
              } else {
                edit
                  ..title = title.text
                  ..amount = double.parse(amount.text)
                  ..category = category
                  ..save();
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ]),
      ),
    ),
  );
}
