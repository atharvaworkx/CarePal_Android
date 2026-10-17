import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/profile_provider.dart';
import '../../core/providers/theme_provider.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class SettingsScreen extends StatelessWidget {
  final bool showBackButton;
  const SettingsScreen({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final profileProvider = context.watch<ProfileProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final patient = authProvider.currentPatient;

    final name = (profileProvider.fullName.isNotEmpty &&
            profileProvider.fullName != 'User')
        ? profileProvider.fullName
        : (patient?.name.isNotEmpty == true && patient?.name != 'Guest User'
            ? patient!.name
            : 'Atharva Warankar');
    final email = patient?.email.isNotEmpty == true
        ? patient!.email
        : 'atharva.warankar@example.com';
    final age = patient?.age != null && patient!.age > 0 ? patient.age : 24;
    final gender = patient?.gender.isNotEmpty == true && patient?.gender != 'Other'
        ? patient!.gender
        : 'Male';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: showBackButton && Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          'Profile & Settings',
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        patient?.profileIcon ?? Icons.person_rounded,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Text(
                          email,
                          style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.85)),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                '$age yrs • $gender',
                                style: GoogleFonts.nunito(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                'Prakriti: Vata-Pitta',
                                style: GoogleFonts.nunito(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Assigned Doctor Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: themeProvider.isDarkMode
                    ? AppColors.darkSurface
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.medical_services_rounded,
                        color: AppColors.primary, size: 24),
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
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.verified_rounded,
                                size: 16, color: AppColors.primary),
                          ],
                        ),
                        Text(
                          'Primary Ayurvedic Physician (14 yrs exp)',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: context.txtSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_month_rounded,
                        color: AppColors.primary),
                    tooltip: 'Book Consultation',
                    onPressed: () =>
                        Navigator.pushNamed(context, '/appointments'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Appearance
            _SectionTitle(title: 'Appearance'),
            _SettingsCard(
              children: [
                _SwitchTile(
                  icon: themeProvider.isDarkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  iconColor: themeProvider.isDarkMode
                      ? const Color(0xFF9575CD)
                      : AppColors.accent,
                  label: 'Dark Mode',
                  subtitle: themeProvider.isDarkMode
                      ? 'Currently: Dark theme'
                      : 'Currently: Light theme',
                  value: themeProvider.isDarkMode,
                  onChanged: (v) => context.read<ThemeProvider>().setDark(v),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Notifications
            _SectionTitle(title: 'Notifications'),
            _SettingsCard(
              children: [
                _SwitchTile(
                  icon: Icons.calendar_today_rounded,
                  iconColor: AppColors.primary,
                  label: 'Appointment Reminders',
                  subtitle: 'Get notified 1 hr before appointments',
                  value: true,
                  onChanged: (_) {},
                ),
                const _Divider(),
                _SwitchTile(
                  icon: Icons.medication_rounded,
                  iconColor: AppColors.secondary,
                  label: 'Medicine Reminders',
                  subtitle: 'Daily supplement intake alerts',
                  value: true,
                  onChanged: (_) {},
                ),
                const _Divider(),
                _SwitchTile(
                  icon: Icons.tips_and_updates_rounded,
                  iconColor: AppColors.accent,
                  label: 'Wellness Tips',
                  subtitle: 'Daily Ayurvedic health insights',
                  value: false,
                  onChanged: (_) {},
                ),
                const _Divider(),
                _SwitchTile(
                  icon: Icons.bar_chart_rounded,
                  iconColor: AppColors.info,
                  label: 'Progress Updates',
                  subtitle: 'Weekly health summary',
                  value: true,
                  onChanged: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Health Profile
            _SectionTitle(title: 'Health Profile'),
            _SettingsCard(
              children: [
                _NavTile(
                  icon: Icons.person_rounded,
                  iconColor: AppColors.primary,
                  label: 'Personal Information',
                  onTap: () {},
                ),
                const _Divider(),
                _NavTile(
                  icon: Icons.medical_information_rounded,
                  iconColor: AppColors.secondary,
                  label: 'Medical History',
                  onTap: () {},
                ),
                const _Divider(),
                _NavTile(
                  icon: Icons.emergency_rounded,
                  iconColor: AppColors.error,
                  label: 'Emergency Contacts',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Privacy & Security
            _SectionTitle(title: 'Privacy & Security'),
            _SettingsCard(
              children: [
                _NavTile(
                  icon: Icons.lock_rounded,
                  iconColor: AppColors.primaryDark,
                  label: 'Change Password',
                  onTap: () {},
                ),
                const _Divider(),
                _NavTile(
                  icon: Icons.fingerprint_rounded,
                  iconColor: AppColors.primary,
                  label: 'Biometric Authentication',
                  onTap: () {},
                ),
                const _Divider(),
                _NavTile(
                  icon: Icons.policy_rounded,
                  iconColor: context.txtSecondary,
                  label: 'Privacy Policy',
                  onTap: () {},
                ),
                const _Divider(),
                _NavTile(
                  icon: Icons.description_rounded,
                  iconColor: context.txtSecondary,
                  label: 'Terms & Conditions',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // About
            _SectionTitle(title: 'About'),
            _SettingsCard(
              children: [
                _NavTile(
                  icon: Icons.star_rounded,
                  iconColor: AppColors.accent,
                  label: 'Rate AyuPilot',
                  onTap: () {},
                ),
                const _Divider(),
                _NavTile(
                  icon: Icons.share_rounded,
                  iconColor: AppColors.primary,
                  label: 'Share with Friends',
                  onTap: () {},
                ),
                const _Divider(),
                _NavTile(
                  icon: Icons.help_rounded,
                  iconColor: AppColors.info,
                  label: 'Help & Support',
                  onTap: () {},
                ),
                const _Divider(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('App Version',
                          style: GoogleFonts.nunito(
                              fontSize: 14, color: context.txtSecondary)),
                      Text('1.0.0',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: context.txtSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Logout button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => _confirmLogout(context, authProvider),
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                label: Text(
                  'Log Out',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Log Out?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Text(
          'Are you sure you want to log out of AyuPilot?',
          style: GoogleFonts.nunito(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: context.txtSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Log Out',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: context.txtSecondary),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(children: children),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: GoogleFonts.nunito(
                        fontSize: 11, color: context.txtSecondary)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w500)),
            ),
            Icon(Icons.chevron_right_rounded,
                color: context.txtLight, size: 22),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
        height: 1, indent: 62, endIndent: 16, color: Color(0xFFEDE6DA));
  }
}
