import '../constants/api_constants.dart';
import '../services/api_service.dart';

/// Doctor list, matching and specialization services.
class DoctorService {
  /// GET /api/v1/doctors/  - list verified+available doctors
  static Future<List<dynamic>> getDoctors({bool availableOnly = false}) async {
    final url = availableOnly
        ? '${ApiConstants.doctors}?is_available=true'
        : ApiConstants.doctors;
    final response = await ApiService.get(url);
    if (response.statusCode == 200) {
      return ApiService.decodeListBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// GET /api/v1/doctors/{id}/  - doctor detail
  static Future<Map<String, dynamic>> getDoctorDetail(dynamic id) async {
    final response = await ApiService.get('${ApiConstants.doctors}$id/');
    if (response.statusCode == 200) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// GET /api/v1/doctors/match/  - AI-matched doctors for current user's dosha
  /// Returns: { status, is_critical, recommended_doctors: [...] }
  static Future<Map<String, dynamic>> matchDoctors() async {
    final response = await ApiService.get(ApiConstants.doctorsMatch);
    if (response.statusCode == 200) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// GET /api/v1/doctors/{id}/availability/  - doctor's weekly slots
  static Future<Map<String, dynamic>> getDoctorAvailability(dynamic id) async {
    final response =
        await ApiService.get('${ApiConstants.doctors}$id/availability/');
    if (response.statusCode == 200) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// GET /api/v1/specializations/
  static Future<List<dynamic>> getSpecializations() async {
    final response = await ApiService.get(ApiConstants.specializations);
    if (response.statusCode == 200) {
      return ApiService.decodeListBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }
}
