import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/settings_viewmode.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1B2E),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Settings"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Consumer<SettingsViewModel>(
          builder: (_, vm, __) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _tile(
                  title: "Biometric Lock",
                  value: vm.biometricEnabled,
                  onChanged: vm.toggleBiometric,
                ),
                _tile(
                  title: "Dark Mode",
                  value: vm.darkMode,
                  onChanged: vm.toggleDarkMode,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _tile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF26243F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        activeColor: Colors.deepPurple,
      ),
    );
  }
}
