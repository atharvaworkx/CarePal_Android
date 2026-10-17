import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/patient_provider.dart';
import '../../core/providers/profile_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/utils/animations.dart';
import '../../widgets/section_header.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';
import '../../core/models/appointment_model.dart';
import '../appointments/appointment_screen.dart';
import '../reports/ai_report_screen.dart';
import '../store/medicine_store_screen.dart';
import '../settings/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedTab = 0;

  static const List<Widget> _tabs = [
    _HomeTab(),
    AppointmentScreen(showBackButton: false),
    AIReportScreen(showBackButton: false),
    MedicineStoreScreen(showBackButton: false),
    SettingsScreen(showBackButton: false),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PatientProvider>();
      provider.fetchLatestReport();
      provider.fetchAppointments();
      provider.fetchMedicines();
      provider.fetchDoctors();
      context.read<ProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    return Scaffold(
      backgroundColor:
          theme.isDarkMode ? AppColors.darkBackground : AppColors.background,
      body: IndexedStack(
        index: _selectedTab,
        children: _tabs,
      ),
      floatingActionButton: BouncingWidget(
        onTap: () => Navigator.pushNamed(context, '/chatbot'),
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.smart_toy_rounded,
              color: Colors.white, size: 24),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(theme.isDarkMode),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    final items = [
      const _NavItem(icon: Icons.home_rounded, label: 'Home'),
      const _NavItem(icon: Icons.calendar_month_rounded, label: 'Appointments'),
      const _NavItem(icon: Icons.analytics_rounded, label: 'Reports'),
      const _NavItem(icon: Icons.store_rounded, label: 'Store'),
      const _NavItem(icon: Icons.person_rounded, label: 'Profile'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.04),
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((e) {
              final selected = e.key == _selectedTab;
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = e.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedScale(
                        scale: selected ? 1.12 : 1.0,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutBack,
                        child: Icon(
                          e.value.icon,
                          color: selected
                              ? AppColors.primary
                              : AppColors.textLight,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        e.value.label,
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected
                              ? AppColors.primary
                              : AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

// ---- Home Tab ----
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final profile = context.watch<ProfileProvider>();
    final patient = context.watch<PatientProvider>();
    final theme = context.watch<ThemeProvider>();
    final isDark = theme.isDarkMode;
    final profileName = profile.fullName.trim();
    final authName = auth.currentPatient?.name.trim() ?? '';
    final name = (profileName.isNotEmpty && profileName != 'User'
            ? profileName
            : authName.isNotEmpty
                ? authName
                : 'Guest')
        .split(' ')
        .first;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.background,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/profile/atharva_profile.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        auth.currentPatient?.profileIcon ??
                            Icons.person_rounded,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting, $name',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    DateFormat('EEEE, d MMM').format(DateTime.now()),
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: context.txtSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Badge(
                backgroundColor: AppColors.accent,
                smallSize: 8,
                child: Icon(Icons.notifications_outlined,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                    size: 24),
              ),
              onPressed: () => Navigator.pushNamed(context, '/notifications'),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // Health Score Banner
                AnimateIn(
                  child: _HealthScoreBanner(
                      score: patient.latestReport?.overallScore ?? '0'),
                ),
                const SizedBox(height: 28),

                // Quick Actions
                AnimateIn(
                  delay: const Duration(milliseconds: 100),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt_rounded,
                          color: AppColors.accent, size: 22),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: SectionHeader(
                          title: 'Quick Actions',
                          actionLabel: 'See All',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const _QuickActionsGrid(),
                const SizedBox(height: 28),

                // Daily Wellness Streak
                AnimateIn(
                  delay: const Duration(milliseconds: 200),
                  child: const _DailyStreakCard(),
                ),
                const SizedBox(height: 28),

                // Ayurveda Insight of the Day
                AnimateIn(
                  delay: const Duration(milliseconds: 250),
                  child: const _AyurvedaInsightCard(),
                ),
                const SizedBox(height: 28),

                // Upcoming appointment
                AnimateIn(
                  delay: const Duration(milliseconds: 300),
                  child: Row(
                    children: [
                      const Icon(Icons.event_rounded,
                          color: AppColors.primary, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SectionHeader(
                          title: 'Upcoming Appointment',
                          actionLabel: 'View All',
                          onAction: () =>
                              Navigator.pushNamed(context, '/appointments'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                AnimateIn(
                  delay: const Duration(milliseconds: 350),
                  child: _UpcomingAppointmentCard(patient: patient),
                ),
                const SizedBox(height: 28),

                // Wellness tips
                AnimateIn(
                  delay: const Duration(milliseconds: 400),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_rounded,
                          color: AppColors.accent, size: 22),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: SectionHeader(title: "Today's Wellness Tips"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const _WellnessTips(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HealthScoreBanner extends StatelessWidget {
  final String score;
  const _HealthScoreBanner({required this.score});

  @override
  Widget build(BuildContext context) {
    final displayScore = score == '0' ? '92' : score;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F3822), Color(0xFF1B5E3A), Color(0xFF28794C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E3A).withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome_rounded,
                              size: 14, color: Color(0xFFFFD54F)),
                          const SizedBox(width: 5),
                          Text(
                            'Prakriti: Vata-Pitta',
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          displayScore,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 4),
                          child: Text(
                            '/100',
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Optimal Balance - Good Agni',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              // Right side dosha breakdown
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _doshaIndicator('Vata', '40%', const Color(0xFFB39DDB)),
                    const SizedBox(height: 8),
                    _doshaIndicator('Pitta', '35%', const Color(0xFFFFD54F)),
                    const SizedBox(height: 8),
                    _doshaIndicator('Kapha', '25%', const Color(0xFF81C784)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Action Bar inside Banner
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/ai-report'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.analytics_rounded,
                            size: 16, color: Color(0xFF0F3822)),
                        const SizedBox(width: 6),
                        Text(
                          'View Full AI Report',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F3822),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/upload-reports'),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.camera_alt_outlined,
                          size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Scan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _doshaIndicator(String dosha, String percent, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          '$dosha: ',
          style: GoogleFonts.nunito(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          percent,
          style: GoogleFonts.nunito(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  static final _actions = [
    {
      'icon': Icons.document_scanner_rounded,
      'label': 'AI Health Scan',
      'desc': 'Upload & Analyze',
      'badge': 'AI Fast',
      'route': '/upload-reports',
      'gradient': const [Color(0xFF0F766E), Color(0xFF14B8A6)],
      'bgColor': const Color(0xFFE6F4EA),
    },
    {
      'icon': Icons.spa_rounded,
      'label': 'Ayur Remedies',
      'desc': 'Herbs & Lifestyle',
      'badge': 'Custom',
      'route': '/remedies',
      'gradient': const [Color(0xFFC2410C), Color(0xFFF97316)],
      'bgColor': const Color(0xFFFBE9E7),
    },
    {
      'icon': Icons.shopping_bag_rounded,
      'label': 'Herbal Store',
      'desc': 'Pure Medicines',
      'badge': 'Pure',
      'route': '/store',
      'gradient': const [Color(0xFFB45309), Color(0xFFF59E0B)],
      'bgColor': const Color(0xFFFFF8E1),
    },
    {
      'icon': Icons.restaurant_rounded,
      'label': 'Diet Planner',
      'desc': 'Dosha Foods',
      'badge': 'Daily',
      'route': '/diet-planner',
      'gradient': const [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
      'bgColor': const Color(0xFFE8EAF6),
    },
  ];

  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      itemCount: _actions.length,
      itemBuilder: (_, i) {
        final action = _actions[i];
        final gradient = action['gradient'] as List<Color>;
        return BouncingWidget(
          onTap: () => Navigator.pushNamed(context, action['route'] as String),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: gradient.first.withValues(alpha: 0.18),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: gradient.first.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.first.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    action['icon'] as IconData,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              action['label'] as String,
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        action['desc'] as String,
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          color: context.txtSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: context.txtSecondary.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DailyStreakCard extends StatelessWidget {
  const _DailyStreakCard();

  @override
  Widget build(BuildContext context) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    const completedDays = [true, true, true, true, true, true, true];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF9800).withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.local_fire_department_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '7 Day Wellness Streak',
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Active',
                            style: GoogleFonts.nunito(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFE65100),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'You have maintained your Ayurvedic routine every day!',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        color: context.txtSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (idx) {
              final isDone = completedDays[idx];
              return Column(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone
                          ? AppColors.primary
                          : context.surfaceVariant,
                      border: Border.all(
                        color: isDone
                            ? AppColors.primaryLight
                            : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow: isDone
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Icon(
                        isDone ? Icons.check_rounded : Icons.circle_outlined,
                        size: 18,
                        color: isDone ? Colors.white : context.txtLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    days[idx],
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDone ? AppColors.primary : context.txtSecondary,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _AyurvedaInsightCard extends StatefulWidget {
  const _AyurvedaInsightCard();

  @override
  State<_AyurvedaInsightCard> createState() => _AyurvedaInsightCardState();
}

class _AyurvedaInsightCardState extends State<_AyurvedaInsightCard> {
  int _tipIndex = 0;

  static const _insights = [
    'Drink warm water infused with ginger at dawn to awaken your Jatharagni (digestive fire).',
    'Consistency in sleep (Nidra) is one of the three pillars of longevity in Ayurveda.',
    'Eat your heaviest meal when the sun is at its highest, between 12 PM and 2 PM.',
    'Practice 10 minutes of Anulom Vilom Pranayama daily to balance Vata and Pitta doshas.',
    'Golden Turmeric milk with a pinch of black pepper restores tissue rejuvenation (Ojas).',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFF8E1),
            const Color(0xFFFFECB3).withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFD54F), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD54F).withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.wb_sunny_rounded,
                    size: 18, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text(
                'Daily Vedic Wisdom',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: const Color(0xFF78350F),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _tipIndex = (_tipIndex + 1) % _insights.length;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.refresh_rounded,
                          size: 14, color: Color(0xFF78350F)),
                      const SizedBox(width: 4),
                      Text(
                        'New',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF78350F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"${_insights[_tipIndex]}"',
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF451A03),
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingAppointmentCard extends StatelessWidget {
  final PatientProvider patient;
  const _UpcomingAppointmentCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.medical_services_rounded,
                    color: AppColors.primary, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Dr. Yogesh Lokhande',
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified_rounded,
                            size: 16, color: AppColors.primary),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ayurvedic Physician - 14 yrs exp',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: context.txtSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Confirmed',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: context.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Tomorrow, 4:00 PM • Video Consultation',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/appointments'),
                  child: Text(
                    'Details →',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WellnessTips extends StatefulWidget {
  const _WellnessTips();

  @override
  State<_WellnessTips> createState() => _WellnessTipsState();
}

class _WellnessTipsState extends State<_WellnessTips> {
  final Map<int, bool> _completed = {
    0: true,
    1: true,
    2: false,
    3: false,
  };

  static const _routine = [
    {
      'title': 'Ushapan: Warm water with ginger at dawn',
      'time': 'Morning 6:30 AM',
      'icon': Icons.wb_sunny_rounded,
      'color': Color(0xFFF59E0B),
    },
    {
      'title': '10 mins Nadi Shodhana Pranayama',
      'time': 'Morning 7:00 AM',
      'icon': Icons.self_improvement_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'title': 'Light vegetarian lunch with digestive herbs',
      'time': 'Afternoon 1:00 PM',
      'icon': Icons.restaurant_rounded,
      'color': Color(0xFF3B82F6),
    },
    {
      'title': 'Ashwagandha with warm milk before sleep',
      'time': 'Night 10:00 PM',
      'icon': Icons.bedtime_rounded,
      'color': Color(0xFF8B5CF6),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_routine.length, (idx) {
        final item = _routine[idx];
        final isDone = _completed[idx] ?? false;
        final color = item['color'] as Color;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _completed[idx] = !isDone;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDone
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.05),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: isDone
                                ? context.txtSecondary
                                : context.txt,
                          ),
                        ),
                        Text(
                          item['time'] as String,
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            color: context.txtSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone ? AppColors.primary : Colors.transparent,
                      border: Border.all(
                        color: isDone
                            ? AppColors.primary
                            : context.txtLight.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: isDone
                        ? const Icon(Icons.check_rounded,
                            size: 16, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
