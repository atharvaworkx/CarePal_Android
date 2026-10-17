import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/appointment_model.dart';
import '../../core/models/doctor_model.dart';
import '../../core/providers/patient_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/section_header.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class AppointmentScreen extends StatefulWidget {
  final bool showBackButton;
  const AppointmentScreen({super.key, this.showBackButton = true});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  int _selectedDoctorIdx = -1;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _consultType = 'online';

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientProvider>().fetchDoctors();
      context.read<PatientProvider>().fetchAppointments();
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: widget.showBackButton && Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          'Appointments',
          style: GoogleFonts.playfairDisplay(
              fontSize: 17, fontWeight: FontWeight.w700),
        ),
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle:
              GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.nunito(fontSize: 14),
          labelColor: AppColors.primary,
          unselectedLabelColor: context.txtSecondary,
          tabs: const [
            Tab(text: 'My Appointments'),
            Tab(text: 'Book New'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _MyAppointmentsTab(),
          _BookAppointmentTab(
            selectedDoctorIdx: _selectedDoctorIdx,
            selectedDate: _selectedDate,
            selectedTime: _selectedTime,
            consultType: _consultType,
            onDoctorChanged: (i) => setState(() => _selectedDoctorIdx = i),
            onDateChanged: (d) => setState(() => _selectedDate = d),
            onTimeChanged: (t) => setState(() => _selectedTime = t),
            onConsultTypeChanged: (t) => setState(() => _consultType = t),
            onBook: () => _bookAppointment(context.read<PatientProvider>().doctors),
          ),
        ],
      ),
    );
  }

  Future<void> _bookAppointment(List<DoctorModel> doctors) async {
    if (_selectedDoctorIdx < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a doctor.', style: GoogleFonts.nunito()),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a date and time.',
              style: GoogleFonts.nunito()),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final doctor = doctors[_selectedDoctorIdx];
    final dt = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final apt = AppointmentModel(
      id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
      doctorName: doctor.name,
      specialty: doctor.specialty,
      doctorIcon: doctor.icon,
      dateTime: dt,
      status: 'pending',
      consultationType: _consultType,
    );

    context.read<PatientProvider>().addAppointment(apt);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Appointment requested! 🎉', style: TextStyle(fontFamily: 'Nunito')),
          backgroundColor: AppColors.success,
        ),
      );
      _tabCtrl.animateTo(0);
      setState(() {
        _selectedDoctorIdx = -1;
        _selectedDate = null;
        _selectedTime = null;
      });
    }
  }
}

class _MyAppointmentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PatientProvider>();
    final apts = provider.appointments;
    
    if (provider.isLoading && apts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final upcoming = apts
        .where((a) =>
            a.dateTime.isAfter(DateTime.now()) && a.status != 'cancelled')
        .toList();
    final past = apts
        .where((a) =>
            a.dateTime.isBefore(DateTime.now()) || a.status == 'cancelled')
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Upcoming (${upcoming.length})'),
          const SizedBox(height: 14),
          if (upcoming.isEmpty)
            const _EmptyCard(
              icon: Icons.calendar_today_rounded,
              message:
                  'No upcoming appointments.\nTap "Book New" to schedule one.',
            )
          else
            ...upcoming
                .map((a) => _AppointmentCard(appointment: a, canCancel: true)),
          const SizedBox(height: 24),
          if (past.isNotEmpty) ...[
            SectionHeader(title: 'Past & Cancelled (${past.length})'),
            const SizedBox(height: 14),
            ...past
                .map((a) => _AppointmentCard(appointment: a, canCancel: false)),
          ],
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final bool canCancel;
  const _AppointmentCard({required this.appointment, required this.canCancel});

  Color get _statusColor => switch (appointment.status) {
        'confirmed' => AppColors.success,
        'pending' => AppColors.warning,
        'cancelled' => AppColors.error,
        _ => AppColors.textLight,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
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
                decoration: const BoxDecoration(
                  color: AppColors.cardGreen,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(appointment.doctorIcon,
                      color: AppColors.primary, size: 24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appointment.doctorName,
                        style: GoogleFonts.nunito(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                    Text(appointment.specialty,
                        style: GoogleFonts.nunito(
                            fontSize: 12, color: context.txtSecondary)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  appointment.status[0].toUpperCase() +
                      appointment.status.substring(1),
                  style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 14, color: context.txtSecondary),
              const SizedBox(width: 6),
              Text(
                DateFormat('EEE, d MMM yyyy').format(appointment.dateTime),
                style: GoogleFonts.nunito(fontSize: 13, color: context.txt),
              ),
              const SizedBox(width: 16),
              Icon(Icons.access_time_outlined,
                  size: 14, color: context.txtSecondary),
              const SizedBox(width: 6),
              Text(
                DateFormat('h:mm a').format(appointment.dateTime),
                style: GoogleFonts.nunito(fontSize: 13, color: context.txt),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.cardLavender,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  appointment.consultationType == 'online'
                      ? '💻 Online'
                      : '🏥 In-Person',
                  style: GoogleFonts.nunito(
                      fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          if (canCancel) ...[
            const SizedBox(height: 12),
            OutlineButton(
              label: 'Cancel Appointment',
              onTap: () {
                context
                    .read<PatientProvider>()
                    .cancelAppointment(appointment.id);
              },
              height: 38,
              color: AppColors.error,
            ),
          ],
        ],
      ),
    );
  }
}

class _BookAppointmentTab extends StatelessWidget {
  final int selectedDoctorIdx;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final String consultType;
  final Function(int) onDoctorChanged;
  final Function(DateTime) onDateChanged;
  final Function(TimeOfDay) onTimeChanged;
  final Function(String) onConsultTypeChanged;
  final VoidCallback onBook;

  const _BookAppointmentTab({
    required this.selectedDoctorIdx,
    required this.selectedDate,
    required this.selectedTime,
    required this.consultType,
    required this.onDoctorChanged,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.onConsultTypeChanged,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PatientProvider>();
    final doctors = provider.doctors;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Select Doctor'),
          const SizedBox(height: 14),
          if (provider.isLoadingDoctors)
             const Center(child: Padding(
               padding: EdgeInsets.all(20.0),
               child: CircularProgressIndicator(),
             ))
          else
            ...doctors.asMap().entries.map((e) {
              final doc = e.value;
              final selected = e.key == selectedDoctorIdx;
              final available = doc.isAvailable;

              return GestureDetector(
                onTap: available ? () => onDoctorChanged(e.key) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.cardGreen : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected ? AppColors.primary : context.border,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle),
                          child: Icon(doc.icon,
                              color: AppColors.primary, size: 22)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc.name,
                                style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: available
                                        ? AppColors.textPrimary
                                        : AppColors.textLight)),
                            Text(doc.specialty,
                                style: GoogleFonts.nunito(
                                    fontSize: 12, color: context.txtSecondary)),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    size: 13, color: AppColors.accent),
                                const SizedBox(width: 2),
                                Text('${doc.rating}',
                                    style: GoogleFonts.nunito(fontSize: 11)),
                                const SizedBox(width: 8),
                                Icon(Icons.work_outline_rounded,
                                    size: 12, color: context.txtLight),
                                const SizedBox(width: 2),
                                Text('${doc.experience} yrs',
                                    style: GoogleFonts.nunito(
                                        fontSize: 11,
                                        color: context.txtSecondary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (!available)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Unavailable',
                              style: GoogleFonts.nunito(
                                  fontSize: 10,
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w700)),
                        )
                      else if (selected)
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.primary, size: 22),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Consultation Type'),
          const SizedBox(height: 14),
          Row(
            children: [
              _ConsultTypeCard(
                icon: Icons.videocam_rounded,
                label: 'Online',
                value: 'online',
                selected: consultType == 'online',
                onTap: () => onConsultTypeChanged('online'),
              ),
              const SizedBox(width: 12),
              _ConsultTypeCard(
                icon: Icons.local_hospital_rounded,
                label: 'In-Person',
                value: 'in-person',
                selected: consultType == 'in-person',
                onTap: () => onConsultTypeChanged('in-person'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Select Date & Time'),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 60)),
                      builder: (_, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColors.primary,
                            surface: context.bg,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (d != null) onDateChanged(d);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selectedDate != null
                          ? AppColors.cardGreen
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedDate != null
                            ? AppColors.primary
                            : context.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          selectedDate != null
                              ? DateFormat('d MMM yyyy').format(selectedDate!)
                              : 'Select Date',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selectedDate != null
                                ? AppColors.primaryDark
                                : AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final t = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 10, minute: 0),
                      builder: (_, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                              primary: AppColors.primary),
                        ),
                        child: child!,
                      ),
                    );
                    if (t != null) onTimeChanged(t);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selectedTime != null
                          ? AppColors.cardGreen
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedTime != null
                            ? AppColors.primary
                            : context.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          selectedTime != null
                              ? selectedTime!.format(context)
                              : 'Select Time',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selectedTime != null
                                ? AppColors.primaryDark
                                : AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            label: 'Request Appointment',
            onTap: onBook,
            icon: Icons.calendar_month_rounded,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

}

class _ConsultTypeCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final bool selected;
  final VoidCallback onTap;
  const _ConsultTypeCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? AppColors.cardGreen : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primary : context.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 28,
                  color:
                      selected ? AppColors.primaryDark : AppColors.textPrimary),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color:
                      selected ? AppColors.primaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyCard({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 40, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                  fontSize: 14, color: context.txtSecondary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
