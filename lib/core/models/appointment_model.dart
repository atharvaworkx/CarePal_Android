import 'package:flutter/material.dart';

class AppointmentModel {
  final String id;
  final String doctorName;
  final String specialty;
  final IconData doctorIcon;
  final DateTime dateTime;
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled'
  final String notes;
  final String consultationType; // 'online', 'in-person'

  const AppointmentModel({
    required this.id,
    required this.doctorName,
    required this.specialty,
    this.doctorIcon = Icons.medical_services_rounded,
    required this.dateTime,
    this.status = 'booked',
    this.notes = '',
    this.consultationType = 'online',
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    // Determine icon based on status or specialization if needed
    IconData icon = Icons.medical_services_rounded;
    if (json['specialty']?.toString().contains('Spa') == true) {
      icon = Icons.spa_rounded;
    }

    return AppointmentModel(
      id: json['id'].toString(),
      doctorName: json['doctor_name'] ?? 'Unknown Doctor',
      specialty: json['specialty'] ?? 'Ayurvedic Consultant',
      doctorIcon: icon,
      dateTime: DateTime.parse(
          json['date'] + ' ' + (json['start_time'] ?? '00:00:00')),
      status: json['status'] ?? 'pending',
      notes: json['notes'] ?? '',
      consultationType: json['consultation_type'] ?? 'online',
    );
  }

  static List<AppointmentModel> get mockList => [
        AppointmentModel(
          id: 'apt_001',
          doctorName: 'Dr. Yogesh Lokhande',
          specialty: 'Ayurvedic Physician & Consultant',
          doctorIcon: Icons.medical_services_rounded,
          dateTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
          status: 'confirmed',
          consultationType: 'online',
          notes: 'Personalized wellness and dosha review for Atharva Warankar.',
        ),
        AppointmentModel(
          id: 'apt_002',
          doctorName: 'Dr. Yogesh Lokhande',
          specialty: 'Ayurvedic Physician & Consultant',
          doctorIcon: Icons.medical_services_rounded,
          dateTime: DateTime.now().add(const Duration(days: 8, hours: 2)),
          status: 'pending',
          consultationType: 'in-person',
          notes: 'Nadi Pariksha (Pulse assessment) & lifestyle follow-up.',
        ),
        AppointmentModel(
          id: 'apt_003',
          doctorName: 'Dr. Yash Andhale',
          specialty: 'Panchakarma Specialist',
          doctorIcon: Icons.spa_rounded,
          dateTime: DateTime.now().add(const Duration(days: 15)),
          status: 'confirmed',
          consultationType: 'online',
        ),
        AppointmentModel(
          id: 'apt_004',
          doctorName: 'Dr. Sourabh Gaikwad',
          specialty: 'Stress and Sleep Care',
          dateTime: DateTime.now().add(const Duration(days: 22)),
          status: 'pending',
          consultationType: 'in-person',
        ),
      ];

  static List<Map<String, dynamic>> get availableDoctors => [
        {
          'name': 'Dr. Yogesh Lokhande',
          'specialty': 'Ayurvedic Physician & Consultant',
          'icon': Icons.medical_services_rounded,
          'rating': 4.9,
          'experience': '14 yrs',
          'available': true,
        },
        {
          'name': 'Dr. Yash Andhale',
          'specialty': 'Panchakarma Specialist',
          'icon': Icons.spa_rounded,
          'rating': 4.8,
          'experience': '11 yrs',
          'available': true,
        },
        {
          'name': 'Dr. Kartik Deshpande',
          'specialty': 'Nutrition & Digestive Health',
          'icon': Icons.healing_rounded,
          'rating': 4.7,
          'experience': '9 yrs',
          'available': true,
        },
        {
          'name': 'Dr. Sourabh Gaikwad',
          'specialty': 'Naturopathy',
          'icon': Icons.healing_rounded,
          'rating': 4.9,
          'experience': '18 yrs',
          'available': true,
        },
      ];
}
