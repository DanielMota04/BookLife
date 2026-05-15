import 'package:book_life/core/widgets/button.dart';
import 'package:book_life/features/settings/views/widgets/change_password_input.dart';
import 'package:book_life/features/settings/views/widgets/page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();


  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back, size: 28),
              ),

              PageTitle(title: 'Alterar Senha'),

              SizedBox(height: 35),

              ChangePasswordInput(controller: _currentPasswordController, hint: 'Senha Atual', obscureText: true),

              SizedBox(height: 25),

              ChangePasswordInput(controller: _newPasswordController, hint: 'Nova Senha', obscureText: true),

              SizedBox(height: 25),

              Button(
                text: 'Salvar',
                onPressed: () {
                  // implementar função de salvar alterações depois
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
