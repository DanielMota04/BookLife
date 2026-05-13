import 'package:flutter/material.dart';

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
      backgroundColor: Color(0XFF022B3A),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Color(0XFFBFDBF7),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                children: [
                  Text(
                    'CADASTRO',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF022B3A),
                    ),
                  ),

                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome Completo',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: UnderlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 15),

                  TextField(
                    controller: _emailController,
                    style: TextStyle(color: Color(0XFF022B3A)),
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      border: UnderlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 15),

                  TextField(
                    controller: _passwordController,
                    style: TextStyle(color: Color(0XFF022B3A)),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: UnderlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 15),

                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Senha',
                      border: UnderlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XFF022B3A),
                      foregroundColor: Colors.white,
                      minimumSize: Size(600, 60),
                    ),

                    onPressed: () {},
                    child: Text('CRIAR'),
                  ),

                  SizedBox(height: 20),

                  Text(
                    'Já possui uma Conta?',
                    style: TextStyle(color: Color(0xFF000000)),
                  ),

                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 12, 39, 88),
                      textStyle: const TextStyle(
                        fontSize: 15,
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
