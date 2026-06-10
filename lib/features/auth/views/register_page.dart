import 'package:book_life/app/router/routes.dart';
import 'package:book_life/core/constants/app_colors.dart';
import 'package:book_life/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback? onGoToRegister;
  const RegisterPage({super.key, this.onGoToRegister});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
    final viewmodel = context.watch<RegisterViewModel>();
    final loginVM = context.watch<LoginViewModel>();
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
                    'CADASTRO',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: AppColors.jetBlack,
                    ),
                  ),

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

                  SizedBox(height: 5),

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

                  SizedBox(height: 5),

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

                  TextField(
                    controller: _confirmPasswordController,
                    style: TextStyle(color: AppColors.jetBlack),
                    obscureText: _obscureConfirmPassword,

                    decoration: InputDecoration(
                      labelText: 'Confirmar Senha',
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
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.jetBlack,
                        ),
                      ),
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
                            await viewmodel.register(
                              name: _nameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              confirmPassword: _confirmPasswordController.text,
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
                    child: Text('CRIAR'),
                  ),

                  SizedBox(height: 15),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                  IconButton(
                    onPressed: loginVM.isLoading
                        ? null
                        : () async {
                            await loginVM.loginWithGoogle();
                            if (!mounted) return;
                            if (loginVM.errorMessage == null) {
                              context.go(Routes.library);
                            }
                            if (loginVM.errorMessage != null) {
                              showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.error(
                                  message: loginVM.errorMessage!,
                                ),
                              );
                            }
                          },

                    iconSize: 30,
                    icon: SvgPicture.asset('assets/images/GoogleIcon.svg'),
                  ),

                      Text("ou",style: TextStyle(color: AppColors.jetBlack, fontSize: 20)),

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
                        child: const Text('Já possui uma Conta?'),
                      ),
                    ],
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
