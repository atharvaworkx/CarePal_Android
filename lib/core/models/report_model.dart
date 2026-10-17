import 'package:flutter/material.dart';

class ReportModel {
  final String id;
  final DateTime createdAt;
  final String overallScore;
  final String doshaType;
  final String doshaDescription;
  final Map<String, double> healthScores;
  final List<String> recommendations;
  final List<String> warnings;
  final bool isProcessing;

  const ReportModel({
    required this.id,
    required this.createdAt,
    required this.overallScore,
    required this.doshaType,
    required this.doshaDescription,
    required this.healthScores,
    this.recommendations = const [],
    this.warnings = const [],
    this.isProcessing = false,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    final prakriti = json['prakritResult'] as Map<String, dynamic>? ?? {};
    final vata = prakriti['vata'] ?? 0;
    final pitta = prakriti['pitta'] ?? 0;
    final kapha = prakriti['kapha'] ?? 0;

    String dosha = 'General';
    if (vata > pitta && vata > kapha)
      dosha = 'Vata';
    else if (pitta > vata && pitta > kapha)
      dosha = 'Pitta';
    else if (kapha > vata && kapha > pitta) dosha = 'Kapha';

    return ReportModel(
      id: json['id'].toString(),
      createdAt: DateTime.tryParse(json['lastGeneratedAt']?.toString() ?? '') ??
          DateTime.now(),
      overallScore:
          '85', // Mock score since backend doesn't have a numeric score yet
      doshaType: dosha,
      doshaDescription: json['overallSummary']?.toString() ?? '',
      healthScores: {
        'Digestion': 70.0,
        'Immunity': 75.0,
        'Sleep': 60.0,
        'Stress': 55.0,
        'Energy': 80.0,
      },
      recommendations: List<String>.from(json['recommendations'] ?? []),
      warnings: List<String>.from(json['riskFlags'] ?? []),
    );
  }

  static int _fallbackIndex = 0;

  static ReportModel get atharvaReport => ReportModel(
        id: 'rep_atharva_001',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        overallScore: '92',
        doshaType: 'Vata-Pitta',
        doshaDescription:
            'Comprehensive Ayurvedic Evaluation for Atharva Warankar supervised by Dr. Yogesh Lokhande. Metabolic Agni is well stabilized with optimal cell regeneration. Sustained energy levels and healthy vital markers noted.',
        healthScores: {
          'Digestion': 89.0,
          'Immunity': 94.0,
          'Sleep': 86.0,
          'Hydration': 84.0,
          'Energy': 91.0,
          'Stress Balance': 80.0,
        },
        recommendations: [
          'Consultation notes by Dr. Yogesh Lokhande: Drink warm water infused with cumin and ginger in the morning.',
          'Practice 15 minutes of Nadi Shodhana Pranayama daily for calming Vata-Pitta equilibrium.',
          'Incorporate cooling, nourishing foods: soaked almonds, coconut water, and mung dal soup.',
          'Maintain a rhythmic sleep schedule (10:30 PM - 6:30 AM) to optimize circadian rejuvenation.',
          'Take Ashwagandha capsules with warm milk after dinner for sound sleep.',
        ],
        warnings: [
          'Mild evening blue-light exposure noted - limit screens 45 mins before bedtime.',
        ],
      );

  static ReportModel get nextFallbackReport => atharvaReport;

  static final List<ReportModel> fallbackReports = [
    atharvaReport,
    ReportModel(
      id: 'fallback_hydration_001',
      createdAt: DateTime.now(),
      overallScore: '88',
      doshaType: 'Vata-Kapha',
      doshaDescription:
          'Your health is largely balanced. A mild hydration deficiency was observed, so increase your daily water intake to support digestion and energy.',
      healthScores: {
        'Digestion': 89,
        'Immunity': 91,
        'Sleep': 86,
        'Hydration': 72,
        'Energy': 88,
      },
      recommendations: [
        'Aim for 8-10 glasses of water throughout the day',
        'Start the morning with a glass of warm water',
        'Include hydrating foods such as cucumber, coconut, and watermelon',
        'Continue regular movement and a consistent sleep routine',
      ],
      warnings: [
        'Mild hydration deficiency detected - increase water intake gradually',
      ],
    ),
    ReportModel(
      id: 'fallback_zinc_001',
      createdAt: DateTime.now(),
      overallScore: '86',
      doshaType: 'Pitta-Vata',
      doshaDescription:
          'Your overall wellness indicators are strong. Zinc levels are slightly below the ideal range and may benefit from mineral-rich dietary choices.',
      healthScores: {
        'Digestion': 87,
        'Immunity': 90,
        'Sleep': 84,
        'Zinc Levels': 69,
        'Energy': 86,
      },
      recommendations: [
        'Include pumpkin seeds, chickpeas, cashews, and lentils in meals',
        'Pair zinc-rich foods with a varied, nutrient-dense diet',
        'Maintain your current sleep and activity routine',
        'Consult a practitioner before starting any supplement',
      ],
      warnings: [
        'Mild zinc deficiency detected - add zinc-rich foods to your meals',
      ],
    ),
    ReportModel(
      id: 'fallback_hydration_002',
      createdAt: DateTime.now(),
      overallScore: '91',
      doshaType: 'Kapha-Pitta',
      doshaDescription:
          'Your report shows very good overall balance. Slightly low hydration can be improved with regular fluids and fresh seasonal foods.',
      healthScores: {
        'Digestion': 93,
        'Immunity': 92,
        'Sleep': 90,
        'Hydration': 76,
        'Energy': 91,
      },
      recommendations: [
        'Keep a water bottle nearby and sip regularly',
        'Choose soups, citrus fruits, and leafy greens for extra hydration',
        'Avoid replacing water with excess caffeinated drinks',
        'Continue your balanced daily routine',
      ],
      warnings: [
        'Hydration is a little below optimal - make fluids a regular habit',
      ],
    ),
    ReportModel(
      id: 'fallback_zinc_002',
      createdAt: DateTime.now(),
      overallScore: '94',
      doshaType: 'Vata-Pitta',
      doshaDescription:
          'Your wellness profile is excellent overall. A small zinc gap was detected, while digestion, immunity, sleep, and energy remain strong.',
      healthScores: {
        'Digestion': 95,
        'Immunity': 94,
        'Sleep': 92,
        'Zinc Levels': 74,
        'Energy': 93,
      },
      recommendations: [
        'Add sesame seeds, pumpkin seeds, and legumes to your meals',
        'Continue eating a varied diet with fresh whole foods',
        'Stay active with gentle yoga or a daily walk',
        'Keep your regular sleep schedule',
      ],
      warnings: [
        'Zinc is slightly below optimal - focus on zinc-rich foods',
      ],
    ),
  ];

  static ReportModel get demoReport => ReportModel(
        id: 'rep_001',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        overallScore: '72',
        doshaType: 'Vata-Pitta',
        doshaDescription:
            'Your constitution has a dominant Vata with rising Pitta. Focus on grounding practices and cooling foods.',
        healthScores: {
          'Digestion': 68.0,
          'Immunity': 75.0,
          'Sleep': 55.0,
          'Stress': 48.0,
          'Energy': 80.0,
          'Skin Health': 72.0,
        },
        recommendations: [
          'Practice Abhyanga (self-massage) with warm sesame oil daily',
          'Include cooling foods like cucumber, coconut, and coriander',
          'Brahmi tea before bedtime to calm Vata energy',
          'Reduce screen time 1 hour before sleep',
          'Incorporate gentle yoga and pranayama in morning routine',
          'Avoid cold and raw foods, especially in the evening',
        ],
        warnings: [
          'Stress levels are high - prioritise mindfulness practices',
          'Sleep quality needs improvement - establish a consistent routine',
        ],
      );

  static ReportModel get nailsReport => ReportModel(
        id: 'rep_nails_001',
        createdAt: DateTime.now(),
        overallScore: '96',
        doshaType: 'Kapha-Vata',
        doshaDescription:
            'Your nail health reflects a well-balanced Kapha-Vata constitution. Strong keratin production and good circulation indicate excellent nutrient absorption and hydration levels.',
        healthScores: {
          'Nail Strength': 97.0,
          'Hydration': 91.0,
          'Keratin Quality': 95.0,
          'Blood Circulation': 93.0,
          'Nutrient Absorption': 94.0,
          'Nail Bed Health': 96.0,
        },
        recommendations: [
          'Continue drinking 8-10 glasses of water daily to maintain optimal hydration',
          'Include biotin-rich foods like almonds, sweet potatoes, and spinach in your diet',
          'Massage nails with warm coconut oil or almond oil twice a week for lustre',
          'Consume Amla (Indian Gooseberry) juice regularly for natural keratin support',
          'Add sesame seeds and flaxseeds to meals for healthy omega fatty acids',
          'Apply a paste of turmeric and honey on cuticles once a week for nourishment',
        ],
        warnings: [
          'Slight dryness detected around cuticles - increase water intake and moisturise regularly',
        ],
      );

  static ReportModel get eyeReport => ReportModel(
        id: 'rep_eye_001',
        createdAt: DateTime.now(),
        overallScore: '79',
        doshaType: 'Pitta-Vata',
        doshaDescription:
            'Your iris analysis indicates a Pitta-dominant constitution with Vata tendencies. There are signs of mild zinc deficiency affecting ocular nourishment. Cooling and mineral-rich dietary adjustments are recommended.',
        healthScores: {
          'Iris Clarity': 82.0,
          'Sclera Health': 76.0,
          'Ocular Hydration': 73.0,
          'Retinal Vitality': 80.0,
          'Zinc Levels': 58.0,
          'Eye Muscle Tone': 85.0,
        },
        recommendations: [
          'Increase zinc-rich foods: pumpkin seeds, chickpeas, cashews, and lentils daily',
          'Practice Trataka (candle-gazing meditation) for 5 minutes daily to strengthen eye muscles',
          'Consume Triphala churna with warm water before bed to support ocular detox',
          'Apply rose water drops to eyes twice a week for natural soothing and hydration',
          'Include Vitamin A-rich foods like carrots, papaya, and dark leafy greens',
          'Take breaks every 20 minutes from screens - follow the 20-20-20 rule',
        ],
        warnings: [
          'Zinc deficiency detected - consider adding zinc-rich foods or an Ayurvedic zinc supplement (Yashad Bhasma) after consulting a practitioner',
          'Mild dryness observed in sclera - stay hydrated and reduce prolonged screen exposure',
        ],
      );

  static List<Map<String, dynamic>> get dummyUploads => [
        {
          'type': 'Iris',
          'icon': Icons.visibility_rounded,
          'uploaded': true,
          'file': 'iris_left.jpg'
        },
        {
          'type': 'Tongue',
          'icon': Icons.account_circle_rounded,
          'uploaded': true,
          'file': 'tongue.jpg'
        },
        {
          'type': 'Nails',
          'icon': Icons.back_hand_rounded,
          'uploaded': false,
          'file': null
        },
        {
          'type': 'Hair',
          'icon': Icons.face_rounded,
          'uploaded': false,
          'file': null
        },
        {
          'type': 'Blood Report',
          'icon': Icons.bloodtype_rounded,
          'uploaded': true,
          'file': 'blood_report.pdf'
        },
      ];
}

class DailyProgress {
  final DateTime date;
  final int steps;
  final double weight;
  final int sleepMinutes;
  final int moodScore; // 1-5
  final int waterGlasses;
  final String note;

  const DailyProgress({
    required this.date,
    this.steps = 0,
    this.weight = 0.0,
    this.sleepMinutes = 0,
    this.moodScore = 3,
    this.waterGlasses = 0,
    this.note = '',
  });

  static List<DailyProgress> get mockWeek {
    final now = DateTime.now();
    return List.generate(
      7,
      (i) => DailyProgress(
        date: now.subtract(Duration(days: 6 - i)),
        steps: [4200, 6800, 5100, 7500, 8200, 5600, 7000][i],
        weight: [68.2, 68.0, 68.1, 67.9, 67.8, 67.7, 67.6][i],
        sleepMinutes: [360, 420, 390, 450, 480, 400, 440][i],
        moodScore: [3, 4, 3, 4, 5, 3, 4][i],
        waterGlasses: [5, 6, 4, 7, 8, 5, 7][i],
      ),
    );
  }
}
