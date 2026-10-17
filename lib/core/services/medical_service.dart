import '../constants/api_constants.dart';
import '../services/api_service.dart';

/// Medical history CRUD.
class MedicalService {
  /// GET /api/v1/medical/my_medical_history/
  static Future<Map<String, dynamic>> getMedicalHistory() async {
    final response = await ApiService.get(ApiConstants.myMedicalHistory);
    if (response.statusCode == 200) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// PATCH /api/v1/medical/my_medical_history/
  static Future<Map<String, dynamic>> saveMedicalHistory(
    Map<String, dynamic> data,
  ) async {
    final response =
        await ApiService.patch(ApiConstants.myMedicalHistory, data);
    if (response.statusCode == 200) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }
}
