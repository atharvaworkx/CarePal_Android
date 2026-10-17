import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      _addBotMessage(
        'Namaste! 🙏 I\'m Ayu, your personal Ayurvedic wellness assistant.\n\nI can help you with:\n• Understanding your dosha\n• Herbal remedies & diet tips\n• Lifestyle guidance\n• Reading your health reports\n\nHow can I assist you today?',
      );
    });
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages
          .add(_ChatMessage(text: text, isUser: false, time: DateTime.now()));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final trimmed = text.trim();
    _inputCtrl.clear();

    setState(() {
      _messages
          .add(_ChatMessage(text: trimmed, isUser: true, time: DateTime.now()));
      _isTyping = true;
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1400), () {
      setState(() => _isTyping = false);
      _addBotMessage(_generateResponse(trimmed));
    });
  }

  String _generateResponse(String query) {
    final lower = query.toLowerCase();
    if (lower.contains('dosha') ||
        lower.contains('vata') ||
        lower.contains('pitta') ||
        lower.contains('kapha')) {
      return 'Your AI report shows a predominant **Vata-Pitta** constitution. 🌿\n\n'
          '• **Vata** (Air+Ether): Creative, energetic, but prone to anxiety & dryness\n'
          '• **Pitta** (Fire+Water): Sharp, focused, but prone to inflammation & acidity\n\n'
          'To balance: warm, oily foods; daily Abhyanga (self-massage); avoid cold, raw foods and excessive stress.';
    }
    if (lower.contains('sleep') || lower.contains('insomnia')) {
      return 'For better sleep (Nidra), Ayurveda recommends: 🌙\n\n'
          '1. **Ashwagandha (500mg)** before bed - calms Vata\n'
          '2. **Warm turmeric milk** with nutmeg\n'
          '3. **Abhyanga** - oil massage with Brahmi oil on the scalp\n'
          '4. Sleep before **10 PM** - optimal for Pitta balance\n'
          '5. **Pranayama**: 4-7-8 breathing technique\n\n'
          'Consistency with these practices usually shows results within 2–3 weeks.';
    }
    if (lower.contains('digestion') ||
        lower.contains('stomach') ||
        lower.contains('acidity') ||
        lower.contains('gas')) {
      return 'Ayurvedic tips for digestive health (Agni): 🔥\n\n'
          '1. **Triphala** (1 tsp at night) - comprehensive digestive tonic\n'
          '2. **Ginger + lemon water** before meals\n'
          '3. Eat largest meal at **noon** (peak Pitta/digestive fire)\n'
          '4. **Fennel seeds** after meals\n'
          '5. Avoid cold water during meals\n\n'
          'For acidity specifically: **Shatavari** and **Yashtimadhu** are excellent.';
    }
    if (lower.contains('stress') ||
        lower.contains('anxiety') ||
        lower.contains('mental')) {
      return 'Ayurvedic stress management: 🧘\n\n'
          '**Herbs:**\n'
          '• Ashwagandha - adaptogenic, reduces cortisol\n'
          '• Brahmi - enhances mental clarity & calm\n'
          '• Shatavari - nurtures the nervous system\n\n'
          '**Practices:**\n'
          '• Nasya (nasal oil application) with Brahmi oil\n'
          '• **Surya Namaskar** - 12 rounds at sunrise\n'
          '• **Nadi Shodhana** pranayama - 10 min daily\n'
          '• Shirodhara treatments with an Ayurvedic practitioner';
    }
    if (lower.contains('diet') ||
        lower.contains('food') ||
        lower.contains('eat')) {
      return 'Personalized diet guidance for your Vata-Pitta constitution: 🥗\n\n'
          '**Favor:**\n'
          '• Warm, cooked, slightly oily foods\n'
          '• Sweet, sour, and salty tastes\n'
          '• Ghee, sesame oil, warm milk\n'
          '• Dates, figs, ripe fruits\n\n'
          '**Reduce:**\n'
          '• Raw salads, very spicy foods\n'
          '• Fermented items, alcohol\n'
          '• Cold or frozen foods\n\n'
          'Your diet plan under "Diet & Remedies" has been personalized for you!';
    }
    if (lower.contains('immunity') ||
        lower.contains('cold') ||
        lower.contains('flu')) {
      return 'Boost immunity (Ojas) with Ayurveda: 🌟\n\n'
          '**Chyawanprash** - 1 tsp daily, the gold standard for immunity\n'
          '**Giloy** (Tinospora cordifolia) - powerful immunomodulator\n'
          '**Tulsi** (Holy Basil) - antiviral, antibacterial\n\n'
          '**Daily practices:**\n'
          '• Oil pulling with sesame oil (15 min, morning)\n'
          '• Turmeric milk at bedtime\n'
          '• Avoid late nights and overwork\n'
          '• Sunlight exposure 20–30 min daily (Vitamin D)';
    }
    if (lower.contains('appointment') || lower.contains('doctor')) {
      return 'To book an Ayurvedic consultation, go to the **Appointments** section. 📅\n\n'
          'We have experienced doctors available including:\n'
          '• Dr. Rajesh Sharma (Gastroenterology)\n'
          '• Dr. Priya Nair (Skin & Panchakarma)\n'
          '• Dr. Arjun Mehta (Neuro & Mental Wellness)\n'
          '• Dr. Sunita Rao (Women\'s & Thyroid Health)\n\n'
          'Both online consultations and in-person visits are available!';
    }
    if (lower.contains('report') ||
        lower.contains('upload') ||
        lower.contains('analysis')) {
      return 'To get your AI health analysis: 📊\n\n'
          '1. Go to **Reports** section\n'
          '2. Upload clear photos of your **iris, tongue, nails, and hair**\n'
          '3. Add any blood test reports you have\n'
          '4. Tap "Analyze with AI"\n\n'
          'Our AI analyzes your reports against Ayurvedic parameters to provide:\n'
          '• Dosha imbalance assessment\n'
          '• Health scores across 6 parameters\n'
          '• Personalized recommendations\n'
          '• Customized remedy plan';
    }
    // Default
    return 'Thank you for your question. 🙏\n\n'
        'Based on Ayurvedic principles, I recommend:\n'
        '• Start your day with warm water and lemon\n'
        '• Practice mindful eating\n'
        '• 30 minutes of gentle yoga or walks\n'
        '• 7–8 hours of restful sleep\n\n'
        'Could you share more details about your specific concern? '
        'I can provide more targeted Ayurvedic guidance for your constitution!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  const Icon(Icons.eco_rounded, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ayu AI Assistant',
                    style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                          color: Color(0xFF69F0AE), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Text('Online',
                        style: GoogleFonts.nunito(
                            fontSize: 11, color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary))
                : ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (_isTyping && i == _messages.length) {
                        return const _TypingBubble();
                      }
                      return _MessageBubble(message: _messages[i]);
                    },
                  ),
          ),
          _QuickSuggestions(onTap: _sendMessage),
          _InputBar(controller: _inputCtrl, onSend: _sendMessage),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.eco_rounded,
                  size: 14, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14),
                  topRight: const Radius.circular(14),
                  bottomLeft: Radius.circular(isUser ? 14 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 14),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  height: 1.5,
                  color: isUser ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person_rounded,
                  size: 14, color: AppColors.accent),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.eco_rounded,
                size: 14, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
                bottomRight: Radius.circular(14),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: AnimatedBuilder(
              animation: _anim,
              builder: (_, __) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(
                          alpha:
                              ((_anim.value + i * 0.2) % 1.0).clamp(0.3, 1.0),
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickSuggestions extends StatelessWidget {
  final ValueChanged<String> onTap;
  const _QuickSuggestions({required this.onTap});

  static const _suggestions = [
    'My dosha type?',
    'Improve sleep',
    'Digestion tips',
    'Stress relief',
    'Immunity boost',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _suggestions.length,
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => onTap(_suggestions[i]),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.cardGreen,
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
            ),
            child: Text(
              _suggestions[i],
              style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryDark),
            ),
          ),
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSend;
  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 10, 16, MediaQuery.of(context).padding.bottom + 10),
      decoration: BoxDecoration(
        color: context.surface,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -2))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.border),
              ),
              child: TextField(
                controller: controller,
                maxLines: 3,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                style: GoogleFonts.nunito(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Ask Ayu anything about your health...',
                  hintStyle:
                      GoogleFonts.nunito(fontSize: 13, color: context.txtLight),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onSubmitted: onSend,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => onSend(controller.text),
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child:
                  const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  _ChatMessage({required this.text, required this.isUser, required this.time});
}
