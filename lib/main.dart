import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_expense_tracker/views/home/dashboard_screen.dart';
import 'package:provider/provider.dart';

import 'data/models/transaction_model.dart';
import 'data/models/dashboard_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TransactionAdapter());
  }

  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox<double>('budget');
  await Hive.openBox<String>('meta');

  await Hive.openBox<bool>('settings');

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: DashboardScreen(),
      ),
    );
  }
}
