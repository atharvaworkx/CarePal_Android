import '../constants/api_constants.dart';
import '../services/api_service.dart';

/// Handles profile GET and update (PATCH) calls.
class ProfileService {
  /// GET /api/v1/profiles/me/
  static Future<Map<String, dynamic>> getMyProfile() async {
    final response = await ApiService.get(ApiConstants.myProfile);
    if (response.statusCode == 200) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// PATCH /api/v1/profiles/me/
  static Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> data,
  ) async {
    final response = await ApiService.patch(ApiConstants.myProfile, data);
    if (response.statusCode == 200) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }
}
