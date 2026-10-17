// ─────────────────────────────────────────────────
// API Constants - single source of truth for all URLs
// ─────────────────────────────────────────────────

class ApiConstants {
  static const String baseUrl =
      'https://medibackend-production-3260.up.railway.app';
  static const String apiV1 = '$baseUrl/api/v1';

  // Auth
  static const String login = '$apiV1/login/';
  static const String register = '$apiV1/register/';
  static const String logout = '$apiV1/logout/';
  static const String tokenRefresh = '$apiV1/login/refresh/';

  // Profile
  static const String myProfile = '$apiV1/profiles/me/';

  // Medical
  static const String myMedicalHistory = '$apiV1/medical/my_medical_history/';

  // Quiz
  static const String quizQuestions = '$apiV1/questions/';
  static const String quizBulkSubmit = '$apiV1/responses/bulk-submit/';

  // Doctors
  static const String doctors = '$apiV1/doctors/';
  static const String doctorsMatch = '$apiV1/doctors/match/';
  static const String specializations = '$apiV1/specializations/';

  // Appointments
  static const String appointments = '$apiV1/appointments/';
  static const String appointmentsBook = '$apiV1/appointments/book/';
  static const String availabilitySlots = '$apiV1/availability/slots/';

  // Progress  - backend uses ProgressViewSet with @action decorators
  static const String progressLog = '$apiV1/progress/log/';
  static const String progressLogs = '$apiV1/progress/logs/';
  static const String progressSummary = '$apiV1/progress/summary/';
  static const String progressRecommendations =
      '$apiV1/progress/recommendations/';
  static const String progressBookFollowup = '$apiV1/progress/book-followup/';

  // Symptoms (read-only list)
  static const String symptoms = '$apiV1/symptoms/';

  // Medicines & Orders
  static const String medicines = '$apiV1/medicines/';
  static const String orders = '$apiV1/orders/';

  // Reports
  static const String reports = '$apiV1/reports/';
  static const String reportsLatest = '$apiV1/reports/latest_report/';
  static const String generateReport = '$apiV1/reports/generate_report/';
}
