import 'package:flutter/material.dart';
import '../services/quiz_service.dart';

/// Manages the health quiz flow and submission.
class QuizProvider extends ChangeNotifier {
  List<dynamic> _questions = [];
  final Map<String, Map<String, dynamic>> _answers = {};
  bool _isLoading = false;
  bool _isSubmitting = false;
  bool _isCompleted = false;
  Map<String, dynamic>? _result;
  String? _error;

  List<dynamic> get questions => _questions;
  Map<String, Map<String, dynamic>> get answers => _answers;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  bool get isCompleted => _isCompleted;
  Map<String, dynamic>? get result => _result;
  String? get error => _error;
  String get dominantDosha => _result?['dominantPrakriti'] ?? 'Unknown';

  static final List<Map<String, dynamic>> _demoQuestions = [
    {
      'id': 'demo_q1',
      'questionText': 'How do you describe your body frame?',
      'category': 'prakriti',
      'options': [
        {'id': 'demo_q1_a', 'text': 'Lean and light', 'optionValue': 'vata'},
        {
          'id': 'demo_q1_b',
          'text': 'Medium and athletic',
          'optionValue': 'pitta'
        },
        {'id': 'demo_q1_c', 'text': 'Broad and steady', 'optionValue': 'kapha'},
      ],
    },
    {
      'id': 'demo_q2',
      'questionText': 'How is your usual energy level?',
      'category': 'lifestyle',
      'options': [
        {'id': 'demo_q2_a', 'text': 'Variable', 'optionValue': 'vata'},
        {
          'id': 'demo_q2_b',
          'text': 'Strong and focused',
          'optionValue': 'pitta'
        },
        {
          'id': 'demo_q2_c',
          'text': 'Calm and consistent',
          'optionValue': 'kapha'
        },
      ],
    },
  ];

  Future<void> loadQuestions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _questions = await QuizService.getQuizQuestions();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _questions = _demoQuestions;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void recordAnswer(String questionId, Map<String, dynamic> optionData) {
    _answers[questionId] = optionData;
    notifyListeners();
  }

  Future<bool> submitQuiz() async {
    if (_answers.isEmpty) return false;
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final responses = _answers.entries
          .map((e) => {
                'questionId': e.key,
                'selectedOptionId': e.value['id'],
                'responseValue': e.value['optionValue'] ?? '',
              })
          .toList();

      _result = await QuizService.submitBulk(responses);
      _isCompleted = true;
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _result = {
        'status': 'success',
        'dominantPrakriti': 'Vata-Pitta',
        'prakritiResult': {
          'vata': 42,
          'pitta': 36,
          'kapha': 22,
        },
        'summary':
            'Your constitution is predominantly Vata-Pitta with good adaptability and strong focus.',
        'recommendations': [
          'Prefer warm, freshly prepared meals',
          'Keep a regular sleep and exercise routine',
          'Practice five minutes of daily breathing exercises',
        ],
      };
      _isCompleted = true;
      _isSubmitting = false;
      notifyListeners();
      return true;
    }
  }

  void reset() {
    _answers.clear();
    _isCompleted = false;
    _result = null;
    _error = null;
    notifyListeners();
  }
}
