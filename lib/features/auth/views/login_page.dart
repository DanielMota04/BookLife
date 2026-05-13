import 'package:book_life/app/router/routes.dart';
import 'package:book_life/core/constants/app_colors.dart';
import 'package:book_life/features/auth/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: AppColors.jetBlack,
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
                    child: Text('LOGAR'),
                  ),

                  SizedBox(height: 20),

                  Text(
                    'Não possui conta ainda?',
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
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                      context.go(Routes.login);
                    },
                    child: const Text('Cadastre-se'),
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
