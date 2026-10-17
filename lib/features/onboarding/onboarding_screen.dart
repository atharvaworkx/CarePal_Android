import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/utils/animations.dart';
import '../../widgets/custom_button.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;
  final _pages = AppStrings.onboardingData;

  static const _icons = [
    Icons.eco_rounded,
    Icons.shield_rounded,
    Icons.biotech_rounded,
    Icons.spa_rounded,
  ];

  static const _bgColors = [
    AppColors.cardGreen,
    AppColors.cardGold,
    AppColors.cardLavender,
    AppColors.cardTerracotta,
  ];

  static const _iconColors = [
    AppColors.primary,
    AppColors.accent,
    AppColors.info,
    AppColors.secondary,
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    await context.read<AuthProvider>().completeOnboarding();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 12, right: 20),
                child: TextButton(
                  onPressed: _complete,
                  child: Text(
                    'Skip',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: context.txtSecondary,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _OnboardingPage(
                  data: _pages[i],
                  bgColor: _bgColors[i],
                  icon: _icons[i],
                  iconColor: _iconColors[i],
                ),
              ),
            ),

            SmoothPageIndicator(
              controller: _controller,
              count: _pages.length,
              effect: ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotColor: AppColors.primaryLight.withValues(alpha: 0.3),
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 3,
                spacing: 6,
              ),
            ),
            const SizedBox(height: 36),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: _currentPage == _pages.length - 1
                  ? PrimaryButton(
                      label: 'Get Started',
                      onTap: _complete,
                      icon: Icons.arrow_forward_rounded,
                    )
                  : Row(
                      children: [
                        if (_currentPage > 0)
                          Expanded(
                            child: OutlineButton(
                              label: 'Back',
                              onTap: () => _controller.previousPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              ),
                            ),
                          ),
                        if (_currentPage > 0) const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: PrimaryButton(
                            label: 'Next',
                            onTap: () => _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            ),
                            icon: Icons.arrow_forward_rounded,
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final Map<String, String> data;
  final Color bgColor;
  final IconData icon;
  final Color iconColor;

  const _OnboardingPage({
    required this.data,
    required this.bgColor,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Premium icon container with glow
          AnimateIn(
            duration: const Duration(milliseconds: 600),
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.15),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer ring
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: iconColor.withValues(alpha: 0.15),
                        width: 1.5,
                      ),
                    ),
                  ),
                  Icon(icon, size: 72, color: iconColor),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),
          AnimateIn(
            delay: const Duration(milliseconds: 200),
            child: Text(
              data['title']!,
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: context.txt,
                height: 1.25,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnimateIn(
            delay: const Duration(milliseconds: 350),
            child: Text(
              data['subtitle']!,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: context.txtSecondary,
                height: 1.65,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
