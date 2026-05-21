import 'package:book_life/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: _light,
    scaffoldBackgroundColor: AppColors.white,
    textTheme: GoogleFonts.inriaSansTextTheme(),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: _dark,
    scaffoldBackgroundColor: AppColors.jetBlack,
    textTheme: GoogleFonts.inriaSansTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ),
  );

  static const _light = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.steelBlue,
    onPrimary: AppColors.white,
    secondary: AppColors.teal,
    onSecondary: AppColors.white,
      tertiary:   AppColors.malachite,
  onTertiary: AppColors.green,
    surface: AppColors.white,
    onSurface: AppColors.jetBlack,
    surfaceContainerHighest: AppColors.lavender,
    onSurfaceVariant: AppColors.ironGrey,
    error: AppColors.error,
    onError: AppColors.white,
  );

  static final _dark = ColorScheme.fromSeed(
    seedColor: AppColors.steelBlue,
    brightness: Brightness.dark,
  );
}
