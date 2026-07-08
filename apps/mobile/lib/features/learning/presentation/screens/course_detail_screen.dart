import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import 'lesson_player_screen.dart';

class CourseDetailScreen extends ConsumerStatefulWidget {
  final String title;
  final String instructor;
  final String rating;
  final String modulesCount;
  final String duration;
  final String description;
  final Color themeColor;

  const CourseDetailScreen({
    super.key,
    this.title = 'Vedic Meditation & Kriya Awakening',
    this.instructor = 'Ananya Iyer',
    this.rating = '★ 4.98 (1,240 reviews)',
    this.modulesCount = '8 Modules',
    this.duration = '5 Hours Total',
    this.description =
        'Immerse yourself in ancient Vedic Kriya techniques and neuro-somatic breathwork designed to awaken dormant prana, balance circadian rhythms, and induce profound mental clarity. Includes 432Hz acoustic soundscapes and direct teacher Q&A access.',
    this.themeColor = const Color(0xFF1B5E57),
  });

  @override
  ConsumerState<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends ConsumerState<CourseDetailScreen> {
  int _selectedTabIndex = 0;

  final List<Map<String, String>> _modules = [
    {
      'number': '01',
      'title': 'Foundations of Vedic Prana & Vagus Nerve',
      'duration': '38 mins',
      'type': 'Video + Breathwork Audio',
      'status': 'Completed',
    },
    {
      'number': '02',
      'title': 'Somatic Unwinding & Fascial Release',
      'duration': '45 mins',
      'type': 'Guided Practice',
      'status': 'In Progress',
    },
    {
      'number': '03',
      'title': '432Hz Acoustic Sound Bath & Chakra Tuning',
      'duration': '52 mins',
      'type': 'Immersion Audio',
      'status': 'Locked',
    },
    {
      'number': '04',
      'title': 'Ayurvedic Circadian Alignment & Sleep Rituals',
      'duration': '40 mins',
      'type': 'Masterclass Lecture',
      'status': 'Locked',
    },
    {
      'number': '05',
      'title': 'Advanced Kriya Meditation & Stillness',
      'duration': '60 mins',
      'type': 'Guided Meditation',
      'status': 'Locked',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0C120F) : const Color(0xFFF4F7F5);
    final cardBg = isDark ? const Color(0xFF161F1A) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildHeroAppBar(isDark),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCourseHeader(isDark),
                      const SizedBox(height: 24),
                      _buildStatsRow(isDark, cardBg),
                      const SizedBox(height: 28),
                      _buildInstructorCard(isDark, cardBg),
                      const SizedBox(height: 28),
                      _buildTabButtons(isDark),
                      const SizedBox(height: 20),
                      if (_selectedTabIndex == 0)
                        _buildModulesList(isDark, cardBg)
                      else if (_selectedTabIndex == 1)
                        _buildAboutSection(isDark, cardBg)
                      else
                        _buildReviewsSection(isDark, cardBg),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildFloatingBottomBar(isDark, cardBg),
        ],
      ),
    );
  }

  Widget _buildHeroAppBar(bool isDark) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: widget.themeColor,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bookmark_border_rounded, color: Colors.white, size: 20),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Course bookmarked to your Sanctuary profile.', style: TextStyle(fontFamily: 'Outfit')),
                backgroundColor: AppTheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        const SizedBox(width: 12),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.themeColor,
                    widget.themeColor.withValues(alpha: 0.7),
                    const Color(0xFF0C120F),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -30,
              top: 40,
              child: Icon(
                Icons.self_improvement_rounded,
                size: 240,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 24,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.secondary.withValues(alpha: 0.5)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.graphic_eq_rounded, color: AppTheme.secondary, size: 14),
                        SizedBox(width: 6),
                        Text(
                          '432Hz ACOUSTIC MASTERCLASS',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.secondary,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF161F1A),
            letterSpacing: -0.6,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: AppTheme.secondary, size: 20),
            const SizedBox(width: 6),
            Text(
              widget.rating,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
            ),
            const SizedBox(width: 16),
            Text(
              'Certified Vedic Lineage',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppTheme.primary.withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow(bool isDark, Color cardBg) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.library_books_rounded, widget.modulesCount, 'Syllabus', isDark),
          _buildDivider(),
          _buildStatItem(Icons.timer_rounded, widget.duration, 'Total Pace', isDark),
          _buildDivider(),
          _buildStatItem(Icons.all_inclusive_rounded, 'Lifetime', 'Access', isDark),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, bool isDark) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.secondary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withValues(alpha: 0.1),
    );
  }

  Widget _buildInstructorCard(bool isDark, Color cardBg) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1B5E57).withValues(alpha: 0.2), cardBg]
              : [const Color(0xFFE8F3EE), cardBg],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppTheme.primary,
            child: Text(
              widget.instructor[0],
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guided by ${widget.instructor}',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Senior Vedic Kriya Master & Somatic Researcher',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppTheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButtons(bool isDark) {
    final tabs = ['Syllabus', 'About Course', 'Student Reviews'];
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
                  fontSize: 14,
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

  Widget _buildModulesList(bool isDark, Color cardBg) {
    return Column(
      children: _modules.map((mod) {
        final isCompleted = mod['status'] == 'Completed';
        final isInProgress = mod['status'] == 'In Progress';

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isInProgress
                  ? AppTheme.secondary
                  : Colors.white.withValues(alpha: 0.08),
              width: isInProgress ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppTheme.primary.withValues(alpha: 0.2)
                      : (isInProgress
                          ? AppTheme.secondary.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.05)),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: isCompleted
                    ? const Icon(Icons.check_rounded, color: AppTheme.primary, size: 24)
                    : Text(
                        mod['number']!,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isInProgress ? AppTheme.secondary : Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mod['title']!,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${mod['duration']} • ${mod['type']}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                isInProgress ? Icons.play_circle_fill_rounded : Icons.lock_outline_rounded,
                color: isInProgress ? AppTheme.secondary : Colors.grey,
                size: 28,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAboutSection(bool isDark, Color cardBg) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Immersion Philosophy',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            widget.description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              color: isDark ? Colors.white70 : Colors.black87,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'What You Will Master:',
            style: TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _buildBulletPoint('Vagus nerve stimulation via 4-7-8 and Kumbhaka retention.'),
          _buildBulletPoint('Circadian rhythm resetting using morning sunlight & breath syncing.'),
          _buildBulletPoint('Somatic trauma release through myofascial unwinding postures.'),
          _buildBulletPoint('Deep meditative stillness supported by 432Hz binaural frequencies.'),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: AppTheme.secondary, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(bool isDark, Color cardBg) {
    final reviews = [
      {
        'name': 'Elena Rostova',
        'time': '2 days ago',
        'rating': '★★★★★',
        'text': 'The 432Hz sound bath in Module 3 completely released tension I had been holding in my chest for years. Transformative practice.',
      },
      {
        'name': 'Marcus Vance',
        'time': '1 week ago',
        'rating': '★★★★★',
        'text': 'Ananya explains the neuroscience of pranayama so clearly. My HRV increased by 18 ms within just 5 days of following this routine.',
      },
    ];

    return Column(
      children: reviews.map((rev) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    rev['name']!,
                    style: const TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(rev['rating']!, style: const TextStyle(color: AppTheme.secondary, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 4),
              Text(rev['time']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 12),
              Text(
                rev['text']!,
                style: const TextStyle(fontFamily: 'Inter', fontSize: 14, height: 1.5),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFloatingBottomBar(bool isDark, Color cardBg) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: cardBg.withValues(alpha: 0.95),
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Total Immersion',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  'Included in Sanctuary',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LessonPlayerScreen(
                        lessonTitle: 'Foundations of Vedic Prana & Vagus Nerve',
                        instructorName: 'Ananya Iyer',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 8,
                  shadowColor: AppTheme.primary.withValues(alpha: 0.5),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow_rounded, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Start Immersion',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
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
