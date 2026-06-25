import 'package:book_life/app/router/routes.dart';
import 'package:book_life/core/widgets/drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).closeDrawer(),
                icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onPrimary, size: 35),
              ),
            ),
          ),

          Spacer(),
          DrawerItem(
            icon: Icons.settings_outlined,
            text: 'Ajustes',
            onTap: () {
              Navigator.pop(context);
              context.go(Routes.settings);
            },
          ),
          SizedBox(height: 20),
          DrawerItem(
            icon: Icons.bar_chart,
            text: 'Progresso',
            onTap: () {
              Navigator.pop(context);
              context.go(Routes.progress);
            },
          ),
          SizedBox(height: 20),
          DrawerItem(
            icon: Icons.flag,
            text: 'Metas',
            onTap: () {
              Navigator.pop(context);
              context.go(Routes.goals);
            },
          ),
          SizedBox(height: 20),
          DrawerItem(
            icon: Icons.book_outlined,
            text: 'Biblioteca',
            onTap: () {
              Navigator.pop(context);
              context.go(Routes.library);
            },
          ),
          SizedBox(height: 20),
          DrawerItem(
            icon: Icons.people_alt_outlined,
            text: 'Comunidade',
            onTap: () {
              Navigator.pop(context);
              context.go(Routes.community);
            },
          ),
          SizedBox(height: 20),
          DrawerItem(
            icon: Icons.emoji_events_outlined,
            text: 'Desafio Anual',
            onTap: () {
              Navigator.pop(context);
              context.go(Routes.challenges);
            },
          ),
          Spacer(),
        ],
      ),
    );
  }
}