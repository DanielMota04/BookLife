import 'package:book_life/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.steelBlue,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).closeDrawer(),
              icon: const Icon(Icons.close, color: AppColors.white),
            ),
          ),
          Spacer(),
          DrawerItem(icon: Icons.settings_outlined, text: 'Ajustes'),
          SizedBox(height: 20),
          DrawerItem(icon: Icons.bar_chart, text: 'Progresso'),
          SizedBox(height: 20),
          DrawerItem(icon: Icons.flag, text: 'Metas'),
          SizedBox(height: 20),
          DrawerItem(icon: Icons.book_outlined, text: 'Biblioteca'),
          Spacer(),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
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
            fontWeight: FontWeight.bold, // trocar pela fonte original depois, descobrir como faz
          ),
        ),
      ],
    );
  }
}
