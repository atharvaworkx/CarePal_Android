import '../constants/api_constants.dart';
import '../services/api_service.dart';

/// Appointment booking and listing.
/// Backend: AppointmentViewSet with custom @action routes.
class AppointmentService {
  /// GET /api/v1/appointments/  - list patient's appointments (paginated)
  static Future<List<dynamic>> getAppointments() async {
    final response = await ApiService.get(ApiConstants.appointments);
    if (response.statusCode == 200) {
      return ApiService.decodeListBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// POST /api/v1/appointments/book/
  /// Required: doctor_id (int), date (YYYY-MM-DD), start_time (HH:MM:SS)
  /// Optional: notes (string)
  static Future<Map<String, dynamic>> bookAppointment(
    Map<String, dynamic> data,
  ) async {
    final response = await ApiService.post(ApiConstants.appointmentsBook, data);
    if (response.statusCode == 201) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// POST /api/v1/appointments/{id}/cancel/  - cancel appointment
  static Future<Map<String, dynamic>> cancelAppointment(
    String id, {
    String reason = '',
  }) async {
    final url = '${ApiConstants.appointments}$id/cancel/';
    final response = await ApiService.post(url, {'reason': reason});
    if (response.statusCode == 200) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// GET /api/v1/availability/slots/?doctor_id={id}&date={YYYY-MM-DD}
  static Future<Map<String, dynamic>> getAvailableSlots({
    required String doctorId,
    required String date,
  }) async {
    final url =
        '${ApiConstants.availabilitySlots}?doctor_id=$doctorId&date=$date';
    final response = await ApiService.get(url);
    if (response.statusCode == 200) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// POST /api/v1/appointments/{id}/feedback/  - submit rating + feedback
  static Future<Map<String, dynamic>> submitFeedback(
    String id, {
    required int rating,
    String? feedback,
  }) async {
    final url = '${ApiConstants.appointments}$id/feedback/';
    final response = await ApiService.post(url, {
      'rating': rating,
      if (feedback != null) 'feedback': feedback,
    });
    if (response.statusCode == 200) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }
}
