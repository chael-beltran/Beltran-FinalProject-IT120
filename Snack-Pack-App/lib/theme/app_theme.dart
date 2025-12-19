import 'package:flutter/material.dart';

/// App Color Palette - Snack + Tech Inspired
class AppColors {
  // Primary - Warm Cheddar Orange
  static const Color primary = Color(0xFFF5A623);
  static const Color primaryLight = Color(0xFFFFC857);
  static const Color primaryDark = Color(0xFFE8960F);

  // Secondary - Deep Chili Red
  static const Color secondary = Color(0xFFE74C3C);
  static const Color secondaryLight = Color(0xFFFF6B5B);
  static const Color secondaryDark = Color(0xFFC0392B);

  // Accent - Seafood Teal / Light Aqua
  static const Color accent = Color(0xFF5DADE2);
  static const Color accentLight = Color(0xFF85C1E9);
  static const Color accentDark = Color(0xFF3498DB);

  // Background
  static const Color background = Color(0xFFFDF8F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textMedium = Color(0xFF566573);
  static const Color textLight = Color(0xFF7F8C8D);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Category Colors (Background Tints)
  static const Color categoryCheese =
      Color(0xFFFFF3E0); // Warm cheese yellow tint
  static const Color categoryCheddar = Color(0xFFFFE0B2); // Deeper cheddar tint
  static const Color categoryBbq = Color(0xFFFFCCBC); // Smoky BBQ tint
  static const Color categorySpicy = Color(0xFFFFCDD2); // Hot red tint
  static const Color categorySeafood = Color(0xFFE0F7FA); // Ocean blue tint
  static const Color categoryClassic = Color(0xFFE8EAF6); // Classic purple tint
  static const Color categoryHamCheese = Color(0xFFFCE4EC); // Ham pink tint

  // Category Tag Colors (Labels)
  static const Color tagCheese = Color(0xFFF5A623); // Cheese yellow-orange
  static const Color tagCheddar = Color(0xFFE8960F); // Deep cheddar orange
  static const Color tagBbq = Color(0xFFD84315); // Smoky BBQ brown-red
  static const Color tagSpicy = Color(0xFFE53935); // Hot chili red
  static const Color tagSeafood = Color(0xFF0097A7); // Ocean teal
  static const Color tagClassic = Color(0xFF7E57C2); // Classic purple
  static const Color tagHamCheese = Color(0xFFE91E63); // Ham pink

  // Status Colors
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);

  // Confidence Bar Colors
  static const Color confidenceHigh = Color(0xFF27AE60);
  static const Color confidenceMedium = Color(0xFFF39C12);
  static const Color confidenceLow = Color(0xFFE74C3C);
}

/// App Text Styles
class AppTextStyles {
  static const String fontFamily = 'Roboto';

  // Headings
  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textDark,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textMedium,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textLight,
  );

  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Button
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
  );
}

/// App Theme Configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnPrimary,
        onSurface: AppColors.textDark,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textDark,
          side: const BorderSide(color: AppColors.textLight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.textDark),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
