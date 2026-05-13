import 'package:book_life/app/router/routes.dart';
import 'package:book_life/core/constants/app_colors.dart';
import 'package:book_life/features/auth/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.jetBlack,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppColors.paleSky,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => context.go(Routes.welcome),
                      icon: Icon(Icons.arrow_back, 
                      color: AppColors.jetBlack),
                    ),
                  ),

                  Text(
                    'CADASTRO',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: AppColors.jetBlack,
                    ),
                  ),

                  SizedBox(height: 15),

                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome Completo',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: UnderlineInputBorder(),
                      labelStyle: TextStyle(
                        color: AppColors.jetBlack,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: UnderlineInputBorder(),

                      labelStyle: TextStyle(
                        color: AppColors.jetBlack,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  TextField(
                    controller: _passwordController,
                    style: TextStyle(color: AppColors.jetBlack),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: UnderlineInputBorder(),

                      labelStyle: TextStyle(
                        color: AppColors.jetBlack,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Senha',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: UnderlineInputBorder(),

                      labelStyle: TextStyle(
                        color: AppColors.jetBlack,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.jetBlack,
                      foregroundColor: Colors.white,
                      minimumSize: Size(600, 60),
                    ),

                    onPressed: () {
                      context.go(Routes.library);
                    },
                    child: Text('CRIAR'),
                  ),

                  SizedBox(height: 20),

                  Text(
                    'Já possui uma Conta?',
                    style: TextStyle(color: AppColors.jetBlack2),
                  ),

                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.jetBlack,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                      context.go(Routes.login);
                    },
                    child: const Text('Fazer Login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
