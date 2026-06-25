import 'package:book_life/app/router/routes.dart';
import 'package:book_life/features/settings/viewmodels/logout_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Future<void> confirmLogout(BuildContext context) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Sair'),
      content: const Text('Deseja realmente sair?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Sair'),
        ),
      ],
    ),
  );

  if (confirm != true) return;
  if (!context.mounted) return;

  final viewmodel = context.read<LogoutViewModel>();
  await viewmodel.logout();

  if (!context.mounted) return;

  if (viewmodel.isSuccess) {
    context.go(Routes.welcome);
  } else if (viewmodel.errorMessage != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(viewmodel.errorMessage!),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}