import 'package:book_life/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.steelBlue,
          fontSize: 24,
          fontWeight: FontWeight.bold,
      ),
    )
    );
  }
}
