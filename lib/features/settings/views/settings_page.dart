import 'package:book_life/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(body: const Center(child: Text('Ajustes')));
  }
}
