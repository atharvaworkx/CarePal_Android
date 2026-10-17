import 'package:flutter/material.dart';

class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String bio;
  final String location;
  final double rating;
  final int experience;
  final double consultationFee;
  final bool isAvailable;
  final IconData icon;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.bio,
    this.location = '',
    this.rating = 4.5,
    this.experience = 0,
    this.consultationFee = 0.0,
    this.isAvailable = true,
    this.icon = Icons.medical_services_rounded,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'].toString(),
      name: json['name'] ?? 'Dr. Unknown',
      specialty: json['specialization_name'] ?? 'Ayurvedic Consultant',
      bio: json['bio'] ?? '',
      location: json['location'] ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '4.5') ?? 4.5,
      experience: json['experience'] ?? 0,
      consultationFee:
          double.tryParse(json['consultation_fee']?.toString() ?? '0.0') ?? 0.0,
      isAvailable: json['is_active'] ?? true,
      icon: (json['specialization_name']?.toString().contains('Spa') == true)
          ? Icons.spa_rounded
          : Icons.medical_services_rounded,
    );
  }

  static List<DoctorModel> get demoDoctors => const [
        DoctorModel(
          id: 'doc_001',
          name: 'Dr. Yogesh Lokhande',
          specialty: 'Ayurvedic Physician',
          bio: 'Specialist in preventive Ayurveda and lifestyle care.',
          location: 'Pune Wellness Centre',
          rating: 4.9,
          experience: 14,
          consultationFee: 650,
        ),
        DoctorModel(
          id: 'doc_002',
          name: 'Dr. Yash Andhale',
          specialty: 'Panchakarma Specialist',
          bio: 'Helps patients restore balance through personalised therapies.',
          location: 'Mumbai Ayurveda Clinic',
          rating: 4.8,
          experience: 11,
          consultationFee: 550,
          icon: Icons.spa_rounded,
        ),
        DoctorModel(
          id: 'doc_003',
          name: 'Dr. Kartik Deshpande',
          specialty: 'Nutrition and Digestive Health',
          bio:
              'Focuses on digestion, nutrition, and sustainable wellness habits.',
          location: 'AyuPilot Online',
          rating: 4.7,
          experience: 9,
          consultationFee: 450,
        ),
        DoctorModel(
          id: 'doc_004',
          name: 'Dr. Sourabh Gaikwad',
          specialty: 'Stress and Sleep Care',
          bio:
              'Provides practical guidance for stress, sleep, and energy balance.',
          location: 'Nashik Wellness Centre',
          rating: 4.9,
          experience: 13,
          consultationFee: 600,
        ),
        DoctorModel(
          id: 'doc_005',
          name: 'Dr. Pratik Patil',
          specialty: 'General Wellness',
          bio: 'Supports practical daily routines for long-term wellness.',
          location: 'AyuPilot Online',
          rating: 4.6,
          experience: 8,
          consultationFee: 400,
        ),
      ];
}
