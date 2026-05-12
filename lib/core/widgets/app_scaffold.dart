import 'package:book_life/core/widgets/app_bar.dart';
import 'package:book_life/core/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, required this.body, this.floatingActionButton});

  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const AppDrawer(),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
