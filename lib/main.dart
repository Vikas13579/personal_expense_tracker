import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_expense_tracker/views/home/login_screen.dart';
import 'package:provider/provider.dart';

import 'data/models/auth_model.dart';
import 'data/models/dashboard_viewmodel.dart';
import 'data/models/transaction_model.dart';

import 'views/home/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TransactionAdapter());
  }

  // 🔐 OPEN BOXES ONCE — NEVER AGAIN
  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox<double>('budget');
  await Hive.openBox<Map>('users');
  await Hive.openBox<String>('session');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: auth.isLoggedIn
          ?  DashboardScreen()
          : const LoginScreen(),
    );
  }
}
