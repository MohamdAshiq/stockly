import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFFEEF2FF);
  static const Color secondary = Color(0xFF0EA5E9);

  // Background & Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color cardSurface = Colors.white;

  // Typography Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Price Indicators
  static const Color positivePrice = Color(0xFF10B981);
  static const Color positiveBadgeBg = Color(0xFFECFDF5);
  static const Color negativePrice = Color(0xFFEF4444);
  static const Color negativeBadgeBg = Color(0xFFFEF2F2);

  // Status & Utility
  static const Color border = Color(0xFFE2E8F0);
  static const Color deleteRed = Color(0xFFF43F5E);
  static const Color shadow = Color(0x0C0F172A);

  // Gradient for Avatars
  static const List<List<Color>> avatarGradients = [
    [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    [Color(0xFF3B82F6), Color(0xFF06B6D4)],
    [Color(0xFF10B981), Color(0xFF059669)],
    [Color(0xFFF59E0B), Color(0xFFD97706)],
    [Color(0xFFEC4899), Color(0xFF8B5CF6)],
  ];
}
