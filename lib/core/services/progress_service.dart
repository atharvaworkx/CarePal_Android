import '../constants/api_constants.dart';
import '../services/api_service.dart';

/// Daily health progress logging and analytics.
/// Backend: ProgressViewSet with custom @action routes under /api/v1/progress/
class ProgressService {
  /// GET /api/v1/progress/logs/?days=30  - paginated health logs
  static Future<Map<String, dynamic>> getProgressLogs({int days = 30}) async {
    final url = '${ApiConstants.progressLogs}?days=$days';
    final response = await ApiService.get(url);
    if (response.statusCode == 200) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// GET /api/v1/progress/summary/?period=30  - dosha analytics
  static Future<Map<String, dynamic>> getSummary({int period = 30}) async {
    final url = '${ApiConstants.progressSummary}?period=$period';
    final response = await ApiService.get(url);
    if (response.statusCode == 200) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// POST /api/v1/progress/log/  - log today's health data
  /// Required fields: date (YYYY-MM-DD), energy_level (1-5),
  ///   digestion_quality (1-5), stress_level (1-5), sleep_hours (float)
  /// Optional fields: diet_notes, symptom_notes, bowel_pattern,
  ///   exercise_notes, mood_notes, symptoms ([{symptom_id, severity}])
  static Future<Map<String, dynamic>> logToday(
    Map<String, dynamic> data,
  ) async {
    final response = await ApiService.post(ApiConstants.progressLog, data);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// GET /api/v1/progress/recommendations/  - follow-up recommendations
  static Future<Map<String, dynamic>> getRecommendations() async {
    final response = await ApiService.get(ApiConstants.progressRecommendations);
    if (response.statusCode == 200) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// GET /api/v1/symptoms/  - list of trackable symptoms
  static Future<List<dynamic>> getSymptoms() async {
    final response = await ApiService.get(ApiConstants.symptoms);
    if (response.statusCode == 200) {
      return ApiService.decodeListBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }
}
