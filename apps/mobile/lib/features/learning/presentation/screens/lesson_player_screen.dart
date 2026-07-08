import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class LessonPlayerScreen extends ConsumerStatefulWidget {
  final String lessonTitle;
  final String instructorName;
  final String duration;

  const LessonPlayerScreen({
    super.key,
    this.lessonTitle = 'Foundations of Vedic Prana & Vagus Nerve',
    this.instructorName = 'Ananya Iyer',
    this.duration = '38:00',
  });

  @override
  ConsumerState<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends ConsumerState<LessonPlayerScreen> {
  bool _isPlaying = true;
  bool _is432HzEnabled = true;
  final double _progress = 0.35; // 35% through lesson
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0C120F) : const Color(0xFFF4F7F5);
    final cardBg = isDark ? const Color(0xFF161F1A) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sanctuary Immersion Player',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lesson link copied to clipboard!', style: TextStyle(fontFamily: 'Outfit')),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVideoPlayerSimulator(isDark),
            const SizedBox(height: 24),
            _buildLessonTitleSection(isDark),
            const SizedBox(height: 24),
            _build432HzTuningCard(isDark, cardBg),
            const SizedBox(height: 28),
            _buildTabNav(isDark),
            const SizedBox(height: 20),
            if (_selectedTabIndex == 0)
              _buildSomaticNotesTab(isDark, cardBg)
            else if (_selectedTabIndex == 1)
              _buildCommunityQnATab(isDark, cardBg)
            else
              _buildResourcesTab(isDark, cardBg),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayerSimulator(bool isDark) {
    return Container(
      width: double.infinity,
      height: 230,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1B5E57),
            const Color(0xFF0C120F).withValues(alpha: 0.9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E57).withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(color: AppTheme.secondary.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Simulated Waveform / Prana Rings
          const Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Icon(
                Icons.self_improvement_rounded,
                size: 180,
                color: AppTheme.secondary,
              ),
            ),
          ),
          // Play/Pause Floating Button
          GestureDetector(
            onTap: () => setState(() => _isPlaying = !_isPlaying),
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.secondary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.secondary.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: const Color(0xFF0C120F),
                size: 38,
              ),
            ),
          ),
          // Top Badges
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: const Row(
                children: [
                  Icon(Icons.circle, color: Colors.redAccent, size: 8),
                  SizedBox(width: 6),
                  Text(
                    'HD VIDEO + ACOUSTIC AUDIO',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Scrub Bar & Time
          Positioned(
            left: 20,
            right: 20,
            bottom: 16,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '13:18',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.white),
                    ),
                    Text(
                      widget.duration,
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.secondary),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonTitleSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.lessonTitle,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: AppTheme.primary,
              child: Text(
                widget.instructorName[0],
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Guided by ${widget.instructorName}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Module 1 of 8',
                style: TextStyle(fontFamily: 'Outfit', fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _build432HzTuningCard(bool isDark, Color cardBg) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _is432HzEnabled ? AppTheme.secondary : Colors.white.withValues(alpha: 0.08),
          width: _is432HzEnabled ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.graphic_eq_rounded, color: AppTheme.secondary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '432Hz Binaural Acoustic Tuning',
                  style: TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  _is432HzEnabled
                      ? 'Harmonic resonance active. Optimizing vagal tone.'
                      : 'Standard audio mode active.',
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Switch(
            value: _is432HzEnabled,
            activeThumbColor: AppTheme.secondary,
            onChanged: (val) => setState(() => _is432HzEnabled = val),
          ),
        ],
      ),
    );
  }

  Widget _buildTabNav(bool isDark) {
    final tabs = ['Somatic Guide', 'Student Q&A (24)', 'Downloads (3)'];
    return Row(
      children: List.generate(tabs.length, (index) {
        final isSelected = _selectedTabIndex == index;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = index),
            child: Container(
              margin: EdgeInsets.only(right: index < tabs.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primary
                    : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05)),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                tabs[index],
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSomaticNotesTab(bool isDark, Color cardBg) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lesson Somatic Protocol',
            style: TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          const Text(
            'In this foundational lesson, we explore the physiological link between conscious pranayama and parasympathetic nervous system dominance. When you extend your exhalation to twice the duration of your inhalation, you stimulate the acetylcholine receptors along the vagus nerve.',
            style: TextStyle(fontFamily: 'Inter', fontSize: 14, height: 1.6, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 Key Practice Cadence (4-7-8 Rhythm):',
                  style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.primary),
                ),
                SizedBox(height: 8),
                Text('• Inhale quietly through the nose for 4 seconds.\n• Hold breath gently (Kumbhaka) for 7 seconds.\n• Exhale audibly through pursed lips for 8 seconds.',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 13, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityQnATab(bool isDark, Color cardBg) {
    final qna = [
      {
        'user': 'Siddharth Rao',
        'time': '3 hours ago',
        'question': 'During the 7-second breath hold, should I engage Mula Bandha (root lock)?',
        'answer': 'Ananya Iyer (Instructor): Yes, gently engaging Mula Bandha helps direct prana upward along the sushumna nadi without straining the heart.',
      },
      {
        'user': 'Chloe Dupont',
        'time': '1 day ago',
        'question': 'I felt a tingling sensation in my palms during the 432Hz sound bath. Is that normal?',
        'answer': 'Ananya Iyer (Instructor): Completely normal, Chloe! That is somatic fascial unwinding and increased micro-circulation.',
      },
    ];

    return Column(
      children: qna.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item['user']!, style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w700)),
                  Text(item['time']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
              Text(item['question']!, style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  item['answer']!,
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 13, height: 1.4, color: AppTheme.secondary),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildResourcesTab(bool isDark, Color cardBg) {
    final resources = [
      {'title': 'Somatic Vagus Nerve Guide (PDF)', 'size': '4.2 MB', 'icon': Icons.picture_as_pdf_rounded},
      {'title': '432Hz Sound Bath Track (MP3)', 'size': '48.5 MB', 'icon': Icons.audiotrack_rounded},
      {'title': 'Ayurvedic Dosha Assessment Sheet', 'size': '1.8 MB', 'icon': Icons.description_rounded},
    ];

    return Column(
      children: resources.map((res) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(18)),
          child: Row(
            children: [
              Icon(res['icon'] as IconData, color: AppTheme.primary, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(res['title'] as String, style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(res['size'] as String, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.download_rounded, color: AppTheme.secondary),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Downloading ${res['title']}...', style: const TextStyle(fontFamily: 'Outfit')),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
