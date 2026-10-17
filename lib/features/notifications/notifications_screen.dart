import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_Notification> _notifications = [
    _Notification(
      type: _NotifType.appointment,
      title: 'Appointment Tomorrow',
      body:
          'Your consultation with Dr. Priya Nair is scheduled for tomorrow at 11:00 AM.',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
    ),
    _Notification(
      type: _NotifType.report,
      title: 'AI Report Ready',
      body:
          'Your Ayurvedic health analysis is complete. Your overall score is 78/100.',
      time: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
    ),
    _Notification(
      type: _NotifType.medicine,
      title: 'Medicine Reminder',
      body:
          'Time to take your Ashwagandha supplement. 2 capsules with warm milk.',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    _Notification(
      type: _NotifType.wellness,
      title: 'Daily Wellness Tip',
      body:
          'Start your morning with 2 glasses of warm water with lemon and honey for optimal Agni.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    _Notification(
      type: _NotifType.progress,
      title: '5-Day Streak! 🔥',
      body:
          "You've logged your health data for 5 consecutive days. Keep it up!",
      time: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      isRead: true,
    ),
    _Notification(
      type: _NotifType.medicine,
      title: 'Order Delivered',
      body:
          'Your Chyawanprash and Triphala order has been delivered successfully.',
      time: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    _Notification(
      type: _NotifType.wellness,
      title: 'Weekly Check-In',
      body:
          'How are you feeling this week? Log your mood and update your health tracker.',
      time: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
    _Notification(
      type: _NotifType.appointment,
      title: 'Appointment Completed',
      body:
          'Your consultation with Dr. Rajesh Sharma is complete. View your prescription.',
      time: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 17, fontWeight: FontWeight.w700),
            ),
            if (unreadCount > 0)
              Text(
                '$unreadCount unread',
                style: GoogleFonts.nunito(
                    fontSize: 12, color: context.txtSecondary),
              ),
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  for (final n in _notifications) {
                    n.isRead = true;
                  }
                });
              },
              child: Text(
                'Mark all read',
                style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🔔', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text('No notifications yet',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text("You're all caught up!",
                      style: GoogleFonts.nunito(color: context.txtSecondary)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: _notifications.length,
              itemBuilder: (_, i) {
                return Dismissible(
                  key: ValueKey(_notifications[i]),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.delete_rounded,
                        color: AppColors.error),
                  ),
                  onDismissed: (_) {
                    setState(() => _notifications.removeAt(i));
                  },
                  child: _NotifCard(
                    notification: _notifications[i],
                    onTap: () =>
                        setState(() => _notifications[i].isRead = true),
                  ),
                );
              },
            ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final _Notification notification;
  final VoidCallback onTap;
  const _NotifCard({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final n = notification;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: n.isRead ? AppColors.surface : AppColors.cardGreen,
          borderRadius: BorderRadius.circular(14),
          border: n.isRead
              ? null
              : Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: n.type.bgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(n.type.icon, size: 20, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          n.title,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight:
                                n.isRead ? FontWeight.w500 : FontWeight.w700,
                          ),
                        ),
                      ),
                      if (!n.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: AppColors.primary, shape: BoxShape.circle),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    n.body,
                    style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: n.isRead
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        height: 1.4),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _timeAgo(n.time),
                    style: GoogleFonts.nunito(
                        fontSize: 11, color: context.txtLight),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

enum _NotifType { appointment, report, medicine, wellness, progress }

extension _NotifTypeX on _NotifType {
  IconData get icon {
    switch (this) {
      case _NotifType.appointment:
        return Icons.calendar_today_rounded;
      case _NotifType.report:
        return Icons.analytics_rounded;
      case _NotifType.medicine:
        return Icons.medication_rounded;
      case _NotifType.wellness:
        return Icons.eco_rounded;
      case _NotifType.progress:
        return Icons.local_fire_department_rounded;
    }
  }

  Color get bgColor {
    switch (this) {
      case _NotifType.appointment:
        return AppColors.cardLavender;
      case _NotifType.report:
        return AppColors.cardGold;
      case _NotifType.medicine:
        return AppColors.cardTerracotta;
      case _NotifType.wellness:
        return AppColors.cardGreen;
      case _NotifType.progress:
        return const Color(0xFFFFF3E0);
    }
  }
}

class _Notification {
  final _NotifType type;
  final String title, body;
  final DateTime time;
  bool isRead;

  _Notification({
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
  });
}
