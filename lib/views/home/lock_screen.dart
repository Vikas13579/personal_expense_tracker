import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/auth_viewmodel.dart';
import 'dashboard_screen.dart';


class LockScreen extends StatelessWidget {
  const LockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1B2E),
        body: Consumer<AuthViewModel>(
          builder: (context, vm, _) {
            if (vm.isAuthenticated) {
              return  DashboardScreen();
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.fingerprint,
                    size: 90,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Unlock with Biometrics",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                    ),
                    onPressed: vm.authenticateWithBiometric,
                    child: const Text("Authenticate"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
