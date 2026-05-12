import 'package:book_life/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.steelBlue,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: AppColors.white, size: 40,),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        Icon(
          Icons.account_circle_outlined,
          color: AppColors.white,
          size: 40,
        ), // volto pra button quando tiver alguma finalidade
      ],
    );
  }
}
