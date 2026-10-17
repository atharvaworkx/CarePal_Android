import '../constants/api_constants.dart';
import '../services/api_service.dart';

/// Fetches AI health reports from the backend.
class ReportService {
  /// GET /api/v1/reports/latest/
  static Future<Map<String, dynamic>> getLatestReport() async {
    final response = await ApiService.get(ApiConstants.reportsLatest);
    if (response.statusCode == 200) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// GET /api/v1/reports/
  static Future<List<dynamic>> getReportsHistory() async {
    final response = await ApiService.get(ApiConstants.reports);
    if (response.statusCode == 200) {
      return ApiService.decodeListBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// POST /api/v1/reports/generate_report/
  static Future<Map<String, dynamic>> generateReport() async {
    final response = await ApiService.post(ApiConstants.generateReport, {});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }
}
