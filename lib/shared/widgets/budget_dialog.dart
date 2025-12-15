import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void showBudgetDialog(BuildContext context) {
  final box = Hive.box<double>('budget');
  final c = TextEditingController(text: box.get('monthly')?.toString() ?? '');

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Set Monthly Budget"),
      content: TextField(controller: c, keyboardType: TextInputType.number),
      actions: [
        TextButton(
          onPressed: () {
            box.put('monthly', double.parse(c.text));
            Navigator.pop(context);
          },
          child: const Text("Save"),
        )
      ],
    ),
  );
}
