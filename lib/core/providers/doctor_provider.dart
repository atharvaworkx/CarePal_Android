import 'package:flutter/material.dart';
import '../services/doctor_service.dart';
import '../models/doctor_model.dart';

/// Loads doctors and specializations from the backend.
class DoctorProvider extends ChangeNotifier {
  List<dynamic> _doctors = [];
  List<dynamic> _specializations = [];
  bool _isLoading = false;
  String? _error;

  List<dynamic> get doctors => _doctors;
  List<dynamic> get specializations => _specializations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDoctors({bool availableOnly = true}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _doctors = await DoctorService.getDoctors(availableOnly: availableOnly);
      if (_doctors.isEmpty) {
        _doctors = DoctorModel.demoDoctors
            .map((doctor) => {
                  'id': doctor.id,
                  'name': doctor.name,
                  'specialization_name': doctor.specialty,
                  'bio': doctor.bio,
                  'location': doctor.location,
                  'rating': doctor.rating,
                  'experience': doctor.experience,
                  'consultation_fee': doctor.consultationFee,
                  'is_active': doctor.isAvailable,
                })
            .toList();
      }
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _doctors = DoctorModel.demoDoctors
          .map((doctor) => {
                'id': doctor.id,
                'name': doctor.name,
                'specialization_name': doctor.specialty,
                'bio': doctor.bio,
                'location': doctor.location,
                'rating': doctor.rating,
                'experience': doctor.experience,
                'consultation_fee': doctor.consultationFee,
                'is_active': doctor.isAvailable,
              })
          .toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSpecializations() async {
    try {
      _specializations = await DoctorService.getSpecializations();
      notifyListeners();
    } catch (_) {}
  }

  Map<String, dynamic>? getDoctorById(String id) {
    try {
      return _doctors.firstWhere((d) => d['id'].toString() == id)
          as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
