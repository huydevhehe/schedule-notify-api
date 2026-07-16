import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryDark,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
    );
    return base.copyWith(
      textTheme: GoogleFonts.beVietnamProTextTheme(base.textTheme),
      cardTheme: base.cardTheme.copyWith(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryLight,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
    );
    return base.copyWith(
      textTheme: GoogleFonts.beVietnamProTextTheme(base.textTheme).apply(
        bodyColor: Colors.white70,
        displayColor: Colors.white,
      ),
      cardTheme: base.cardTheme.copyWith(
        elevation: 0,
        color: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }
}
