import 'package:book_life/app/app_theme.dart';
import 'package:book_life/core/theme/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'router/app_router.dart';

class BookLifeApp extends StatelessWidget {
  const BookLifeApp({super.key});
  
  @override
    Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, _) {
          return MaterialApp.router(
            title: 'BookLife',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeNotifier.mode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
