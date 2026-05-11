import 'package:book_life/core/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      drawer: AppDrawer(), //adicionado temporariamente para fins de teste.
      body: const Center(
        child: Text('Ajustes'),
      ),
    );
  }
}
