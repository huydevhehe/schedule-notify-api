import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primaryDark = Color(0xFF00478F);
  static const primaryLight = Color(0xFF2E9BE0);

  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primaryLight],
  );

  static const backgroundLight = Color(0xFFEFF7FF);
  static const backgroundDark = Color(0xFF0B1220);
  static const cardDark = Color(0xFF141B2A);

  static const important = Color(0xFFDC2626);
  static const importantBgLight = Color(0xFFFEE2E2);
  static const importantBgDark = Color(0xFF3A1414);

  static const iconBadgeLight = Color(0xFFE3F1FF);
  static const iconBadgeDark = Color(0xFF1E2A3D);
}
