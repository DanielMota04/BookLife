import 'package:book_life/app/router/routes.dart';
import 'package:book_life/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: [
          SettingsItem(text: 'Editar Perfil', onTap: () => context.go(Routes.editProfile)),
          SettingsItem(text: 'Alterar Senha', onTap: () => context.go(Routes.changePassword)),
          SettingsItem(text: 'Limpar Cache', onTap: () => {}), // implementar função de limpar cache depois
          SettingsItem(text: 'Temas', onTap: () => context.go(Routes.themes)),
          SettingsItem(text: 'Sobre', onTap: () => context.go(Routes.about)),
          SettingsItem(text: 'Sair', onTap: () => {
            // implementar logout quando tiver pronto
            context.go(Routes.welcome)
          })
        ],
      )
    );
  }
}


class SettingsItem extends StatelessWidget {
  const SettingsItem({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 15),
          Text(text),
        ],
      ),
    );
  }
}