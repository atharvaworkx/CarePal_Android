import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/section_header.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  int _selectedFilter = 0;
  final _filters = ['All', 'Morning', 'Evening', 'Yoga', 'Pranayama'];

  final _exercises = [
    {
      'name': 'Surya Namaskar',
      'type': 'Morning',
      'emoji': '🌅',
      'icon': Icons.wb_sunny_rounded,
      'color': AppColors.cardGold,
      'duration': '15 min',
      'intensity': 'Moderate',
      'rounds': '8 rounds',
      'description':
          'The complete body warm-up sequence to awaken all organ systems and balance all three Doshas.',
      'benefits': [
        'Improves flexibility',
        'Boosts metabolism',
        'Energises body',
        'Calms mind'
      ],
      'steps': [
        'Pranamasana (Prayer Pose)',
        'Hasta Uttanasana (Raised Arms Pose)',
        'Hasta Padasana (Forward Bend)',
        'Ashwa Sanchalanasana (Lunge)',
        'Dandasana (Plank)',
        'Ashtanga Namaskara (Eight-point Pose)',
        'Bhujangasana (Cobra Pose)',
        'Adho Mukha Svanasana (Downward Dog)',
        'Repeat in reverse',
      ],
    },
    {
      'name': 'Nadi Shodhana Pranayama',
      'type': 'Pranayama',
      'emoji': '🌬️',
      'icon': Icons.air_rounded,
      'color': AppColors.cardLavender,
      'duration': '10 min',
      'intensity': 'Gentle',
      'rounds': '10 cycles',
      'description':
          'Alternate nostril breathing to balance Ida and Pingala Nadis - reduces stress and sharpens focus.',
      'benefits': [
        'Balances nervous system',
        'Reduces anxiety',
        'Improves focus',
        'Detoxifies lungs'
      ],
      'steps': [
        'Sit in Sukhasana, spine tall',
        'Rest left hand on knee, Mrigi Mudra with right',
        'Close right nostril with right thumb',
        'Inhale through left nostril (4 counts)',
        'Close left with ring finger, release right',
        'Exhale through right (8 counts)',
        'Inhale through right (4 counts)',
        'Close right, exhale through left (8 counts)',
        'This completes one cycle',
      ],
    },
    {
      'name': 'Paschimottanasana',
      'type': 'Evening',
      'emoji': '🧘',
      'icon': Icons.self_improvement_rounded,
      'color': AppColors.cardGreen,
      'duration': '5 min',
      'intensity': 'Gentle',
      'rounds': 'Hold 30–60 sec × 3',
      'description':
          'Seated forward fold to calm the nervous system, stretch hamstrings, and aid digestion before sleep.',
      'benefits': [
        'Calms mind',
        'Stretches spine',
        'Aids digestion',
        'Reduces fatigue'
      ],
      'steps': [
        'Sit with legs stretched forward',
        'Inhale, raise arms overhead',
        'Exhale, fold forward from hips',
        'Hold ankles or shins',
        'Keep spine elongated, not rounded',
        'Hold for 30–60 seconds',
        'Slowly return on inhale',
      ],
    },
    {
      'name': 'Bhramari Pranayama',
      'type': 'Pranayama',
      'emoji': '🐝',
      'icon': Icons.hearing_rounded,
      'color': AppColors.cardMint,
      'duration': '8 min',
      'intensity': 'Gentle',
      'rounds': '5–10 rounds',
      'description':
          'Humming bee breath - powerful for relieving anxiety, migraines, and calming the mind instantly.',
      'benefits': [
        'Relieves stress',
        'Reduces headaches',
        'Improves sleep',
        'Calms tantrums'
      ],
      'steps': [
        'Sit comfortably with closed eyes',
        'Place index fingers on eyebrows',
        'Thumbs gently closing ears',
        'Deep inhale through both nostrils',
        'Exhale with a long "mmm" humming sound',
        'Feel vibration in skull',
        'Repeat 5–10 rounds',
      ],
    },
    {
      'name': 'Evening Walk (Shat Karma)',
      'type': 'Evening',
      'emoji': '🚶',
      'icon': Icons.directions_walk_rounded,
      'color': AppColors.cardTerracotta,
      'duration': '20 min',
      'intensity': 'Easy',
      'rounds': 'Daily',
      'description':
          'A brisk barefoot walk on grass at sunset to ground Vata, improve circulation, and support deep sleep.',
      'benefits': [
        'Grounds Vata energy',
        'Improves circulation',
        'Reduces blood sugar',
        'Promotes sleep'
      ],
      'steps': [
        'Choose a quiet park or garden',
        'Walk barefoot on grass when possible',
        'Moderate pace, not rushed',
        'Focus on breathing - inhale 4 steps, exhale 6',
        'Avoid phone usage',
        'End with 5 min seated meditation',
      ],
    },
    {
      'name': 'Viparita Karani',
      'type': 'Evening',
      'emoji': '🦵',
      'icon': Icons.accessibility_new_rounded,
      'color': AppColors.cardBlue,
      'duration': '10 min',
      'intensity': 'Restorative',
      'rounds': 'Hold 5–10 min',
      'description':
          'Legs-up-the-wall pose - the ultimate restorative pose to drain lymph, reduce leg fatigue, and calm the mind.',
      'benefits': [
        'Reduces leg swelling',
        'Calms nervous system',
        'Improves lymph flow',
        'Promotes relaxation'
      ],
      'steps': [
        'Place mat near a wall',
        'Lie on back, legs up the wall',
        'Arms relaxed at sides',
        'Close eyes, breathe deeply',
        'Hold 5–10 minutes',
        'Roll to side before getting up',
      ],
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedFilter == 0)
      return List<Map<String, dynamic>>.from(_exercises);
    final f = _filters[_selectedFilter];
    return _exercises
        .where((e) => e['type'] == f)
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
          'Exercise & Yoga',
          style: GoogleFonts.playfairDisplay(
              fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B5B95), Color(0xFF8B7BB5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text('🧘', style: TextStyle(fontSize: 36)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI-Personalised Routine',
                          style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Text(
                          'Gentle exercises for Vata-Pitta. 45 min total daily.',
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

          // Filters
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filters.length,
              itemBuilder: (_, i) {
                final selected = i == _selectedFilter;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = i),
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
                      _filters[i],
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

          // Exercise list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _ExerciseCard(
                exercise: _filtered[i],
                onTap: () => _showDetail(context, _filtered[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, Map<String, dynamic> ex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ExerciseDetailSheet(exercise: ex),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final VoidCallback onTap;
  const _ExerciseCard({required this.exercise, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: exercise['color'] as Color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      color:
                          (exercise['color'] as Color).withValues(alpha: 0.3),
                      shape: BoxShape.circle),
                  child: Icon(exercise['icon'] as IconData,
                      size: 24, color: AppColors.primaryDark)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise['name'] as String,
                      style: GoogleFonts.nunito(
                          fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _InfoPill(
                            label: exercise['duration'] as String,
                            icon: Icons.timer_outlined),
                        const SizedBox(width: 8),
                        _InfoPill(
                            label: exercise['intensity'] as String,
                            icon: Icons.flash_on_outlined),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exercise['description'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: context.txtSecondary,
                          height: 1.3),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: context.txtSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final IconData icon;
  const _InfoPill({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: context.txtSecondary),
        const SizedBox(width: 3),
        Text(
          label,
          style: GoogleFonts.nunito(fontSize: 11, color: context.txtSecondary),
        ),
      ],
    );
  }
}

class _ExerciseDetailSheet extends StatelessWidget {
  final Map<String, dynamic> exercise;
  const _ExerciseDetailSheet({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final steps = List<String>.from(exercise['steps'] as List);
    final benefits = List<String>.from(exercise['benefits'] as List);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: context.bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: ListView(
          controller: controller,
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
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                        color:
                            (exercise['color'] as Color).withValues(alpha: 0.3),
                        shape: BoxShape.circle),
                    child: Icon(exercise['icon'] as IconData,
                        size: 30, color: AppColors.primaryDark)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exercise['name'] as String,
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 20, fontWeight: FontWeight.w700)),
                      Text(
                          '${exercise['type']} • ${exercise['duration']} • ${exercise['rounds']}',
                          style: GoogleFonts.nunito(
                              fontSize: 13, color: context.txtSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(exercise['description'] as String,
                style: GoogleFonts.nunito(
                    fontSize: 14, color: context.txtSecondary, height: 1.5)),
            const SizedBox(height: 20),
            SectionHeader(title: '✨ Benefits'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: benefits
                  .map((b) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.cardGreen,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(b,
                            style: GoogleFonts.nunito(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            SectionHeader(title: '👣 Step-by-Step'),
            const SizedBox(height: 10),
            ...steps.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('${e.key + 1}',
                              style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(e.value,
                            style:
                                GoogleFonts.nunito(fontSize: 14, height: 1.4)),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
