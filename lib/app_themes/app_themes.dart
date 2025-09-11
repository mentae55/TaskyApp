import 'package:flutter/material.dart';

class AppThemes {
  static final darkColors = _AppColors(
    primary: Color(0xFF15B86C),
    background: Color(0xFF1E1E1E),
    card: Color(0xFF282828),
    text: Colors.white,
    textSecondary: Colors.white70,
    accent: Color(0xFFFFFCFC),
    icon: Colors.white,
  );

  static final lightColors = _AppColors(
    primary: Color(0xFF15B86C),
    background: Colors.white,
    card: Color(0xFFF5F5F5),
    text: Color(0xFF161F1B),
    textSecondary: Color(0xFF3A4640),
    accent: Color(0xFF1E1E1E),
    icon: Color(0xFF3A4640),
  );

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: darkColors.background,
      primaryColor: darkColors.primary,
      colorScheme: ColorScheme.dark(
        primary: darkColors.primary,
        surface: darkColors.card,
        onSurface: darkColors.text,
      ),
      cardColor: darkColors.card,
      appBarTheme: AppBarTheme(
        backgroundColor: darkColors.background,
        foregroundColor: darkColors.text,
        iconTheme: IconThemeData(color: darkColors.icon),
        titleTextStyle: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkColors.text,
        ),
      ),
      textTheme: TextTheme(
        titleMedium: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          color: darkColors.text,
          fontSize: 24,
          fontWeight: FontWeight.normal,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: darkColors.text,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: darkColors.textSecondary,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: darkColors.textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(darkColors.primary),
        ),
      ),
      iconTheme: IconThemeData(color: darkColors.icon),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(darkColors.primary),
        trackColor: WidgetStateProperty.all(
          darkColors.primary.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      primaryColor: lightColors.primary,
      scaffoldBackgroundColor: lightColors.background,
      colorScheme: ColorScheme.light(
        primary: lightColors.primary,
        surface: lightColors.card,
        onSurface: lightColors.text,
      ),
      cardColor: lightColors.card,
      appBarTheme: AppBarTheme(
        backgroundColor: lightColors.background,
        foregroundColor: lightColors.text,
        titleTextStyle: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightColors.text,
        ),
      ),
      textTheme: TextTheme(
        titleMedium: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          color: lightColors.text,
          fontSize: 24,
          fontWeight: FontWeight.normal,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: lightColors.text,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: lightColors.textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(lightColors.primary),
        ),
      ),
      iconTheme: IconThemeData(color: lightColors.icon),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(lightColors.primary),
        trackColor: WidgetStateProperty.all(
          lightColors.primary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _AppColors {
  final Color primary;
  final Color background;
  final Color card;
  final Color text;
  final Color textSecondary;
  final Color accent;
  final Color icon;

  _AppColors({
    required this.primary,
    required this.background,
    required this.card,
    required this.text,
    required this.textSecondary,
    required this.accent,
    required this.icon,
  });
}
