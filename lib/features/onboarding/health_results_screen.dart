import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/patient_provider.dart';
import '../../core/utils/animations.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class HealthResultsScreen extends StatelessWidget {
  const HealthResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final report = context.read<PatientProvider>().latestReport;
    if (report == null) {
      return const Scaffold(body: Center(child: Text('No report found')));
    }

    final score = int.tryParse(report.overallScore) ?? 0;
    final scoreColor = score >= 75
        ? AppColors.success
        : score >= 50
            ? AppColors.warning
            : AppColors.error;

    return Scaffold(
      backgroundColor: context.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Score Card ──
                    AnimateIn(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 28, horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: AppColors.heroGradient,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Your Health Score',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Score ring
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0, end: score / 100),
                                      duration:
                                          const Duration(milliseconds: 900),
                                      curve: Curves.easeOutCubic,
                                      builder: (_, value, __) =>
                                          CircularProgressIndicator(
                                        value: value,
                                        strokeWidth: 6,
                                        strokeCap: StrokeCap.round,
                                        backgroundColor: Colors.white
                                            .withValues(alpha: 0.15),
                                        valueColor:
                                            AlwaysStoppedAnimation(scoreColor),
                                      ),
                                    ),
                                  ),
                                  AnimatedCounter(
                                    value: score.toDouble(),
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                report.doshaType,
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accentLight,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              report.doshaDescription,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                color: Colors.white70,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Health Parameters ──
                    AnimateIn(
                      delay: const Duration(milliseconds: 80),
                      child: Text(
                        'Health Parameters',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: context.txt,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...report.healthScores.entries.toList().asMap().entries.map(
                      (e) {
                        final i = e.key;
                        final entry = e.value;
                        return AnimateIn(
                          delay: Duration(milliseconds: 120 + i * 40),
                          child: _HealthBar(
                            label: entry.key,
                            value: entry.value,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // ── Warnings ──
                    if (report.warnings.isNotEmpty) ...[
                      AnimateIn(
                        delay: const Duration(milliseconds: 350),
                        child: Text(
                          'Areas of Concern',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: context.txt,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...report.warnings.asMap().entries.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AnimateIn(
                            delay: Duration(milliseconds: 380 + e.key * 40),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      AppColors.error.withValues(alpha: 0.15),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.warning_amber_rounded,
                                      size: 18, color: AppColors.error),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      e.value,
                                      style: GoogleFonts.nunito(
                                        fontSize: 13,
                                        color: context.txt,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                    ],

                    // ── Recommendations ──
                    AnimateIn(
                      delay: const Duration(milliseconds: 450),
                      child: Text(
                        'Personalised Remedies',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: context.txt,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...report.recommendations.asMap().entries.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: AnimateIn(
                          delay: Duration(milliseconds: 480 + e.key * 40),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: context.border),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${e.key + 1}',
                                    style: GoogleFonts.nunito(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    e.value,
                                    style: GoogleFonts.nunito(
                                      fontSize: 13,
                                      color: context.txt,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // ── Bottom CTA ──
            Container(
              padding: EdgeInsets.fromLTRB(
                  20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
              decoration: BoxDecoration(
                color: context.surface,
                border: Border(top: BorderSide(color: context.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/dashboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Go to Dashboard',
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthBar extends StatelessWidget {
  final String label;
  final double value;
  const _HealthBar({required this.label, required this.value});

  Color get _color {
    if (value >= 75) return AppColors.success;
    if (value >= 50) return AppColors.warning;
    return AppColors.error;
  }

  IconData get _icon {
    return switch (label) {
      'Digestion' => Icons.restaurant_rounded,
      'Immunity' => Icons.shield_rounded,
      'Sleep' => Icons.bedtime_rounded,
      'Stress' => Icons.self_improvement_rounded,
      'Energy' => Icons.bolt_rounded,
      'Skin Health' => Icons.face_rounded,
      _ => Icons.favorite_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            children: [
              Icon(_icon, size: 16, color: _color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: context.txt,
                  ),
                ),
              ),
              Text(
                '${value.toInt()}%',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: value / 100),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (_, v, __) => LinearProgressIndicator(
                value: v,
                minHeight: 6,
                backgroundColor: context.surfaceVariant,
                valueColor: AlwaysStoppedAnimation(_color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
