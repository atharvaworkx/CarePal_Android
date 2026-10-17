import 'package:flutter/material.dart';

class PatientModel {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String email;
  final String phone;
  final IconData profileIcon;

  // Medical history
  final List<String> chronicDiseases;
  final String familyHistory;
  final List<String> currentSymptoms;
  final List<String> allergies;
  final String currentMedications;
  final String dietaryPreference;
  final String sleepHours;
  final String activityLevel;
  final String stressLevel;
  final String previousTreatments;

  const PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.email,
    required this.phone,
    this.profileIcon = Icons.person_rounded,
    this.chronicDiseases = const [],
    this.familyHistory = '',
    this.currentSymptoms = const [],
    this.allergies = const [],
    this.currentMedications = '',
    this.dietaryPreference = 'Vegetarian',
    this.sleepHours = '7',
    this.activityLevel = 'Moderate',
    this.stressLevel = 'Moderate',
    this.previousTreatments = '',
  });

  PatientModel copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? email,
    String? phone,
    IconData? profileIcon,
    List<String>? chronicDiseases,
    String? familyHistory,
    List<String>? currentSymptoms,
    List<String>? allergies,
    String? currentMedications,
    String? dietaryPreference,
    String? sleepHours,
    String? activityLevel,
    String? stressLevel,
    String? previousTreatments,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileIcon: profileIcon ?? this.profileIcon,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      familyHistory: familyHistory ?? this.familyHistory,
      currentSymptoms: currentSymptoms ?? this.currentSymptoms,
      allergies: allergies ?? this.allergies,
      currentMedications: currentMedications ?? this.currentMedications,
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
      sleepHours: sleepHours ?? this.sleepHours,
      activityLevel: activityLevel ?? this.activityLevel,
      stressLevel: stressLevel ?? this.stressLevel,
      previousTreatments: previousTreatments ?? this.previousTreatments,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'age': age,
        'gender': gender,
        'email': email,
        'phone': phone,
        'chronicDiseases': chronicDiseases,
        'familyHistory': familyHistory,
        'currentSymptoms': currentSymptoms,
        'allergies': allergies,
        'currentMedications': currentMedications,
        'dietaryPreference': dietaryPreference,
        'sleepHours': sleepHours,
        'activityLevel': activityLevel,
        'stressLevel': stressLevel,
        'previousTreatments': previousTreatments,
      };

  factory PatientModel.fromMap(Map<String, dynamic> map) => PatientModel(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        age: map['age'] ?? 0,
        gender: map['gender'] ?? '',
        email: map['email'] ?? '',
        phone: map['phone'] ?? '',
        chronicDiseases: List<String>.from(map['chronicDiseases'] ?? []),
        familyHistory: map['familyHistory'] ?? '',
        currentSymptoms: List<String>.from(map['currentSymptoms'] ?? []),
        allergies: List<String>.from(map['allergies'] ?? []),
        currentMedications: map['currentMedications'] ?? '',
        dietaryPreference: map['dietaryPreference'] ?? 'Vegetarian',
        sleepHours: map['sleepHours'] ?? '7',
        activityLevel: map['activityLevel'] ?? 'Moderate',
        stressLevel: map['stressLevel'] ?? 'Moderate',
        previousTreatments: map['previousTreatments'] ?? '',
      );

  static PatientModel get demo => const PatientModel(
        id: 'patient_atharva',
        name: 'Atharva Warankar',
        age: 24,
        gender: 'Male',
        email: 'atharva.warankar@example.com',
        phone: '+91 98765 43210',
        profileIcon: Icons.person_rounded,
        chronicDiseases: [],
        currentSymptoms: ['Occasional stress', 'Digestive irregularity'],
        dietaryPreference: 'Vegetarian',
        sleepHours: '7.5',
        activityLevel: 'Active',
        stressLevel: 'Low',
      );
}
