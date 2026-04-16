import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    // Apply Prompt to every slot in the Material 3 text theme.
    final textTheme = GoogleFonts.promptTextTheme(
      ThemeData.light().textTheme.apply(
            bodyColor: AppColors.onSurface,
            displayColor: AppColors.onSurface,
          ),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.surface,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryContainer,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondaryContainer,
        onSecondary: AppColors.onSecondaryContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outlineVariant: AppColors.outlineVariant,
        error: AppColors.error,
      ),
      textTheme: textTheme,
    );
  }
}
