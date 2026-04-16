import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Surface Hierarchy ────────────────────────────────────────────────────────
  static const Color surface = Color(0xFFF5F7F9);
  static const Color surfaceContainerLow = Color(0xFFEEF1F3);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerHigh = Color(0xFFDFE3E6);
  static const Color surfaceContainerHighest = Color(0xFFD0D4D7);

  // ── Primary Green ─────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF006A30);
  static const Color primaryContainer = Color(0xFF3AE97A);
  /// White — use on primary-coloured backgrounds (buttons, chips)
  static const Color onPrimary = Color(0xFFFFFFFF);
  /// Pale mint — use for text/icons on a dark-green (#006A30) surface
  static const Color onPrimaryVariant = Color(0xFFCEFFD2);

  // ── Secondary ─────────────────────────────────────────────────────────────
  static const Color secondaryContainer = Color(0xFFD8E3FB);
  static const Color onSecondaryContainer = Color(0xFF475266);

  // ── Text / On-Surface ─────────────────────────────────────────────────────
  static const Color onSurface = Color(0xFF2C2F31);
  static const Color onSurfaceVariant = Color(0xFF595C5E);
  static const Color outlineVariant = Color(0xFFABADAF);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFB02500);
  /// Bright green used for "online" indicators and pulsing dots
  static const Color online = Color(0xFF00D166);

  // ── Table / Device Status ─────────────────────────────────────────────────
  static const Color statusAvailable = Color(0xFF00B96B);
  static const Color statusOccupied = Color(0xFFE53935);
  static const Color statusCleaning = Color(0xFFFFB300);

  // ── Signature Gradient (135°) ─────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [primary, primaryContainer],
  );
}
