import 'package:book_life/app/router/routes.dart';
import 'package:book_life/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.steelBlue,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).closeDrawer(),
                icon: const Icon(Icons.close, color: AppColors.white, size: 35),
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
            onTap: () {},
          ), // adicione quando fizer tiver essa página
          SizedBox(height: 20),
          DrawerItem(
            icon: Icons.book_outlined,
            text: 'Biblioteca',
            onTap: () {
              Navigator.pop(context);
              context.go(Routes.library);
            },
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
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
          Icon(icon, color: AppColors.white),
          SizedBox(width: 15),
          Text(
            text,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight
                  .bold, // trocar pela fonte original depois, descobrir como faz
            ),
          ),
        ],
      ),
    );
  }
}
