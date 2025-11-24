// ============================================================================
// HOME CONSTANTS
// ============================================================================
// Konstanta untuk warna, spacing, dan styling halaman home warga
// ============================================================================

import 'package:flutter/material.dart';

class HomeColors {
  HomeColors._();

  // Primary Colors
  static const Color primary = Color(0xFF2F80ED);
  static const Color primaryDark = Color(0xFF1E6FD9);
  static const Color primaryLight = Color(0xFF60A5FA);

  // Background Colors
  static const Color background = Color(0xFFF8F9FD);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF8F9FD);

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}

class HomeSpacing {
  HomeSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
}

class HomeBorderRadius {
  HomeBorderRadius._();

  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
}

class HomeElevation {
  HomeElevation._();

  static const double none = 0.0;
  static const double sm = 2.0;
  static const double md = 4.0;
  static const double lg = 8.0;
  static const double xl = 12.0;
}

