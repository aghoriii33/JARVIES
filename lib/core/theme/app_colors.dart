import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────
/// APP COLOR PALETTE
/// ─────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color bg        = Color(0xFF0F0F13);
  static const Color surface   = Color(0xFF1A1A24);
  static const Color surface2  = Color(0xFF22222F);
  static const Color surface3  = Color(0xFF2A2A3A);

  // Brand
  static const Color purple    = Color(0xFF6C5CE7);
  static const Color purpleDark= Color(0xFF3F37C9);
  static const Color cyan      = Color(0xFF4CC9F0);
  static const Color blue      = Color(0xFF3F37C9);
  static const Color pink      = Color(0xFFFF6584);
  static const Color green     = Color(0xFF00D68F);
  static const Color orange    = Color(0xFFFFA94D);

  // Text
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0x99FFFFFF);  // white 60%
  static const Color textMuted     = Color(0x61FFFFFF);  // white 38%
  static const Color textDisabled  = Color(0x40FFFFFF);  // white 25%

  // Borders
  static const Color border     = Color(0x14FFFFFF);  // white 8%
  static const Color borderMid  = Color(0x1FFFFFFF);  // white 12%

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [purple, blue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient voiceGradient = LinearGradient(
    colors: [purpleDark, cyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [cyan, purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
