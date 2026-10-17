import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';
import '../constants/api_constants.dart';

/// Base HTTP service that wraps [http] with automatic JWT refresh and retry.
class ApiService {
  static Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (auth) {
      final token = await TokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  static Future<http.Response> get(String url) async {
    var headers = await _headers();
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 401 && await _refreshToken()) {
      headers = await _headers();
      response = await http.get(Uri.parse(url), headers: headers);
    }
    return response;
  }

  static Future<http.Response> post(
    String url,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    var headers = await _headers(auth: auth);
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 401 && auth && await _refreshToken()) {
      headers = await _headers();
      response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
    }
    return response;
  }

  static Future<http.Response> patch(
    String url,
    Map<String, dynamic> body,
  ) async {
    var headers = await _headers();
    var response = await http.patch(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 401 && await _refreshToken()) {
      headers = await _headers();
      response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
    }
    return response;
  }

  static Future<http.Response> put(
    String url,
    Map<String, dynamic> body,
  ) async {
    var headers = await _headers();
    return http.put(Uri.parse(url), headers: headers, body: jsonEncode(body));
  }

  static Future<bool> _refreshToken() async {
    final refresh = await TokenStorage.getRefreshToken();
    if (refresh == null || refresh.isEmpty) return false;
    final response = await http.post(
      Uri.parse(ApiConstants.tokenRefresh),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refresh}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final access = data['access'];
      if (access is String && access.isNotEmpty) {
        await TokenStorage.saveTokens(
          access: access,
          refresh: data['refresh'] ?? refresh,
          userId: await TokenStorage.getUserId() ?? '',
        );
        return true;
      }
    }
    await TokenStorage.clearTokens();
    return false;
  }

  static Map<String, dynamic> decodeBody(http.Response response) {
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }

  static List<dynamic> decodeListBody(http.Response response) {
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is List) return decoded;
    if (decoded is Map && decoded['results'] is List) {
      return decoded['results'] as List;
    }
    return [];
  }

  static String? extractError(http.Response response) {
    try {
      final data = decodeBody(response);
      if (data.containsKey('detail')) return data['detail'].toString();
      if (data.containsKey('non_field_errors')) {
        final errors = data['non_field_errors'];
        if (errors is List && errors.isNotEmpty) return errors.first.toString();
      }
      for (final value in data.values) {
        if (value is List && value.isNotEmpty) return value.first.toString();
        if (value is String) return value;
      }
      return 'An error occurred';
    } catch (_) {
      return response.reasonPhrase ?? 'Unknown error';
    }
  }
}
