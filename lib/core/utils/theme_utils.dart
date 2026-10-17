import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Context extension providing adaptive colors for light/dark mode.
extension AppTheme on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // Backgrounds
  Color get bg => isDark ? AppColors.darkBackground : AppColors.background;
  Color get surface => isDark ? AppColors.darkSurface : AppColors.surface;
  Color get surfaceVariant =>
      isDark ? const Color(0xFF353D37) : AppColors.surfaceVariant;
  Color get cardBg => isDark ? AppColors.darkCard : AppColors.surface;

  // Text
  Color get txt => isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
  Color get txtSecondary =>
      isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
  Color get txtLight => isDark ? const Color(0xFF707070) : AppColors.textLight;

  // Border
  Color get border =>
      isDark ? const Color(0xFF363E38) : const Color(0xFFE8E2DA);

  // Subtle card border for premium feel
  BorderSide get cardBorder => BorderSide(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.04),
      );

  // Feature cards
  Color get adaptiveCardGreen =>
      isDark ? const Color(0xFF1B3325) : AppColors.cardGreen;
  Color get adaptiveCardGold =>
      isDark ? const Color(0xFF3A3420) : AppColors.cardGold;
  Color get adaptiveCardLavender =>
      isDark ? const Color(0xFF2D283E) : AppColors.cardLavender;
  Color get adaptiveCardTerracotta =>
      isDark ? const Color(0xFF3A2E28) : AppColors.cardTerracotta;
  Color get adaptiveCardBlue =>
      isDark ? const Color(0xFF1E2D3A) : AppColors.cardBlue;
  Color get adaptiveCardMint =>
      isDark ? const Color(0xFF1E3A38) : AppColors.cardMint;

  // Gradients
  LinearGradient get heroGrad => isDark
      ? const LinearGradient(
          colors: [Color(0xFF0D2818), Color(0xFF1B4332), Color(0xFF2D6A4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : AppColors.heroGradient;

  LinearGradient get primaryGrad => isDark
      ? const LinearGradient(
          colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : AppColors.primaryGradient;
}
