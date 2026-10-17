import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/section_header.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class RemediesScreen extends StatefulWidget {
  const RemediesScreen({super.key});

  @override
  State<RemediesScreen> createState() => _RemediesScreenState();
}

class _RemediesScreenState extends State<RemediesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _categories = [
    'All',
    'Stress',
    'Digestion',
    'Sleep',
    'Immunity',
    'Skin'
  ];
  int _selectedCategory = 0;

  final _remedies = [
    {
      'name': 'Ashwagandha Milk',
      'category': 'Stress',
      'emoji': '🥛',
      'icon': Icons.local_drink_rounded,
      'color': AppColors.cardGold,
      'time': '10 min',
      'description':
          'Warm milk with Ashwagandha powder to soothe Vata and reduce cortisol levels.',
      'ingredients': [
        '1 cup warm milk',
        '1 tsp Ashwagandha powder',
        '1/2 tsp honey',
        'Pinch of cardamom'
      ],
      'steps': [
        'Heat milk gently',
        'Stir in Ashwagandha powder',
        'Add honey and cardamom',
        'Drink 30 min before bed'
      ],
      'dosha': 'Vata',
    },
    {
      'name': 'Triphala Digestive Tonic',
      'category': 'Digestion',
      'emoji': '🍵',
      'icon': Icons.grass_rounded,
      'color': AppColors.cardTerracotta,
      'time': '5 min',
      'description':
          'Classic three-fruit blend for gentle cleansing and digestive fire restoration.',
      'ingredients': [
        '1 tsp Triphala churna',
        '1 cup warm water',
        'Optional: honey'
      ],
      'steps': [
        'Mix Triphala in warm water',
        'Stir well until dissolved',
        'Take on empty stomach',
        'Use consistently for 4–6 weeks'
      ],
      'dosha': 'Tridosha',
    },
    {
      'name': 'Brahmi Tea',
      'category': 'Stress',
      'emoji': '🍃',
      'icon': Icons.spa_rounded,
      'color': AppColors.cardGreen,
      'time': '8 min',
      'description':
          'Brain tonic brew that calms anxiety, sharpens focus, and supports memory.',
      'ingredients': [
        '1 tsp dried Brahmi leaves',
        '1 cup boiling water',
        '1/4 tsp cardamom',
        'Honey to taste'
      ],
      'steps': [
        'Steep Brahmi in hot water 5 min',
        'Strain into cup',
        'Add cardamom and honey',
        'Drink twice daily'
      ],
      'dosha': 'Pitta',
    },
    {
      'name': 'Golden Turmeric Paste',
      'category': 'Immunity',
      'emoji': '🟡',
      'icon': Icons.shield_rounded,
      'color': AppColors.cardGold,
      'time': '15 min',
      'description':
          'Anti-inflammatory golden paste - the Ayurvedic powerhouse for immunity and joint health.',
      'ingredients': [
        '1/4 cup turmeric powder',
        '1/2 tsp black pepper',
        '3 tbsp coconut oil',
        '1/2 cup water'
      ],
      'steps': [
        'Mix turmeric and water in pan',
        'Cook on low 7–8 min',
        'Add pepper and oil',
        'Store in glass jar (refrigerate)'
      ],
      'dosha': 'Kapha',
    },
    {
      'name': 'Tagar Sleep Decoction',
      'category': 'Sleep',
      'emoji': '🌙',
      'icon': Icons.nightlight_round,
      'color': AppColors.cardLavender,
      'time': '12 min',
      'description':
          'Valerian-based herbal decoction for deep, restorative sleep and nervous calm.',
      'ingredients': [
        '1/2 tsp Tagar root powder',
        '1 cup milk',
        '1/4 tsp nutmeg',
        'Honey'
      ],
      'steps': [
        'Add Tagar to milk',
        'Simmer 5 min',
        'Add nutmeg',
        'Sweeten and drink 1 hr before bed'
      ],
      'dosha': 'Vata',
    },
    {
      'name': 'Neem-Turmeric Face Pack',
      'category': 'Skin',
      'emoji': '🌱',
      'icon': Icons.face_retouching_natural_rounded,
      'color': AppColors.cardMint,
      'time': '20 min',
      'description':
          'Purifying skin treatment for acne, blemishes, and healthy glow.',
      'ingredients': [
        '2 tbsp neem powder',
        '1 tsp turmeric',
        '2 tbsp rose water',
        'Few drops neem oil'
      ],
      'steps': [
        'Mix powders together',
        'Add rose water to form paste',
        'Apply on clean skin',
        'Leave 15 min, rinse with cold water'
      ],
      'dosha': 'Pitta',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    if (_selectedCategory == 0)
      return List<Map<String, dynamic>>.from(_remedies);
    final cat = _categories[_selectedCategory];
    return _remedies
        .where((r) => r['category'] == cat)
        .toList()
        .cast<Map<String, dynamic>>();
  }

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
          'Ayurvedic Remedies',
          style: GoogleFonts.playfairDisplay(
              fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text('🌿', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personalised for Vata-Pitta',
                          style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Text(
                          '100% natural - no chemicals, no side effects.',
                          style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.9)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Category filter
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              itemBuilder: (_, i) {
                final selected = i == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? AppColors.primary : context.border,
                      ),
                    ),
                    child: Text(
                      _categories[i],
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color:
                            selected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Remedies list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _RemedyCard(
                remedy: _filtered[i],
                onTap: () => _showRemedyDetail(context, _filtered[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRemedyDetail(BuildContext context, Map<String, dynamic> remedy) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RemedyDetailSheet(remedy: remedy),
    );
  }
}

class _RemedyCard extends StatelessWidget {
  final Map<String, dynamic> remedy;
  final VoidCallback onTap;
  const _RemedyCard({required this.remedy, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: remedy['color'] as Color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                    color: (remedy['color'] as Color).withValues(alpha: 0.3),
                    shape: BoxShape.circle),
                child: Icon(remedy['icon'] as IconData,
                    size: 24, color: AppColors.primaryDark)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    remedy['name'] as String,
                    style: GoogleFonts.nunito(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    remedy['description'] as String,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                        fontSize: 12, color: context.txtSecondary, height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 14, color: context.txtLight),
                      const SizedBox(width: 4),
                      Text(
                        remedy['time'] as String,
                        style: GoogleFonts.nunito(
                            fontSize: 12, color: context.txtSecondary),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          remedy['dosha'] as String,
                          style: GoogleFonts.nunito(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: context.txtSecondary),
          ],
        ),
      ),
    );
  }
}

class _RemedyDetailSheet extends StatelessWidget {
  final Map<String, dynamic> remedy;
  const _RemedyDetailSheet({required this.remedy});

  @override
  Widget build(BuildContext context) {
    final ingredients = List<String>.from(remedy['ingredients'] as List);
    final steps = List<String>.from(remedy['steps'] as List);

    return Container(
      decoration: BoxDecoration(
        color: context.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                        color:
                            (remedy['color'] as Color).withValues(alpha: 0.3),
                        shape: BoxShape.circle),
                    child: Icon(remedy['icon'] as IconData,
                        size: 28, color: AppColors.primaryDark)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        remedy['name'] as String,
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${remedy['category']} • ${remedy['time']}',
                        style: GoogleFonts.nunito(
                            fontSize: 13, color: context.txtSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              remedy['description'] as String,
              style: GoogleFonts.nunito(
                  fontSize: 14, color: context.txtSecondary, height: 1.5),
            ),
            const SizedBox(height: 20),
            SectionHeader(title: '🧾 Ingredients'),
            const SizedBox(height: 10),
            ...ingredients.map(
              (ing) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Text('•',
                        style:
                            TextStyle(color: AppColors.primary, fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(ing, style: GoogleFonts.nunito(fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SectionHeader(title: '👣 How to Prepare'),
            const SizedBox(height: 10),
            ...steps.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AppColors.cardGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text('${e.key + 1}',
                                style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(e.value,
                              style: GoogleFonts.nunito(
                                  fontSize: 14, height: 1.4)),
                        ),
                      ],
                    ),
                  ),
                ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
