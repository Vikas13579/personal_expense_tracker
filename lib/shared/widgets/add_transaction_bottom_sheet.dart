import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/transaction_model.dart';
import '../../data/models/dashboard_viewmodel.dart';

void showAddTransactionSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AddTransactionSheet(),
  );
}

class _AddTransactionSheet extends StatefulWidget {
  const _AddTransactionSheet();

  @override
  State<_AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<_AddTransactionSheet> {
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  String _category = 'Food';

  final _categories = const [
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Entertainment',
    'Other',
  ];

  void _save() {
    final title = _titleCtrl.text.trim();
    final amount = double.tryParse(_amountCtrl.text);

    if (title.isEmpty || amount == null || amount <= 0) return;

    final tx = Transaction(
      title: title,
      amount: amount,
      date: DateTime.now(),
      category: _category,
    );

    context.read<DashboardViewModel>().addTransaction(tx);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.6;

    return Container(
      height: height,
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF26243F), // ✅ DIFFERENT FROM DASHBOARD
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 20,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Drag handle
          Center(
            child: Container(
              width: 48,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const Text(
            "Add Expense",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          _inputField("Title", _titleCtrl),
          const SizedBox(height: 12),
          _inputField("Amount", _amountCtrl, isNumber: true),

          const SizedBox(height: 20),

          const Text(
            "Category",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((c) {
              final selected = c == _category;
              return ChoiceChip(
                label: Text(c),
                selected: selected,
                selectedColor: Colors.deepPurple,
                backgroundColor: Colors.white10,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.white70,
                ),
                onSelected: (_) {
                  setState(() => _category = c);
                },
              );
            }).toList(),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _save,
              child: const Text(
                "Save Expense",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(
      String label,
      TextEditingController controller, {
        bool isNumber = false,
      }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
