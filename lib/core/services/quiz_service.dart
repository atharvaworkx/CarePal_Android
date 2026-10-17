import '../constants/api_constants.dart';
import '../services/api_service.dart';

/// Quiz question fetching and response submission.
class QuizService {
  /// GET /api/v1/questions/  - returns all active quiz questions with options
  static Future<List<dynamic>> getQuizQuestions() async {
    final response = await ApiService.get(ApiConstants.quizQuestions);
    if (response.statusCode == 200) {
      return ApiService.decodeListBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }

  /// POST /api/v1/responses/bulk-submit/
  /// [responses]: list of { questionId, selectedOptionId, responseValue }
  /// Returns dosha scores: { prakritScores, dominantPrakriti, totalAnswered }
  static Future<Map<String, dynamic>> submitBulk(
    List<Map<String, dynamic>> responses,
  ) async {
    final response = await ApiService.post(
      ApiConstants.quizBulkSubmit,
      {'responses': responses},
    );
    if (response.statusCode == 200) {
      return ApiService.decodeBody(response);
    }
    throw Exception(ApiService.extractError(response));
  }
}
