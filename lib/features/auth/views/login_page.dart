import 'package:book_life/app/router/routes.dart';
import 'package:book_life/core/constants/app_colors.dart';
import 'package:book_life/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onGoToRegister;
  const LoginPage({super.key, this.onGoToRegister});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<LoginViewModel>();
    return Material(
      color: AppColors.paleSky,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              padding: EdgeInsets.all(40),

              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(Icons.arrow_back, color: AppColors.jetBlack),
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
                    obscureText: _obscurePassword,

                    decoration: InputDecoration(
                      labelText: 'Senha',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: UnderlineInputBorder(),

                      labelStyle: TextStyle(
                        color: AppColors.jetBlack,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.jetBlack,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 5),

                  Align(
                    alignment: AlignmentGeometry.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.jetBlack,
                        textStyle: const TextStyle(
                          decoration: TextDecoration.underline,
                          decorationThickness: 2,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("Esqueci a senha"),
                    ),
                  ),

                  SizedBox(height: 15),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.jetBlack,
                      foregroundColor: Colors.white,
                      minimumSize: Size(600, 60),
                    ),

                    onPressed: viewmodel.isLoading
                        ? null
                        : () async {
                            await viewmodel.login(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            if (!mounted) return;
                            if (viewmodel.errorMessage == null) {
                              context.go(Routes.library);
                            }
                            if (viewmodel.errorMessage != null) {
                              showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.error(
                                  message: viewmodel.errorMessage!,
                                ),
                              );
                            }
                          },

                    child: Text('LOGAR'),
                  ),

                  SizedBox(height: 5),

                  Text(
                    'ou',
                    style: TextStyle(color: AppColors.jetBlack, fontSize: 20),
                  ),

                  SizedBox(height: 5),

                  IconButton(
                    onPressed: () {
                      // loginGoogle
                    },
                    iconSize: 30,
                    icon: SvgPicture.asset('assets/images/GoogleIcon.svg'),
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Não possui conta ainda?',
                    style: TextStyle(color: AppColors.jetBlack),
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
                      widget.onGoToRegister?.call();
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
