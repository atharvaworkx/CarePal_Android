import '../constants/api_constants.dart';
import '../services/api_service.dart';

/// Medicine browsing and order placement.
class MedicineService {
  /// GET /api/v1/medicines/
  static Future<List<dynamic>> getMedicines({String? category}) async {
    final url = category != null
        ? '${ApiConstants.medicines}?category=$category'
        : ApiConstants.medicines;
    final response = await ApiService.get(url);
    if (response.statusCode == 200) {
      return ApiService.decodeListBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// POST /api/v1/orders/
  /// [items]: list of { medicine_id, quantity }
  static Future<Map<String, dynamic>> placeOrder(
    List<Map<String, dynamic>> items,
  ) async {
    final response = await ApiService.post(
      ApiConstants.orders,
      {'items': items},
    );
    if (response.statusCode == 201) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// GET /api/v1/orders/  - user's order history
  static Future<List<dynamic>> getOrders() async {
    final response = await ApiService.get(ApiConstants.orders);
    if (response.statusCode == 200) {
      return ApiService.decodeListBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }
}
