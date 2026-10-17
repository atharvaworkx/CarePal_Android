import '../constants/api_constants.dart';
import '../services/api_service.dart';
import '../storage/token_storage.dart';

/// Handles all authentication API calls:
/// login, register, logout
class AuthService {
  /// Login with email and password.
  /// Returns a map with access, refresh, userId, firstName, lastName, email.
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await ApiService.post(
      ApiConstants.login,
      {'email': email, 'password': password},
      auth: false,
    );

    if (response.statusCode == 200) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// Register a new patient account.
  /// Returns the same map as login (tokens + user info).
  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    int? age,
    String? gender,
  }) async {
    final response = await ApiService.post(
      ApiConstants.register,
      {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'password': password,
        'passwordConfirm': password,
        'age': age,
        'gender': gender,
      },
      auth: false,
    );

    if (response.statusCode == 201) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// Logout - invalidates the refresh token on the server.
  static Future<void> logout() async {
    final refresh = await TokenStorage.getRefreshToken();
    if (refresh != null) {
      await ApiService.post(
        ApiConstants.logout,
        {'refresh': refresh},
      );
    }
    await TokenStorage.clearTokens();
  }
}
