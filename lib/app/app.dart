import 'package:book_life/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'router/app_router.dart';

class BookLifeApp extends StatelessWidget {
  const BookLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BookLife',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.white,
      ),
      routerConfig: appRouter,
    );
  }
}
