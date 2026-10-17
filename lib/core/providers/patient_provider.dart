import 'dart:math';
import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../models/appointment_model.dart';
import '../models/report_model.dart';
import '../models/medicine_model.dart';
import '../models/doctor_model.dart';
import '../services/appointment_service.dart';
import '../services/medicine_service.dart';
import '../services/report_service.dart';
import '../services/doctor_service.dart';

class PatientProvider extends ChangeNotifier {
  PatientModel? _patient;
  List<AppointmentModel> _appointments = [];
  ReportModel? _latestReport;
  bool _isLoading = false;
  bool _isLoadingMedicines = false;
  bool _isLoadingDoctors = false;
  bool _isProcessingReport = false;
  List<DailyProgress> _weekProgress = DailyProgress.mockWeek;
  DailyProgress? _todayProgress;
  List<MedicineModel> _medicines = [];
  List<DoctorModel> _doctors = [];
  String _currentHealthThought = "";

  final List<String> _healthThoughts = [
    "Drink warm water to awaken your Agni.",
    "Health is the greatest gift, contentment the greatest wealth.",
    "Early to bed and early to rise makes a man healthy, wealthy, and wise.",
    "Your food should be your first medicine.",
    "Practice mindfulness daily for a calm mind.",
    "A regular sleep cycle is the key to longevity.",
    "Yoga is the journey of the self, to the self.",
    "Balance your doshas with seasonal eating.",
    "Hydration is essential for clear skin.",
    "Deep breathing reduces stress instantly.",
    "Ginger tea is excellent for digestion.",
    "A brisk walk in nature heals the soul.",
    "Consistency is the key to wellness.",
    "Listen to your body, it knows best.",
    "Ayurveda is the science of life.",
    "Fresh air and sunshine are natural healers.",
    "Laughter is the best medicine for the heart.",
    "Proper posture improves energy flow.",
    "Avoid cold drinks with meals for better digestion.",
    "Meditation brings clarity to your day."
  ];

  // Cart
  final List<MedicineModel> _cart = [];

  // Getters
  PatientModel? get patient => _patient;
  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);
  ReportModel? get latestReport => _latestReport;
  bool get isLoading => _isLoading;
  bool get isLoadingMedicines => _isLoadingMedicines;
  bool get isLoadingDoctors => _isLoadingDoctors;
  bool get isProcessingReport => _isProcessingReport;
  List<DailyProgress> get weekProgress => _weekProgress;
  DailyProgress? get todayProgress => _todayProgress;
  List<MedicineModel> get medicines => List.unmodifiable(_medicines);
  List<DoctorModel> get doctors => List.unmodifiable(_doctors);
  String get currentHealthThought => _currentHealthThought;
  List<MedicineModel> get cart => List.unmodifiable(_cart);
  int get cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);
  double get cartTotal =>
      _cart.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  PatientProvider() {
    _refreshHealthThought();
    _patient = PatientModel.demo;
    _appointments = AppointmentModel.mockList;
    _doctors = DoctorModel.demoDoctors;
    _medicines = MedicineModel.catalog;
    _latestReport = ReportModel.atharvaReport;
  }

  void _refreshHealthThought() {
    _currentHealthThought =
        _healthThoughts[Random().nextInt(_healthThoughts.length)];
  }

  void initPatient(PatientModel patient) {
    _patient = patient;
    notifyListeners();
  }

  void updatePatient(PatientModel patient) {
    _patient = patient;
    notifyListeners();
  }

  Future<void> fetchAppointments() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await AppointmentService.getAppointments();
      if (data.isNotEmpty) {
        _appointments =
            data.map((json) => AppointmentModel.fromJson(json)).toList();
        if (!_appointments.any((a) => a.doctorName.toLowerCase().contains('yogesh'))) {
          _appointments.insert(0, AppointmentModel.mockList.first);
        }
      } else {
        _appointments = AppointmentModel.mockList;
      }
    } catch (e) {
      debugPrint('Error fetching appointments: $e');
      _appointments = AppointmentModel.mockList;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMedicines() async {
    _isLoadingMedicines = true;
    notifyListeners();

    try {
      final data = await MedicineService.getMedicines();
      _medicines = data.isEmpty
          ? MedicineModel.catalog
          : data.map((json) => MedicineModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching medicines: $e');
      _medicines = MedicineModel.catalog;
    } finally {
      _isLoadingMedicines = false;
      notifyListeners();
    }
  }

  Future<void> fetchDoctors() async {
    _isLoadingDoctors = true;
    notifyListeners();

    try {
      final data = await DoctorService.getDoctors();
      if (data.isNotEmpty) {
        _doctors = data.map((json) => DoctorModel.fromJson(json)).toList();
        if (!_doctors.any((d) => d.name.toLowerCase().contains('yogesh'))) {
          _doctors.insert(0, DoctorModel.demoDoctors.first);
        }
      } else {
        _doctors = DoctorModel.demoDoctors;
      }
    } catch (e) {
      debugPrint('Error fetching doctors: $e');
      _doctors = DoctorModel.demoDoctors;
    } finally {
      _isLoadingDoctors = false;
      notifyListeners();
    }
  }

  Future<void> fetchLatestReport() async {
    try {
      final data = await ReportService.getLatestReport();
      final reportData = data['report'];
      if (reportData is Map<String, dynamic> && reportData.isNotEmpty) {
        _latestReport = ReportModel.fromJson(reportData);
      } else if (data['id'] != null) {
        _latestReport = ReportModel.fromJson(data);
      } else {
        _latestReport = ReportModel.atharvaReport;
      }
    } catch (e) {
      debugPrint('Error fetching latest report: $e');
      _latestReport = ReportModel.atharvaReport;
    }
    notifyListeners();
  }

  // Report processing
  Future<void> processReport({Set<String>? uploadedSections}) async {
    _isProcessingReport = true;
    notifyListeners();

    try {
      await ReportService.generateReport();
      await fetchLatestReport();
    } catch (e) {
      debugPrint('Error generating report: $e');
      _latestReport = ReportModel.nextFallbackReport;
    }

    _isProcessingReport = false;
    notifyListeners();
  }

  // Appointments
  void addAppointment(AppointmentModel appointment) {
    _appointments = [..._appointments, appointment];
    notifyListeners();
  }

  void cancelAppointment(String id) {
    _appointments = _appointments
        .map((a) => a.id == id
            ? AppointmentModel(
                id: a.id,
                doctorName: a.doctorName,
                specialty: a.specialty,
                doctorIcon: a.doctorIcon,
                dateTime: a.dateTime,
                status: 'cancelled',
                consultationType: a.consultationType,
              )
            : a)
        .toList();
    notifyListeners();
  }

  // Progress
  void updateTodayProgress(DailyProgress progress) {
    _todayProgress = progress;
    notifyListeners();
  }

  // Cart
  void addToCart(MedicineModel medicine) {
    final idx = _cart.indexWhere((m) => m.id == medicine.id);
    if (idx >= 0) {
      _cart[idx].quantity++;
    } else {
      final m = MedicineModel(
        id: medicine.id,
        name: medicine.name,
        description: medicine.description,
        icon: medicine.icon,
        price: medicine.price,
        unit: medicine.unit,
        category: medicine.category,
        rating: medicine.rating,
        reviewCount: medicine.reviewCount,
        benefits: medicine.benefits,
        quantity: 1,
      );
      _cart.add(m);
    }
    notifyListeners();
  }

  void removeFromCart(String id) {
    _cart.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
