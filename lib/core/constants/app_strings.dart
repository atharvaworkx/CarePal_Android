class AppStrings {
  static const String appName = 'AyuPilot';
  static const String tagline = 'Personalized Ayurvedic Care,\nPowered by AI';

  // Onboarding
  static const List<Map<String, String>> onboardingData = [
    {
      'title': 'Ancient Wisdom,\nModern Intelligence',
      'subtitle':
          'Experience the perfect blend of 5000‑year‑old Ayurvedic principles and cutting‑edge AI - crafted just for you.',
      'icon': 'eco',
    },
    {
      'title': 'Your Personal\nHealth Guardian',
      'subtitle':
          'Get personalized remedies, diet plans, and exercise routines tailored to your unique body constitution.',
      'icon': 'shield',
    },
    {
      'title': 'AI‑Powered\nHealth Analysis',
      'subtitle':
          'Upload iris, tongue, nail images and blood reports. Our AI delivers a comprehensive Ayurvedic diagnosis.',
      'icon': 'biotech',
    },
    {
      'title': 'Heal. Track.\nThrive.',
      'subtitle':
          'Schedule appointments, track your daily progress, and stay connected with your Ayurvedic healing journey.',
      'icon': 'spa',
    },
  ];

  // Medical History Questions
  static const List<Map<String, dynamic>> medicalQuestions = [
    {
      'question': 'Do you have any chronic diseases or conditions?',
      'subtitle': 'Select all that apply',
      'type': 'multi',
      'options': [
        'Diabetes',
        'Hypertension',
        'Heart Disease',
        'Thyroid',
        'Arthritis',
        'Asthma',
        'None',
      ],
    },
    {
      'question': 'Does your family have a history of any conditions?',
      'subtitle': 'Helps us understand genetic predispositions',
      'type': 'text',
      'placeholder': 'e.g. Heart disease, Diabetes in parents...',
    },
    {
      'question': 'What symptoms are you currently experiencing?',
      'subtitle': 'Select all that apply',
      'type': 'multi',
      'options': [
        'Fatigue',
        'Headaches',
        'Digestive issues',
        'Joint pain',
        'Sleep disturbances',
        'Anxiety / Stress',
        'Skin problems',
        'None',
      ],
    },
    {
      'question': 'Do you have any known allergies?',
      'subtitle': 'Food, medicine, or environmental allergies',
      'type': 'multi',
      'options': [
        'Dairy',
        'Gluten',
        'Nuts',
        'Pollen',
        'Dust',
        'Medicines',
        'None',
      ],
    },
    {
      'question': 'What is your current medication regimen?',
      'subtitle': 'List any medicines you take regularly',
      'type': 'text',
      'placeholder': 'e.g. Metformin 500mg daily, Vitamin D...',
    },
    {
      'question': 'What are your dietary preferences?',
      'subtitle': 'Choose the option that best describes you',
      'type': 'single',
      'options': [
        'Vegetarian',
        'Vegan',
        'Non-Vegetarian',
        'Pescatarian',
        'No restrictions',
      ],
    },
    {
      'question': 'Describe your lifestyle habits',
      'subtitle': 'This helps personalise your wellness plan',
      'type': 'lifestyle',
      'fields': ['Sleep (hrs/night)', 'Activity Level', 'Stress Level'],
    },
    {
      'question': 'Any previous treatments or therapies?',
      'subtitle': 'Surgeries, alternative medicine, physiotherapy, etc.',
      'type': 'text',
      'placeholder': 'e.g. Panchakarma in 2022, knee surgery...',
    },
  ];
}
