import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class MemoryStoriesScreen extends StatefulWidget {
  const MemoryStoriesScreen({super.key});

  @override
  State<MemoryStoriesScreen> createState() => _MemoryStoriesScreenState();
}

class _MemoryStoriesScreenState extends State<MemoryStoriesScreen> {
  final List<_MemoryStory> _stories = [
    _MemoryStory(
      title: 'Morning Walk at Cubbon Park',
      date: DateTime(2024, 6, 12),
      icon: Icons.park_rounded,
      summary:
          'A peaceful morning walk surrounded by century-old trees and the gentle sound of birds. The fresh air and dappled sunlight created a calming atmosphere that lifted my spirits for the entire day ahead.',
      tags: ['Nature', 'Exercise', 'Peace'],
      aiNote:
          'Walking in nature reduces cortisol and enhances Vata balance. Excellent for your constitution!',
    ),
    _MemoryStory(
      title: "Grandmother's Recipe Day",
      date: DateTime(2024, 5, 28),
      icon: Icons.local_dining_rounded,
      summary:
          "Spent the afternoon recreating grandmother's special turmeric dal with fresh herbs from the garden. The aroma filled the entire house and brought back memories of simpler, healthier times.",
      tags: ['Family', 'Cooking', 'Traditions'],
      aiNote:
          'Cooking traditional Ayurvedic recipes strengthens Agni (digestive fire) - both physical and emotional!',
    ),
    _MemoryStory(
      title: 'Meditative Sunrise Session',
      date: DateTime(2024, 5, 15),
      icon: Icons.wb_twilight_rounded,
      summary:
          'Woke before dawn for a 45-minute pranayama and meditation session as the sun rose over the horizon. The stillness of that time felt restorative and grounding.',
      tags: ['Meditation', 'Yoga', 'Wellness'],
      aiNote:
          'Morning meditation during Brahma Muhurta (pre-dawn) is the most potent time for spiritual practices.',
    ),
  ];

  bool _isGenerating = false;
  final TextEditingController _promptCtrl = TextEditingController();

  @override
  void dispose() {
    _promptCtrl.dispose();
    super.dispose();
  }

  void _generateStory() async {
    final prompt = _promptCtrl.text.trim();
    if (prompt.isEmpty) return;

    setState(() => _isGenerating = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isGenerating = false;
      _stories.insert(
        0,
        _MemoryStory(
          title: prompt,
          date: DateTime.now(),
          icon: Icons.auto_awesome_rounded,
          summary:
              'This beautiful memory is a reminder of life\'s precious moments. '
              'The sensory details - the warmth, the sounds, and the connection '
              'to people and places you love - form the fabric of who you are. '
              'Ayurveda recognizes that positive memories (Smriti) are nourishing '
              'for the mind, body, and spirit.',
          tags: ['Personal', 'Memory', 'Wellness'],
          aiNote:
              'Reminiscing about joyful memories reduces anxiety and supports Ojas (vital energy). Keep collecting these moments!',
        ),
      );
      _promptCtrl.clear();
    });
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
          'Memory Stories',
          style: GoogleFonts.playfairDisplay(
              fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.warmGradient,
                borderRadius: BorderRadius.circular(18),
                border:
                    Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Text('🧠', style: TextStyle(fontSize: 36)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Healing Through Memory',
                          style: GoogleFonts.nunito(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Cherish your precious moments. AI transforms your memories into beautiful healing narratives for cognitive wellness.',
                          style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: context.txtSecondary,
                              height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Add memory section
            Text(
              'Create a Memory Story',
              style:
                  GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _promptCtrl,
                    maxLines: 2,
                    style: GoogleFonts.nunito(fontSize: 14),
                    decoration: InputDecoration(
                      hintText:
                          'Describe a precious memory (e.g., "Sunday lunch with family at the farm")',
                      hintStyle: GoogleFonts.nunito(
                          fontSize: 13, color: context.txtLight),
                      filled: true,
                      fillColor: context.bg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Upload photos suggestion row
                  Row(
                    children: [
                      _UploadChip(
                          icon: Icons.camera_alt_rounded,
                          label: 'Add Photo',
                          onTap: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Photo upload coming soon!',
                                        style: GoogleFonts.nunito()),
                                    backgroundColor: AppColors.primary),
                              )),
                      const SizedBox(width: 10),
                      _UploadChip(
                          icon: Icons.mic_rounded,
                          label: 'Voice Note',
                          onTap: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Voice note coming soon!',
                                        style: GoogleFonts.nunito()),
                                    backgroundColor: AppColors.primary),
                              )),
                      const Spacer(),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton.icon(
                          onPressed: _isGenerating ? null : _generateStory,
                          icon: _isGenerating
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2))
                              : const Icon(Icons.auto_awesome_rounded,
                                  size: 16),
                          label: Text(
                            _isGenerating ? 'Generating...' : 'Generate',
                            style: GoogleFonts.nunito(
                                fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Your Stories (${_stories.length})',
              style:
                  GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            ..._stories.map((story) => _StoryCard(story: story)).toList(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _UploadChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _UploadChip(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: context.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(label,
                style: GoogleFonts.nunito(
                    fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _StoryCard extends StatefulWidget {
  final _MemoryStory story;
  const _StoryCard({required this.story});

  @override
  State<_StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<_StoryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle),
                    child:
                        Icon(story.icon, size: 22, color: AppColors.primary)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.title,
                        style: GoogleFonts.nunito(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(story.date),
                        style: GoogleFonts.nunito(
                            fontSize: 12, color: context.txtSecondary),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: context.txtLight,
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 14),
              const Divider(color: Color(0xFFEDE6DA), height: 1),
              const SizedBox(height: 12),
              Text(
                story.summary,
                style: GoogleFonts.nunito(
                    fontSize: 14, color: context.txt, height: 1.6),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: story.tags
                    .map((t) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.cardLavender,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(t,
                              style: GoogleFonts.nunito(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.info)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Text('🌿', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        story.aiNote,
                        style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: AppColors.primaryDark,
                            fontStyle: FontStyle.italic,
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

class _MemoryStory {
  final String title, summary;
  final IconData icon;
  final DateTime date;
  final List<String> tags;
  final String aiNote;

  const _MemoryStory({
    required this.title,
    required this.date,
    required this.icon,
    required this.summary,
    required this.tags,
    required this.aiNote,
  });
}
