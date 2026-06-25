import 'package:book_life/core/theme/theme_notifier.dart'; // ajuste o caminho
import 'package:book_life/core/widgets/app_scaffold.dart';
import 'package:book_life/features/settings/views/widgets/page_title_widget.dart';
import 'package:book_life/features/settings/views/widgets/theme_page_widgets/theme_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemesPage extends StatelessWidget {
  const ThemesPage({super.key});

  final double space = 10;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final modoAtual = themeNotifier.mode;

    return CustomScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageTitle(title: 'Temas'),

          SizedBox(height: space * 3),

          ThemeItem(
            text: 'Claro',
            selected: modoAtual == ThemeMode.light,
            onTap: () => themeNotifier.setMode(ThemeMode.light),
          ),

          SizedBox(height: space),

          ThemeItem(
            text: 'Escuro',
            selected: modoAtual == ThemeMode.dark,
            onTap: () => themeNotifier.setMode(ThemeMode.dark),
          ),

          SizedBox(height: space),

          ThemeItem(
            text: 'Seguir o sistema',
            selected: modoAtual == ThemeMode.system,
            onTap: () => themeNotifier.setMode(ThemeMode.system),
          ),
        ],
      ),
    );
  }
}
