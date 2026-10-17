import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/patient_provider.dart';
import '../../core/utils/animations.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class HealthQuizScreen extends StatefulWidget {
  const HealthQuizScreen({super.key});

  @override
  State<HealthQuizScreen> createState() => _HealthQuizScreenState();
}

class _HealthQuizScreenState extends State<HealthQuizScreen> {
  int _currentQ = 0;
  final _answers = <int, dynamic>{};

  static const _questions = [
    _QuizQuestion(
      question: 'What best describes your body type?',
      icon: Icons.accessibility_new_rounded,
      options: [
        'Thin / Light build',
        'Medium / Athletic',
        'Heavy / Stocky',
        'Mixed / Variable'
      ],
    ),
    _QuizQuestion(
      question: 'How would you describe your digestion?',
      icon: Icons.local_fire_department_rounded,
      options: [
        'Irregular / Bloating',
        'Strong / Acidic',
        'Slow / Heavy',
        'Generally good'
      ],
    ),
    _QuizQuestion(
      question: 'How is your sleep quality?',
      icon: Icons.bedtime_rounded,
      options: [
        'Light / Restless',
        'Moderate / Wake up hot',
        'Deep / Hard to wake',
        'Variable'
      ],
    ),
    _QuizQuestion(
      question: 'What is your primary health concern?',
      icon: Icons.health_and_safety_rounded,
      options: [
        'Fatigue & Low Energy',
        'Digestive Issues',
        'Skin Problems',
        'Stress & Anxiety',
        'Joint Pain',
        'Weight Management'
      ],
    ),
    _QuizQuestion(
      question: 'How would you rate your stress level?',
      icon: Icons.psychology_rounded,
      options: [
        'Low - Rarely stressed',
        'Moderate - Sometimes',
        'High - Frequently',
        'Very High - Constant'
      ],
    ),
    _QuizQuestion(
      question: 'What is your dietary preference?',
      icon: Icons.restaurant_rounded,
      options: ['Vegetarian', 'Non-Vegetarian', 'Vegan', 'Eggetarian'],
    ),
    _QuizQuestion(
      question: 'How active are you daily?',
      icon: Icons.directions_run_rounded,
      options: [
        'Sedentary (Little to none)',
        'Lightly Active (Walking)',
        'Moderately Active (Exercise 3-4x)',
        'Very Active (Daily intense)'
      ],
    ),
    _QuizQuestion(
      question: 'Do you have any known allergies?',
      icon: Icons.warning_amber_rounded,
      isMultiSelect: true,
      options: ['Dairy', 'Gluten', 'Nuts', 'Pollen', 'Dust', 'None'],
    ),
  ];

  void _selectOption(int optionIndex) {
    final q = _questions[_currentQ];
    if (q.isMultiSelect) {
      final current = Set<int>.from(_answers[_currentQ] ?? <int>{});
      // "None" logic - index 5 clears others
      if (optionIndex == q.options.length - 1) {
        current.clear();
        current.add(optionIndex);
      } else {
        current.remove(q.options.length - 1);
        if (current.contains(optionIndex)) {
          current.remove(optionIndex);
        } else {
          current.add(optionIndex);
        }
      }
      setState(() => _answers[_currentQ] = current);
    } else {
      setState(() => _answers[_currentQ] = optionIndex);
      // Auto-advance after brief delay
      Future.delayed(const Duration(milliseconds: 300), _next);
    }
  }

  void _next() {
    if (_answers[_currentQ] == null) return;
    if (_currentQ < _questions.length - 1) {
      setState(() => _currentQ++);
    } else {
      _finishQuiz();
    }
  }

  void _back() {
    if (_currentQ > 0) {
      setState(() => _currentQ--);
    }
  }

  void _finishQuiz() {
    // Map answers to PatientModel fields
    final stressOptions = ['Low', 'Moderate', 'High', 'Very High'];
    final dietOptions = ['Vegetarian', 'Non-Vegetarian', 'Vegan', 'Eggetarian'];
    final activityOptions = ['Sedentary', 'Light', 'Moderate', 'Very Active'];
    final sleepOptions = ['5', '6', '7', '8'];
    final concernOptions = [
      'Fatigue',
      'Digestive Issues',
      'Skin Problems',
      'Stress & Anxiety',
      'Joint Pain',
      'Weight Management'
    ];

    final auth = context.read<AuthProvider>();
    final patient = auth.currentPatient;
    if (patient == null) return;
    final allergySet = _answers[7] as Set<int>? ?? {};
    final allergyOptions = _questions[7].options;
    final allergies = allergySet
        .where((i) => i < allergyOptions.length - 1)
        .map((i) => allergyOptions[i])
        .toList();

    final updated = patient.copyWith(
      sleepHours: sleepOptions[(_answers[2] as int?) ?? 3],
      stressLevel: stressOptions[(_answers[4] as int?) ?? 1],
      dietaryPreference: dietOptions[(_answers[5] as int?) ?? 0],
      activityLevel: activityOptions[(_answers[6] as int?) ?? 1],
      currentSymptoms: [concernOptions[(_answers[3] as int?) ?? 0]],
      allergies: allergies,
    );

    context.read<PatientProvider>().initPatient(updated);
    auth.setCurrentPatient(updated);

    Navigator.pushReplacementNamed(context, '/scan-upload');
  }

  bool get _hasAnswer {
    final a = _answers[_currentQ];
    if (a == null) return false;
    if (a is Set) return a.isNotEmpty;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentQ];
    final progress = (_currentQ + 1) / _questions.length;

    return Scaffold(
      backgroundColor: context.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  if (_currentQ > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18),
                      onPressed: _back,
                    )
                  else
                    const SizedBox(width: 48),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${_currentQ + 1} of ${_questions.length}',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: context.txtSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: progress),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            builder: (_, v, __) => LinearProgressIndicator(
                              value: v,
                              minHeight: 4,
                              backgroundColor: context.surfaceVariant,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Question
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(
                        CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                    child: child,
                  ),
                ),
                child: _QuestionView(
                  key: ValueKey(_currentQ),
                  question: q,
                  selectedIndex:
                      q.isMultiSelect ? null : _answers[_currentQ] as int?,
                  selectedIndices: q.isMultiSelect
                      ? (_answers[_currentQ] as Set<int>? ?? {})
                      : {},
                  onSelect: _selectOption,
                ),
              ),
            ),

            // Bottom button for multi-select
            if (q.isMultiSelect)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: AnimateIn(
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _hasAnswer ? _next : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: context.surfaceVariant,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentQ == _questions.length - 1
                            ? 'Continue'
                            : 'Next',
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _hasAnswer ? Colors.white : context.txtLight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    );
  }
}

class _QuizQuestion {
  final String question;
  final IconData icon;
  final List<String> options;
  final bool isMultiSelect;
  const _QuizQuestion({
    required this.question,
    required this.icon,
    required this.options,
    this.isMultiSelect = false,
  });
}

class _QuestionView extends StatelessWidget {
  final _QuizQuestion question;
  final int? selectedIndex;
  final Set<int> selectedIndices;
  final ValueChanged<int> onSelect;

  const _QuestionView({
    super.key,
    required this.question,
    required this.selectedIndex,
    required this.selectedIndices,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(question.icon, color: AppColors.primary, size: 26),
          ),
          const SizedBox(height: 20),

          // Question text
          Text(
            question.question,
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: context.txt,
              letterSpacing: -0.3,
              height: 1.3,
            ),
          ),
          if (question.isMultiSelect) ...[
            const SizedBox(height: 6),
            Text(
              'Select all that apply',
              style:
                  GoogleFonts.nunito(fontSize: 14, color: context.txtSecondary),
            ),
          ],
          const SizedBox(height: 24),

          // Options
          Expanded(
            child: ListView.separated(
              itemCount: question.options.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final isSelected = question.isMultiSelect
                    ? selectedIndices.contains(i)
                    : selectedIndex == i;
                return _OptionTile(
                  label: question.options[i],
                  isSelected: isSelected,
                  onTap: () => onSelect(i),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.06)
              : context.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : context.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : context.txtLight,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : context.txt,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
