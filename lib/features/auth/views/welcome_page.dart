import 'package:book_life/core/constants/app_colors.dart';
import 'package:book_life/features/auth/views/login_page.dart';
import 'package:book_life/features/auth/views/register_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  void _painel(String tipo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
    
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),

          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: 
            tipo == 'login' 
            ? const LoginPage() 
            : const RegisterPage(),
          ),
          
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.jetBlack,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BookLife',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),

              SizedBox(height: 50),

              Text(
                'Bem Vindo',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),

              SizedBox(height: 25),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: AppColors.white, width: 3),
                  backgroundColor: AppColors.jetBlack,
                  foregroundColor: AppColors.white,
                  minimumSize: Size(600, 60),
                ),
                onPressed: () => _painel('login'), 
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 15),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lavender,
                  foregroundColor: AppColors.jetBlack,
                  minimumSize: Size(600, 60),
                ),
                onPressed: () => _painel('register'),
                child: Text(
                  'Cadastrar',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}