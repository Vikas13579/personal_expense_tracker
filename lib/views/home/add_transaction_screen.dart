import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/transaction_model.dart';
import '../../../data/models/dashboard_viewmodel.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  void _save() {
    final title = _titleCtrl.text.trim();
    final amount = double.tryParse(_amountCtrl.text);

    if (title.isEmpty || amount == null || amount <= 0) return;

    final tx = Transaction(
      title: title,
      amount: amount,
      date: DateTime.now(),
      category: 'General',
    );

    context.read<DashboardViewModel>().addTransaction(tx);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
