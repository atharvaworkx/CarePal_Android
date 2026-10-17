import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/patient_model.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/patient_provider.dart';
import '../../core/utils/animations.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  State<PatientRegistrationScreen> createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(); // First name
  final _lastNameCtrl = TextEditingController(); // Last name
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String _selectedGender = 'Female';
  bool _consentGiven = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  final _genders = ['Female', 'Male', 'Other', 'Prefer not to say'];
  final _avatarIcons = [
    Icons.person_rounded,
    Icons.face_3_rounded,
    Icons.face_rounded,
    Icons.health_and_safety_rounded,
    Icons.self_improvement_rounded,
    Icons.spa_rounded,
  ];
  IconData _selectedIcon = Icons.person_rounded;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _proceed() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_consentGiven) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide consent to continue.',
              style: GoogleFonts.nunito()),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final auth = context.read<AuthProvider>();
    
    // Split name properly
    final fullText = _nameCtrl.text.trim();
    final nameParts = fullText.split(' ');
    final fName = nameParts.first;
    final lName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : fName;

    final success = await auth.register(
      firstName: fName,
      lastName: lName,
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      password: _passwordCtrl.text,
      age: int.tryParse(_ageCtrl.text),
      gender: _selectedGender,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      // Store extra local fields
      final patient = PatientModel(
        id: auth.currentPatient?.id ?? '',
        name: '${_nameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}'.trim(),
        age: int.tryParse(_ageCtrl.text) ?? 0,
        gender: _selectedGender,
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        profileIcon: _selectedIcon,
      );
      context.read<PatientProvider>().initPatient(patient);
      auth.setCurrentPatient(patient);
      Navigator.pushNamed(context, '/medical-history');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Registration failed',
              style: GoogleFonts.nunito()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Account',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: context.txt,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              AnimateIn(
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.eco_rounded,
                            color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tell us about you',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Your personalised Ayurvedic journey starts here.',
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Avatar picker
              AnimateIn(
                delay: const Duration(milliseconds: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose your avatar',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: context.txt,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: _avatarIcons.map((ic) {
                        final selected = ic == _selectedIcon;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedIcon = ic),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(right: 10),
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.surfaceVariant,
                              shape: BoxShape.circle,
                              border: selected
                                  ? Border.all(
                                      color: AppColors.primary, width: 2)
                                  : null,
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(ic,
                                size: 22,
                                color: selected
                                    ? Colors.white
                                    : AppColors.textSecondary),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              AnimateIn(
                delay: const Duration(milliseconds: 150),
                child: AppTextField(
                  label: 'Full Name',
                  hint: 'Priya Sharma',
                  controller: _nameCtrl,
                  prefix: const Icon(Icons.person_outline,
                      color: AppColors.primary, size: 20),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Name is required' : null,
                ),
              ),
              const SizedBox(height: 18),

              AnimateIn(
                delay: const Duration(milliseconds: 200),
                child: Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Age',
                        hint: '32',
                        controller: _ageCtrl,
                        keyboardType: TextInputType.number,
                        prefix: const Icon(Icons.cake_outlined,
                            color: AppColors.primary, size: 20),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          final n = int.tryParse(v);
                          if (n == null || n < 1 || n > 120) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gender',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: context.txt,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedGender,
                            items: _genders
                                .map((g) => DropdownMenuItem(
                                    value: g,
                                    child: Text(g,
                                        style:
                                            GoogleFonts.nunito(fontSize: 14))))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _selectedGender = v!),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: context.surfaceVariant,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: context.border),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              AnimateIn(
                delay: const Duration(milliseconds: 250),
                child: AppTextField(
                  label: 'Email Address',
                  hint: 'you@example.com',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefix: const Icon(Icons.email_outlined,
                      color: AppColors.primary, size: 20),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Enter valid email';
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 18),

              AnimateIn(
                delay: const Duration(milliseconds: 300),
                child: AppTextField(
                  label: 'Phone Number',
                  hint: '+91 98765 43210',
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  prefix: const Icon(Icons.phone_outlined,
                      color: AppColors.primary, size: 20),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Phone is required' : null,
                ),
              ),
              const SizedBox(height: 18),

              AnimateIn(
                delay: const Duration(milliseconds: 325),
                child: AppTextField(
                  label: 'Password',
                  hint: 'Min. 8 characters',
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  prefix: const Icon(Icons.lock_outline_rounded,
                      color: AppColors.primary, size: 20),
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 8) return 'Password too short';
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Consent
              AnimateIn(
                delay: const Duration(milliseconds: 350),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardGold,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _consentGiven,
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        onChanged: (v) => setState(() => _consentGiven = v!),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'I consent to AyuPilot collecting and processing my health data to provide personalised Ayurvedic recommendations. Data is encrypted and never shared without consent.',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: context.txtSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              PrimaryButton(
                label: 'Continue to Medical History',
                onTap: _proceed,
                isLoading: _isLoading,
                icon: Icons.arrow_forward_rounded,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
