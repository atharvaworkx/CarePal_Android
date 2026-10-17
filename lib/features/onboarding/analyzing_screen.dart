import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/patient_provider.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class AnalyzingScreen extends StatefulWidget {
  const AnalyzingScreen({super.key});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentStep = 0;
  bool _done = false;

  static const _steps = [
    _Step(label: 'Reading your health data', icon: Icons.description_rounded),
    _Step(label: 'Analysing Prakriti constitution', icon: Icons.spa_rounded),
    _Step(label: 'Evaluating dosha balance', icon: Icons.balance_rounded),
    _Step(
        label: 'Scanning uploaded reports',
        icon: Icons.document_scanner_rounded),
    _Step(label: 'Generating health score', icon: Icons.analytics_rounded),
    _Step(label: 'Preparing recommendations', icon: Icons.auto_awesome_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
    _runAnalysis();
  }

  Future<void> _runAnalysis() async {
    final provider = context.read<PatientProvider>();

    for (int i = 0; i < _steps.length; i++) {
      if (!mounted) return;
      setState(() => _currentStep = i);
      await Future.delayed(const Duration(milliseconds: 600));
    }

    await provider.processReport();

    if (!mounted) return;
    setState(() => _done = true);

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/health-results');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _progress {
    if (_done) return 1.0;
    return (_currentStep + 1) / _steps.length * 0.9;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pulsing icon
              AnimatedBuilder(
                animation: _controller,
                builder: (_, child) {
                  final scale = 1.0 +
                      (_controller.value < 0.5
                              ? _controller.value
                              : 1 - _controller.value) *
                          0.08;
                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    _done ? Icons.check_rounded : Icons.biotech_rounded,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Title
              Text(
                _done ? 'Analysis Complete!' : 'Analysing Your Health',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: context.txt,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _done
                    ? 'Your Ayurvedic health report is ready'
                    : 'Our AI is processing your data using\nancient Ayurvedic principles',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: context.txtSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 36),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: _progress),
                  duration: const Duration(milliseconds: 400),
                  builder: (_, value, __) => LinearProgressIndicator(
                    value: value,
                    minHeight: 8,
                    backgroundColor: context.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation(
                      _done ? AppColors.success : AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${(_progress * 100).toInt()}%',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),

              // Step list
              ...List.generate(_steps.length, (i) {
                final step = _steps[i];
                final isActive = i == _currentStep && !_done;
                final isDone = i < _currentStep || _done;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: i <= _currentStep || _done ? 1 : 0.3,
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isDone
                                ? AppColors.success
                                : isActive
                                    ? AppColors.primary
                                    : context.surfaceVariant,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isDone ? Icons.check_rounded : step.icon,
                            size: 14,
                            color: (isDone || isActive)
                                ? Colors.white
                                : context.txtLight,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            step.label,
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight:
                                  isActive ? FontWeight.w700 : FontWeight.w500,
                              color:
                                  isActive ? context.txt : context.txtSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step {
  final String label;
  final IconData icon;
  const _Step({required this.label, required this.icon});
}
