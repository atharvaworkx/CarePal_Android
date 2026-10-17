import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/report_model.dart';
import '../../core/providers/patient_provider.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class ProgressTrackerScreen extends StatefulWidget {
  const ProgressTrackerScreen({super.key});

  @override
  State<ProgressTrackerScreen> createState() => _ProgressTrackerScreenState();
}

class _ProgressTrackerScreenState extends State<ProgressTrackerScreen> {
  // Today's log values
  double _steps = 4500;
  double _water = 5; // glasses
  double _sleep = 7; // hours
  double _mood = 3; // 1-5

  bool _editMode = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PatientProvider>();
    final week = provider.weekProgress;
    final streak = _computeStreak(week);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Progress Tracker',
          style: GoogleFonts.playfairDisplay(
              fontSize: 17, fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_editMode) _saveProgress(context);
              setState(() => _editMode = !_editMode);
            },
            child: Text(
              _editMode ? 'Save' : 'Log Today',
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak card
            _StreakCard(streak: streak, weekProgress: week),
            const SizedBox(height: 20),

            // Today's metrics
            Text(
              "Today's Health Log",
              style: GoogleFonts.playfairDisplay(
                  fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _TodayMetrics(
              steps: _steps,
              water: _water,
              sleep: _sleep,
              mood: _mood,
              editMode: _editMode,
              onStepsChanged: (v) => setState(() => _steps = v),
              onWaterChanged: (v) => setState(() => _water = v),
              onSleepChanged: (v) => setState(() => _sleep = v),
              onMoodChanged: (v) => setState(() => _mood = v),
            ),
            const SizedBox(height: 24),

            // Weekly overview
            Text(
              'Weekly Overview',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _WeeklyStepsChart(weekProgress: week),
            const SizedBox(height: 20),

            // Goals
            Text(
              'Daily Goals Progress',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _GoalsProgress(steps: _steps, water: _water, sleep: _sleep),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  int _computeStreak(List<DailyProgress> week) {
    int streak = 0;
    for (final dp in week.reversed) {
      if (dp.steps > 3000) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  void _saveProgress(BuildContext context) {
    final progress = DailyProgress(
      date: DateTime.now(),
      steps: _steps.toInt(),
      weight: 68,
      sleepMinutes: (_sleep * 60).toInt(),
      moodScore: _mood.toInt(),
      waterGlasses: _water.toInt(),
      note: 'Logged via app',
    );
    context.read<PatientProvider>().updateTodayProgress(progress);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text("Today's progress saved! 🎉", style: GoogleFonts.nunito()),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final int streak;
  final List<DailyProgress> weekProgress;
  const _StreakCard({required this.streak, required this.weekProgress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🔥 $streak Day Streak!',
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep logging to maintain your streak',
                  style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.85)),
                ),
                const SizedBox(height: 14),
                Row(
                  children: List.generate(7, (i) {
                    final active =
                        i < weekProgress.length && weekProgress[i].steps > 3000;
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: active
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            active ? '✅' : _dayInitial(i),
                            style: TextStyle(
                              fontSize: 10,
                              color:
                                  active ? AppColors.primaryDark : Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$streak',
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text('days',
                  style:
                      GoogleFonts.nunito(fontSize: 12, color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  String _dayInitial(int i) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return days[i];
  }
}

class _TodayMetrics extends StatelessWidget {
  final double steps, water, sleep, mood;
  final bool editMode;
  final ValueChanged<double> onStepsChanged,
      onWaterChanged,
      onSleepChanged,
      onMoodChanged;

  const _TodayMetrics({
    required this.steps,
    required this.water,
    required this.sleep,
    required this.mood,
    required this.editMode,
    required this.onStepsChanged,
    required this.onWaterChanged,
    required this.onSleepChanged,
    required this.onMoodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.directions_walk_rounded,
                label: 'Steps',
                value: '${steps.toInt()}',
                subLabel: '/ 8000 goal',
                color: AppColors.cardGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                icon: Icons.water_drop_rounded,
                label: 'Water',
                value: '${water.toInt()}',
                subLabel: '/ 8 glasses',
                color: const Color(0xFFE3F2FD),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.bedtime_rounded,
                label: 'Sleep',
                value: '${sleep.toStringAsFixed(1)}h',
                subLabel: '/ 8h goal',
                color: AppColors.cardLavender,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                icon: Icons.mood_rounded,
                label: 'Mood',
                value: _moodLabel(mood),
                subLabel: '${mood.toInt()}/5',
                color: AppColors.cardTerracotta,
              ),
            ),
          ],
        ),
        if (editMode) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Log Your Day',
                    style: GoogleFonts.nunito(
                        fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                _SliderRow(
                    label: 'Steps',
                    value: steps,
                    min: 0,
                    max: 20000,
                    onChanged: onStepsChanged,
                    display: '${steps.toInt()}'),
                _SliderRow(
                    label: 'Water (glasses)',
                    value: water,
                    min: 0,
                    max: 12,
                    onChanged: onWaterChanged,
                    display: '${water.toInt()}'),
                _SliderRow(
                    label: 'Sleep (hours)',
                    value: sleep,
                    min: 0,
                    max: 12,
                    onChanged: onSleepChanged,
                    display: '${sleep.toStringAsFixed(1)}h'),
                _SliderRow(
                    label: 'Mood (1–5)',
                    value: mood,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: onMoodChanged,
                    display: _moodLabel(mood)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _moodLabel(double v) {
    if (v >= 4.5) return 'Great';
    if (v >= 3.5) return 'Good';
    if (v >= 2.5) return 'Okay';
    if (v >= 1.5) return 'Low';
    return 'Bad';
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label, value, subLabel;
  final Color color;
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subLabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.playfairDisplay(
                  fontSize: 18, fontWeight: FontWeight.w700)),
          Text(label,
              style: GoogleFonts.nunito(
                  fontSize: 12, fontWeight: FontWeight.w700)),
          Text(subLabel,
              style: GoogleFonts.nunito(
                  fontSize: 11, color: context.txtSecondary)),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label, display;
  final double value, min, max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
    required this.display,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: GoogleFonts.nunito(
                      fontSize: 13, fontWeight: FontWeight.w600)),
              Text(display,
                  style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.primary.withValues(alpha: 0.15),
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.1),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyStepsChart extends StatelessWidget {
  final List<DailyProgress> weekProgress;
  const _WeeklyStepsChart({required this.weekProgress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 200,
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Steps This Week',
              style: GoogleFonts.nunito(
                  fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 3000,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.textLight.withValues(alpha: 0.2),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (value, _) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        final idx = value.toInt();
                        if (idx < 0 || idx >= days.length)
                          return const SizedBox.shrink();
                        return Text(
                          days[idx],
                          style: GoogleFonts.nunito(
                              fontSize: 11, color: context.txtSecondary),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                        weekProgress.length,
                        (i) => FlSpot(
                            i.toDouble(), weekProgress[i].steps.toDouble())),
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    dotData: FlDotData(
                      getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                        radius: 4,
                        color: context.surface,
                        strokeWidth: 2.5,
                        strokeColor: AppColors.primary,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withValues(alpha: 0.08),
                    ),
                  ),
                ],
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 12000,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalsProgress extends StatelessWidget {
  final double steps, water, sleep;
  const _GoalsProgress(
      {required this.steps, required this.water, required this.sleep});

  @override
  Widget build(BuildContext context) {
    final goals = [
      {
        'label': 'Steps (8,000)',
        'emoji': '👣',
        'value': (steps / 8000).clamp(0.0, 1.0),
        'color': AppColors.primary
      },
      {
        'label': 'Water (8 glasses)',
        'emoji': '💧',
        'value': (water / 8).clamp(0.0, 1.0),
        'color': const Color(0xFF42A5F5)
      },
      {
        'label': 'Sleep (8 hours)',
        'emoji': '😴',
        'value': (sleep / 8).clamp(0.0, 1.0),
        'color': AppColors.info
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: goals.map((g) {
          final pct = (g['value'] as double) * 100;
          final color = g['color'] as Color;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(g['icon'] as IconData,
                            size: 16, color: g['color'] as Color),
                        const SizedBox(width: 8),
                        Text('${g['label']}',
                            style: GoogleFonts.nunito(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Text(
                      '${pct.toInt()}%',
                      style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: color),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: g['value'] as double,
                    minHeight: 8,
                    backgroundColor: color.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
