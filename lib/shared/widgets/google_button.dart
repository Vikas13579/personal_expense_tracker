import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Image.asset('assets/google.png', height: 20),
      label: const Text("Continue with Google"),
      onPressed: () {
        // 🔴 STUB
        // Later replace with FirebaseAuth
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google sign-in coming soon")),
        );
      },
    );
  }
}
