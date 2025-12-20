import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/auth_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController(); // ✅ THIS WAS MISSING

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2E),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Create Account",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            _field("Full Name", controller: nameCtrl),
            const SizedBox(height: 16),

            _field("Email", controller: emailCtrl),
            const SizedBox(height: 16),

            _field("Password",
                controller: passCtrl, obscure: true),
            const SizedBox(height: 16),

            _field("Confirm Password",
                controller: confirmCtrl, obscure: true),
            const SizedBox(height: 30),

            _gradientButton(
              text: "Sign Up",
              onTap: () {
                final error = auth.signup(
                  name: nameCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                  password: passCtrl.text.trim(),
                  confirmPassword: confirmCtrl.text.trim(),
                );

                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                } else {
                  Navigator.pop(context); // back to login
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
      String hint, {
        required TextEditingController controller,
        bool obscure = false,
      }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF2A2747),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _gradientButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6A5AE0), Color(0xFF9D4EDD)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
