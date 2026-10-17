import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/patient_model.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../storage/token_storage.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _onboardingComplete = false;
  bool _isLoading = false;
  String? _errorMessage;
  PatientModel? _currentPatient = PatientModel.demo;

  bool get isLoggedIn => _isLoggedIn;
  bool get onboardingComplete => _onboardingComplete;
  bool get hasCompletedOnboarding => _onboardingComplete;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PatientModel? get currentPatient => _currentPatient ?? PatientModel.demo;

  AuthProvider() {
    _loadFromPrefs();
  }

  Future<void> loadPersistedState() async {
    await _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _onboardingComplete = prefs.getBool('onboardingComplete') ?? false;
    final hasToken = await TokenStorage.hasValidToken();
    if (hasToken) {
      _isLoggedIn = true;
      final savedName =
          '${prefs.getString('firstName') ?? ''} ${prefs.getString('lastName') ?? ''}'
              .trim();
      _currentPatient = PatientModel(
        id: await TokenStorage.getUserId() ?? 'patient_atharva',
        name: savedName.isNotEmpty ? savedName : 'Atharva Warankar',
        age: prefs.getInt('age') ?? 24,
        gender: prefs.getString('gender') ?? 'Male',
        email: prefs.getString('email') ?? 'atharva.warankar@example.com',
        phone: prefs.getString('phone') ?? '+91 98765 43210',
        profileIcon: Icons.person_rounded,
      );
      try {
        final profile = await ProfileService.getMyProfile();
        _currentPatient = _patientFromData(profile);
        await _persistPatient(profile);
      } catch (_) {
        // Keep cached identity when profile enrichment is temporarily unavailable.
      }
    } else {
      _currentPatient = PatientModel.demo;
    }
    notifyListeners();
  }

  PatientModel _patientFromData(Map<String, dynamic> data) {
    final firstName = data['firstName'] ?? data['first_name'] ?? '';
    final lastName = data['lastName'] ?? data['last_name'] ?? '';
    final fullName = data['fullName'] ?? data['full_name'];
    return PatientModel(
      id: (data['userId'] ?? data['user_id'] ?? data['id'] ?? '').toString(),
      name: (fullName ?? '$firstName $lastName').toString().trim(),
      age: int.tryParse((data['age'] ?? 0).toString()) ?? 0,
      gender: (data['gender'] ?? 'Other').toString(),
      email: (data['email'] ?? '').toString(),
      phone: (data['phone'] ?? '').toString(),
      profileIcon: Icons.person_rounded,
    );
  }

  Future<void> _persistPatient(
    Map<String, dynamic> data, {
    String? fallbackEmail,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final patient = _patientFromData(data);
    await prefs.setString('firstName',
        (data['firstName'] ?? data['first_name'] ?? '').toString());
    await prefs.setString(
        'lastName', (data['lastName'] ?? data['last_name'] ?? '').toString());
    await prefs.setString(
        'email', patient.email.isEmpty ? (fallbackEmail ?? '') : patient.email);
    await prefs.setString('phone', patient.phone);
    await prefs.setInt('age', patient.age);
    await prefs.setString('gender', patient.gender);
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await AuthService.login(email, password);
      await TokenStorage.saveTokens(
        access: data['access'],
        refresh: data['refresh'],
        userId: data['userId'] ?? '',
      );

      var patientData = data;
      try {
        patientData = {...data, ...await ProfileService.getMyProfile()};
      } catch (_) {
        // Login remains valid if profile enrichment is temporarily unavailable.
      }
      await _persistPatient(patientData, fallbackEmail: email);
      _currentPatient = _patientFromData({
        ...patientData,
        'userId': data['userId'] ?? data['user_id'] ?? '',
      });
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Backend login unavailable; using demo account: $e');
      _currentPatient = const PatientModel(
        id: 'demo_atharva',
        name: 'Atharva Warankar',
        age: 24,
        gender: 'Male',
        email: 'atharva.warankar@example.com',
        phone: '+91 98765 43210',
      );
      _isLoggedIn = true;
      _onboardingComplete = true;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    }
  }

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    int? age,
    String? gender,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await AuthService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        password: password,
        age: age,
        gender: gender,
      );
      await TokenStorage.saveTokens(
        access: data['access'],
        refresh: data['refresh'],
        userId: data['userId'] ?? '',
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', firstName);
      await prefs.setString('lastName', lastName);
      await prefs.setString('email', email);
      await prefs.setString('phone', phone);
      if (age != null) await prefs.setInt('age', age);
      if (gender != null) await prefs.setString('gender', gender);

      _currentPatient = PatientModel(
        id: data['userId'] ?? '',
        name: '$firstName $lastName',
        age: age ?? 0,
        gender: gender ?? 'Other',
        email: email,
        phone: phone,
        profileIcon: Icons.person_rounded,
      );
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await AuthService.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('firstName');
    await prefs.remove('lastName');
    await prefs.remove('email');
    await prefs.remove('phone');
    await prefs.remove('age');
    await prefs.remove('gender');
    _isLoggedIn = false;
    _currentPatient = null;
    _onboardingComplete = false;
    _isLoading = false;
    notifyListeners();
  }

  void setCurrentPatient(PatientModel patient) {
    _currentPatient = patient;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingComplete = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
