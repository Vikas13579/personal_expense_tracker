import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.black),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Expense Tracker",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),

          ListTile(
            leading: const Icon(Icons.pie_chart),
            title: const Text("Charts"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/charts');
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              // future use
            },
          ),
        ],
      ),
    );
  }
}
