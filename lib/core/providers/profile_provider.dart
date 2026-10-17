import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import '../services/medical_service.dart';

/// Fetches and caches the logged-in user's profile and medical history.
class ProfileProvider extends ChangeNotifier {
  Map<String, dynamic>? _profile = _demoProfile;
  Map<String, dynamic>? _medicalHistory;
  bool _isLoading = false;
  String? _error;

  ProfileProvider() {
    _profile = _demoProfile;
  }

  Map<String, dynamic>? get profile => _profile;
  Map<String, dynamic>? get medicalHistory => _medicalHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String get fullName {
    final profile = _profile;
    if (profile == null) return 'Atharva Warankar';
    final nestedUser = profile['user'];
    final user = nestedUser is Map<String, dynamic> ? nestedUser : profile;
    final fullName = user['fullName'] ?? user['full_name'];
    if (fullName != null &&
        fullName.toString().trim().isNotEmpty &&
        fullName.toString().trim() != 'User') {
      return fullName.toString().trim();
    }
    final firstName = user['firstName'] ?? user['first_name'] ?? '';
    final lastName = user['lastName'] ?? user['last_name'] ?? '';
    final combined = '$firstName $lastName'.trim();
    return combined.isEmpty || combined == 'User' ? 'Atharva Warankar' : combined;
  }

  String get doshaType => (_profile?['dominantPrakriti'] ??
          _profile?['dominant_prakriti'] ??
          'Unknown')
      .toString();

  Future<void> loadProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _profile = await ProfileService.getMyProfile();
      if (_profile!.isEmpty) {
        _profile = _demoProfile;
      }
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _profile = {
        'id': 'patient_atharva',
        'firstName': 'Atharva',
        'lastName': 'Warankar',
        'fullName': 'Atharva Warankar',
        'email': 'atharva.warankar@example.com',
        'phone': '+91 98765 43210',
        'age': 24,
        'gender': 'Male',
        'dominantPrakriti': 'Vata-Pitta',
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMedicalHistory() async {
    _isLoading = true;
    notifyListeners();
    try {
      _medicalHistory = await MedicalService.getMedicalHistory();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _medicalHistory = {
        'conditions': ['Occasional stress'],
        'allergies': ['None reported'],
        'medications': ['None'],
        'dietaryPreference': 'Vegetarian',
        'sleepHours': 7,
        'activityLevel': 'Moderate',
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      _profile = await ProfileService.updateProfile(data);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> saveMedicalHistory(Map<String, dynamic> data) async {
    try {
      _medicalHistory = await MedicalService.saveMedicalHistory(data);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void clear() {
    _profile = null;
    _medicalHistory = null;
    _error = null;
    notifyListeners();
  }

  static const Map<String, dynamic> _demoProfile = {
    'id': 'patient_atharva',
    'firstName': 'Atharva',
    'lastName': 'Warankar',
    'fullName': 'Atharva Warankar',
    'email': 'atharva.warankar@example.com',
    'phone': '+91 98765 43210',
    'age': 24,
    'gender': 'Male',
    'dominantPrakriti': 'Vata-Pitta',
  };
}
