import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/report_model.dart';
import '../../core/providers/patient_provider.dart';
import '../../core/utils/animations.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/section_header.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class AIReportScreen extends StatefulWidget {
  final bool showBackButton;
  const AIReportScreen({super.key, this.showBackButton = true});

  @override
  State<AIReportScreen> createState() => _AIReportScreenState();
}

class _AIReportScreenState extends State<AIReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientProvider>().fetchLatestReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PatientProvider>();
    final report = provider.latestReport ?? ReportModel.atharvaReport;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF122A1E), Color(0xFF1E503A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: widget.showBackButton && Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 20, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Row(
          children: [
            const Icon(Icons.spa_rounded, size: 20, color: Colors.white70),
            const SizedBox(width: 8),
            Text(
              'AI Health Report',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload_outlined, color: Colors.white70),
            tooltip: 'Upload Reports',
            onPressed: () => Navigator.pushNamed(context, '/upload-reports'),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Score Card
            AnimateIn(child: _OverallScoreCard(report: report)),
            const SizedBox(height: 24),

            // Dosha Analysis
            AnimateIn(
              delay: const Duration(milliseconds: 150),
              child: _DoshaCard(report: report),
            ),
            const SizedBox(height: 24),

            // Health Scores
            AnimateIn(
              delay: const Duration(milliseconds: 250),
              child: Row(
                children: [
                  Icon(Icons.bar_chart_rounded, color: context.txt, size: 22),
                  const SizedBox(width: 8),
                  const SectionHeader(title: 'Health Parameters'),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AnimateIn(
              delay: const Duration(milliseconds: 300),
              child: _HealthScoresChart(scores: report.healthScores),
            ),
            const SizedBox(height: 24),

            // Body Wellness Quick View
            AnimateIn(
              delay: const Duration(milliseconds: 320),
              child: Row(
                children: [
                  Icon(Icons.monitor_heart_rounded,
                      color: context.txt, size: 22),
                  const SizedBox(width: 8),
                  const SectionHeader(title: 'Body Wellness Quick View'),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AnimateIn(
              delay: const Duration(milliseconds: 350),
              child: _BodyWellnessGrid(scores: report.healthScores),
            ),
            const SizedBox(height: 24),

            // Warnings
            if (report.warnings.isNotEmpty) ...[
              Row(
                children: [
                   const Icon(Icons.info_outline_rounded,
                      color: Color(0xFFE67E22), size: 22),
                  const SizedBox(width: 8),
                  const SectionHeader(title: 'Areas Needing Attention'),
                ],
              ),
              const SizedBox(height: 14),
              ...report.warnings.map((w) => _WarningCard(warning: w)),
              const SizedBox(height: 24),
            ],

            // Recommendations
            Row(
              children: [
                const Icon(Icons.eco_rounded, color: AppColors.primary, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: SectionHeader(
                    title: 'Ayurvedic Recommendations',
                    actionLabel: 'View Remedies',
                    onAction: () => Navigator.pushNamed(context, '/remedies'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...report.recommendations.asMap().entries.map(
                  (e) => _RecommendationCard(
                    index: e.key + 1,
                    text: e.value,
                  ),
                ),
            const SizedBox(height: 24),

            // Actions
            PrimaryButton(
              label: 'View Personalised Remedies',
              onTap: () => Navigator.pushNamed(context, '/remedies'),
              icon: Icons.spa_rounded,
            ),
            const SizedBox(height: 12),
            OutlineButton(
              label: 'Schedule Doctor Consultation',
              onTap: () => Navigator.pushNamed(context, '/appointments'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _OverallScoreCard extends StatelessWidget {
  final ReportModel report;
  const _OverallScoreCard({required this.report});

  Color get _scoreColor {
    final s = int.tryParse(report.overallScore) ?? 0;
    if (s >= 80) return AppColors.success;
    if (s >= 60) return AppColors.accent;
    return AppColors.error;
  }

  IconData get _statusIcon {
    final s = int.tryParse(report.overallScore) ?? 0;
    if (s >= 80) return Icons.auto_awesome_rounded;
    if (s >= 60) return Icons.fitness_center_rounded;
    return Icons.priority_high_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final score = (int.tryParse(report.overallScore) ?? 0) / 100;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF122A1E), Color(0xFF1E503A), Color(0xFF3DA06A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 58,
                    lineWidth: 9,
                    percent: score,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          report.overallScore,
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                        Text(
                          '/100',
                          style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.5)),
                        ),
                      ],
                    ),
                    progressColor: _scoreColor,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    animationDuration: 1200,
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Overall Health Score',
                          style: GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        const SizedBox(width: 6),
                        Icon(_statusIcon, size: 18, color: _scoreColor),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      score >= 0.8
                          ? 'Excellent! Your body is in great harmony.'
                          : score >= 0.6
                               ? 'Good health with room for improvement.'
                               : 'Needs attention. Follow recommendations.',
                      style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.4),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: _scoreColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: _scoreColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            score >= 0.6
                                ? Icons.trending_up_rounded
                                : Icons.trending_down_rounded,
                            size: 14,
                            color: _scoreColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            score >= 0.8
                                ? 'Balanced'
                                : score >= 0.6
                                    ? 'Moderate'
                                    : 'Imbalanced',
                            style: GoogleFonts.nunito(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: _scoreColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person_outline_rounded,
                        size: 15, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(
                      'Atharva Warankar',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.verified_rounded,
                        size: 15, color: Color(0xFF6EE7B7)),
                    const SizedBox(width: 6),
                    Text(
                      'Dr. Yogesh Lokhande',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6EE7B7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  final String warning;
  const _WarningCard({required this.warning});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE67E22).withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE67E22).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFE67E22), size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(warning, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final int index;
  final String text;
  const _RecommendationCard({required this.index, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
            child: Center(child: Text('$index', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary))),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(text, style: GoogleFonts.nunito(fontSize: 13))),
        ],
      ),
    );
  }
}

class _DoshaCard extends StatelessWidget {
  final ReportModel report;
  const _DoshaCard({required this.report});
  @override
  Widget build(BuildContext context) {
    final doshaIcons = {
      'Vata': Icons.air_rounded,
      'Pitta': Icons.local_fire_department_rounded,
      'Kapha': Icons.water_drop_rounded,
    };
    final doshaColors = {
      'Vata': const Color(0xFF7E57C2),
      'Pitta': const Color(0xFFE65100),
      'Kapha': const Color(0xFF00897B),
    };
    final dosha = report.doshaType.split('-').first;
    final color = doshaColors[dosha] ?? AppColors.primary;
    final icon = doshaIcons[dosha] ?? Icons.spa_rounded;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Body Constitution', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: context.txtSecondary)),
                  Text(report.doshaType, style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(report.doshaDescription, style: GoogleFonts.nunito(fontSize: 14, height: 1.5, color: context.txtSecondary)),
        ],
      ),
    );
  }
}

class _HealthScoresChart extends StatelessWidget {
  final Map<String, double> scores;
  const _HealthScoresChart({required this.scores});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: context.surface, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: scores.entries.map((e) {
          final score = e.value / 100;
          final color = score >= 0.8 ? Colors.green : score >= 0.5 ? Colors.orange : Colors.red;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600)),
                    Text('${e.value.toInt()}%', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(value: score, backgroundColor: color.withOpacity(0.1), color: color, minHeight: 6, borderRadius: BorderRadius.circular(10)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BodyWellnessGrid extends StatelessWidget {
  final Map<String, double> scores;
  const _BodyWellnessGrid({required this.scores});
  
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.2),
      itemCount: 4.clamp(0, scores.length),
      itemBuilder: (context, index) {
        final entry = scores.entries.elementAt(index);
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: context.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.border.withOpacity(0.5))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.key, style: GoogleFonts.nunito(fontSize: 12, color: context.txtSecondary)),
              const SizedBox(height: 4),
              Text('${entry.value.toInt()}%', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        );
      },
    );
  }
}
