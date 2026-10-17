import 'package:flutter/material.dart';

class AppColors {
  // Primary - Deep Forest Green
  static const Color primary = Color(0xFF2E6B4A);
  static const Color primaryLight = Color(0xFF5EA87A);
  static const Color primaryDark = Color(0xFF1A4430);

  // Secondary - Rich Terracotta
  static const Color secondary = Color(0xFFBE825A);
  static const Color secondaryLight = Color(0xFFDEAB84);

  // Accent - Refined Gold
  static const Color accent = Color(0xFFCB9B3A);
  static const Color accentLight = Color(0xFFE8C46D);

  // Sunset Orange - warm feature accent
  static const Color sunsetOrange = Color(0xFFE07C4F);
  static const Color sunsetOrangeLight = Color(0xFFF5A27A);

  // Backgrounds - clean & warm
  static const Color background = Color(0xFFF8F6F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0EBE3);

  // Text - refined contrast
  static const Color textPrimary = Color(0xFF2C2C2C); // dark charcoal
  static const Color textSecondary = Color(0xFF6B6B6B); // light gray body
  static const Color textLight = Color(0xFF9A9A9A);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color buttonText =
      Color(0xFFFFF5E6); // soft off-white/golden beige

  // Status - vivid
  static const Color success = Color(0xFF34A853);
  static const Color warning = Color(0xFFF5A623);
  static const Color error = Color(0xFFD93025);
  static const Color info = Color(0xFF6C7DD6);

  // Feature accents - deeper saturation
  static const Color lavender = Color(0xFFC4B4E0);
  static const Color lavenderLight = Color(0xFFF0ECFA);
  static const Color mintGreen = Color(0xFFB8DFB9);
  static const Color warmBeige = Color(0xFFE4CCAB);
  static const Color roseQuartz = Color(0xFFDEB0B0);
  static const Color sageGreen = Color(0xFF8FBF9F);
  static const Color lightOlive = Color(0xFFA3B18A);

  // Cards - refined tints
  static const Color cardGreen = Color(0xFFE6F4E8);
  static const Color cardGold = Color(0xFFFFF7DB);
  static const Color cardLavender = Color(0xFFEDE5F7);
  static const Color cardTerracotta = Color(0xFFFBE6DD);
  static const Color cardBlue = Color(0xFFE0F0FE);
  static const Color cardMint = Color(0xFFDCF5F3);

  // Dark theme - deep charcoal / dark olive
  static const Color darkBackground = Color(0xFF141A16); // deep olive-charcoal
  static const Color darkSurface = Color(0xFF1E2620);
  static const Color darkCard = Color(0xFF283028);
  static const Color darkTextPrimary = Color(0xFFF5F0E4); // light gold-white
  static const Color darkTextSecondary = Color(0xFFA39E90); // warm muted
  static const Color darkAccentGold = Color(0xFFE8C46D); // gold for dark UI

  // ── Gradients ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2E6B4A), Color(0xFF5EA87A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFCB9B3A), Color(0xFFE8C46D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFAF7F3), Color(0xFFE4CCAB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF1A4430), Color(0xFF2E6B4A), Color(0xFF5EA87A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F2218), Color(0xFF1E503A), Color(0xFF3DA06A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardShimmer = LinearGradient(
    colors: [Color(0xFFFAF7F3), Color(0xFFFFFFFF), Color(0xFFFAF7F3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFCB9B3A), Color(0xFFDDB354), Color(0xFFE8C46D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient terracottaGradient = LinearGradient(
    colors: [Color(0xFFBE825A), Color(0xFFDEAB84)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lavenderGradient = LinearGradient(
    colors: [Color(0xFF8B78B8), Color(0xFFC4B4E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFE07C4F), Color(0xFFF5A27A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Premium shadows
  static List<BoxShadow> cardShadow(BuildContext context) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];
}
