import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/providers/patient_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/profile_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  final _questions = AppStrings.medicalQuestions;

  // Answers
  final Map<int, List<String>> _multiAnswers = {};
  final Map<int, String> _textAnswers = {};
  final Map<int, String> _singleAnswers = {};
  final Map<String, String> _lifestyleAnswers = {
    'Sleep (hrs/night)': '7',
    'Activity Level': 'Moderate',
    'Stress Level': 'Moderate',
  };

  final _textControllers = <int, TextEditingController>{};

  late AnimationController _progressAnim;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _progressAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _progress = Tween<double>(begin: 0, end: 1 / _questions.length)
        .animate(CurvedAnimation(parent: _progressAnim, curve: Curves.easeOut));
    _progressAnim.forward();
  }

  @override
  void dispose() {
    _progressAnim.dispose();
    for (final c in _textControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _animateProgress(int step) {
    _progress = Tween<double>(
      begin: _progress.value,
      end: (step + 1) / _questions.length,
    ).animate(CurvedAnimation(parent: _progressAnim, curve: Curves.easeOut));
    _progressAnim.forward(from: 0);
  }

  void _next() {
    if (_currentStep < _questions.length - 1) {
      setState(() {
        _currentStep++;
        _animateProgress(_currentStep);
      });
    } else {
      _complete();
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _animateProgress(_currentStep);
      });
    }
  }

  Future<void> _complete() async {
    final provider = context.read<PatientProvider>();
    final auth = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final current = auth.currentPatient;
    if (current == null) return;

    final updated = current.copyWith(
      chronicDiseases: _multiAnswers[0] ?? [],
      familyHistory: _textAnswers[1] ?? '',
      currentSymptoms: _multiAnswers[2] ?? [],
      allergies: _multiAnswers[3] ?? [],
      currentMedications: _textAnswers[4] ?? '',
      dietaryPreference: _singleAnswers[5] ?? 'Vegetarian',
      sleepHours: _lifestyleAnswers['Sleep (hrs/night)'] ?? '7',
      activityLevel: _lifestyleAnswers['Activity Level'] ?? 'Moderate',
      stressLevel: _lifestyleAnswers['Stress Level'] ?? 'Moderate',
      previousTreatments: _textAnswers[7] ?? '',
    );

    // Update local state immediately
    provider.updatePatient(updated);
    auth.setCurrentPatient(updated);

    // Persist to backend (fire and don't block navigation)
    profileProvider.saveMedicalHistory({
      'existingConditions': _multiAnswers[0] ?? [],
      'ongoingTreatments': _textAnswers[4] ?? '',
      'allergies': _multiAnswers[3] ?? [],
      'familyMedicalHistory': _textAnswers[1] ?? '',
      'medications': _textAnswers[4] ?? '',
      'lifestyleNotes': [
        'Sleep: ${_lifestyleAnswers['Sleep (hrs/night)'] ?? '7'} hrs',
        'Activity: ${_lifestyleAnswers['Activity Level'] ?? 'Moderate'}',
        'Stress: ${_lifestyleAnswers['Stress Level'] ?? 'Moderate'}',
      ].join(', '),
    });

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/health-quiz');
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentStep];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: _back,
        ),
        title: Text(
          'Medical History',
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${_currentStep + 1}/${_questions.length}',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AnimatedBuilder(
              animation: _progress,
              builder: (_, __) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _progress.value,
                  minHeight: 6,
                  backgroundColor: context.surfaceVariant,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(anim),
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: _buildQuestion(q, _currentStep),
              ),
            ),
          ),

          // Navigation
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlineButton(label: 'Back', onTap: _back),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    label: _currentStep == _questions.length - 1
                        ? 'Complete & Continue'
                        : 'Next',
                    onTap: _next,
                    icon: _currentStep == _questions.length - 1
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(Map<String, dynamic> q, int index) {
    return Column(
      key: ValueKey(index),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question number badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.cardGreen,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            'Question ${index + 1}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          q['question'],
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: context.txt,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          q['subtitle'] ?? '',
          style: GoogleFonts.nunito(
            fontSize: 14,
            color: context.txtSecondary,
          ),
        ),
        const SizedBox(height: 24),

        if (q['type'] == 'multi') _buildMultiSelect(index, q['options']),
        if (q['type'] == 'single') _buildSingleSelect(index, q['options']),
        if (q['type'] == 'text') _buildTextInput(index, q['placeholder'] ?? ''),
        if (q['type'] == 'lifestyle') _buildLifestyle(),
      ],
    );
  }

  Widget _buildMultiSelect(int index, List<dynamic> options) {
    final selected = _multiAnswers[index] ?? [];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map<Widget>((opt) {
        final isSelected = selected.contains(opt);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _multiAnswers[index] = selected.where((s) => s != opt).toList();
              } else {
                _multiAnswers[index] = [...selected, opt];
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? AppColors.primary : context.border,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                ],
                Text(
                  opt as String,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSingleSelect(int index, List<dynamic> options) {
    return Column(
      children: options.map<Widget>((opt) {
        final selected = _singleAnswers[index] == opt;
        return GestureDetector(
          onTap: () => setState(() => _singleAnswers[index] = opt),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selected ? AppColors.cardGreen : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? AppColors.primary : context.border,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    opt as String,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? AppColors.primaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (selected)
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.primary, size: 22),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextInput(int index, String placeholder) {
    _textControllers[index] ??=
        TextEditingController(text: _textAnswers[index] ?? '');
    return AppTextField(
      label: '',
      hint: placeholder,
      controller: _textControllers[index],
      maxLines: 4,
      onChanged: (v) => _textAnswers[index] = v,
    );
  }

  Widget _buildLifestyle() {
    final sleepOptions = ['< 5', '5–6', '7', '7–8', '8+'];
    final activityOptions = [
      'Sedentary',
      'Low',
      'Moderate',
      'Active',
      'Very Active'
    ];
    final stressOptions = ['Very Low', 'Low', 'Moderate', 'High', 'Very High'];

    final fields = [
      ('Sleep (hrs/night)', sleepOptions),
      ('Activity Level', activityOptions),
      ('Stress Level', stressOptions),
    ];

    return Column(
      children: fields.map((f) {
        final (label, options) = f;
        final current = _lifestyleAnswers[label] ?? options[2];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.txt,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: options.map((opt) {
                    final selected = current == opt;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _lifestyleAnswers[label] = opt),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              selected ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color:
                                selected ? AppColors.primary : context.border,
                          ),
                        ),
                        child: Text(
                          opt,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color:
                                selected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
