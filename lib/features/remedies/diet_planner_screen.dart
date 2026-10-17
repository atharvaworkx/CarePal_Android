import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/section_header.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class DietPlannerScreen extends StatefulWidget {
  const DietPlannerScreen({super.key});

  @override
  State<DietPlannerScreen> createState() => _DietPlannerScreenState();
}

class _DietPlannerScreenState extends State<DietPlannerScreen> {
  int _selectedDay = 0;
  final _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final _meals = {
    'Breakfast': [
      '🌾 Warm oats with stewed apple, cinnamon & ghee',
      '☕ Ginger-cardamom herbal tea',
      '🍌 Ripe banana (grounding for Vata)',
    ],
    'Mid-Morning': [
      '🌰 Soaked almonds (10) with raisins',
      '🍵 Spiced buttermilk with cumin',
    ],
    'Lunch': [
      '🍚 Basmati rice with mung dal tadka',
      '🥬 Steamed spinach with sesame & lemon',
      '🥕 Carrot-ginger sabzi (lightly spiced)',
      '🫙 Fresh yoghurt (room temperature)',
    ],
    'Evening Snack': [
      '🍫 Dark dates (2–3) with warm milk',
      '🫖 Tulsi-ginger tea',
    ],
    'Dinner': [
      '🍲 Moong soup with turmeric & cumin',
      '🫓 Ghee-roti (2 small, warm)',
      '🥦 Lightly sautéed vegetables',
    ],
  };

  final _mealColors = {
    'Breakfast': AppColors.cardGold,
    'Mid-Morning': AppColors.cardGreen,
    'Lunch': AppColors.cardTerracotta,
    'Evening Snack': AppColors.cardLavender,
    'Dinner': AppColors.cardBlue,
  };

  final _mealEmojis = {
    'Breakfast': '🌅',
    'Mid-Morning': '🍃',
    'Lunch': '☀️',
    'Evening Snack': '🌤️',
    'Dinner': '🌙',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Diet Planner',
          style: GoogleFonts.playfairDisplay(
              fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD4A843), Color(0xFFE8C055)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Text('🥗', style: TextStyle(fontSize: 40)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vata-Pitta Diet Plan',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          Text(
                            'Warm, grounding & easy-to-digest foods to restore balance.',
                            style: GoogleFonts.nunito(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.9),
                                height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Day selector
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SectionHeader(title: 'Weekly Plan'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 68,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _days.length,
                itemBuilder: (_, i) {
                  final selected = i == _selectedDay;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      width: 56,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected ? AppColors.primary : context.border,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _days[i],
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: selected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                          if (i == 0)
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color:
                                    selected ? Colors.white : AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Nutritional summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _NutrientCard(
                      label: 'Calories',
                      value: '1,680',
                      unit: 'kcal',
                      color: AppColors.cardGold),
                  const SizedBox(width: 10),
                  _NutrientCard(
                      label: 'Protein',
                      value: '52',
                      unit: 'g',
                      color: AppColors.cardGreen),
                  const SizedBox(width: 10),
                  _NutrientCard(
                      label: 'Fibre',
                      value: '28',
                      unit: 'g',
                      color: AppColors.cardTerracotta),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Meals
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionHeader(title: "Today's Meal Plan"),
            ),
            const SizedBox(height: 14),
            ...(_meals.entries.toList().map((e) => _MealSection(
                  title: e.key,
                  items: e.value,
                  color: _mealColors[e.key]!,
                  emoji: _mealEmojis[e.key]!,
                ))),
            const SizedBox(height: 20),

            // Foods to avoid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: '🚫 Foods to Avoid'),
                  const SizedBox(height: 12),
                  _AvoidCard(
                    items: [
                      'Cold, raw, or dry foods - aggravate Vata',
                      'Very spicy or fried foods - increase Pitta',
                      'Caffeine excess - disturbs nervous system',
                      'Carbonated drinks - impair digestion',
                      'Leftover or processed foods - low Prana',
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _NutrientCard extends StatelessWidget {
  final String label, value, unit;
  final Color color;
  const _NutrientCard(
      {required this.label,
      required this.value,
      required this.unit,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: context.txt),
            ),
            Text(
              unit,
              style:
                  GoogleFonts.nunito(fontSize: 11, color: context.txtSecondary),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: context.txtSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealSection extends StatelessWidget {
  final String title;
  final Object emoji;
  final List<String> items;
  final Color color;
  const _MealSection(
      {required this.title,
      required this.items,
      required this.color,
      required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji as String, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.txt),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•',
                        style:
                            TextStyle(color: AppColors.primary, fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.nunito(
                            fontSize: 13, color: context.txt, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvoidCard extends StatelessWidget {
  final List<String> items;
  const _AvoidCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.cancel_outlined,
                        color: AppColors.error, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.nunito(
                            fontSize: 13, color: context.txt, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
