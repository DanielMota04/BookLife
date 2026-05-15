import 'package:book_life/app/router/routes.dart';
import 'package:book_life/core/widgets/app_scaffold.dart';
import 'package:book_life/features/settings/views/widgets/page_title_widget.dart';
import 'package:book_life/features/settings/views/widgets/settings_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  final double space = 10;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageTitle(title: 'Ajustes'),

          SizedBox(height: space * 3),

          SettingsItem(
            text: 'Editar Perfil',
            onTap: () => context.push(Routes.editProfile),
          ),

          SizedBox(height: space),

          SettingsItem(
            text: 'Alterar Senha',
            onTap: () => context.push(Routes.changePassword),
          ),

          SizedBox(height: space),

          SettingsItem(
            text: 'Limpar Cache',
            onTap: () => {},
          ), // implementar função de limpar cache depois

          SizedBox(height: space),

          SettingsItem(text: 'Temas', onTap: () => context.push(Routes.themes)),

          SizedBox(height: space),

          SettingsItem(text: 'Sobre', onTap: () => context.push(Routes.about)),

          SizedBox(height: space),

          SettingsItem(
            text: 'Sair',
            onTap: () => {
              // implementar logout quando tiver pronto
              context.go(Routes.welcome),
            },
          ),
        ],
      ),
    );
  }
}
