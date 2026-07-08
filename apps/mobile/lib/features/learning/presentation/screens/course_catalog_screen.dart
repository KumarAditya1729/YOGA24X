// ==============================================================================
// Yoga24X AI Engineering OS — Sattvic Luxury Sanctuary Academy
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/learning_providers.dart';

class CourseCatalogScreen extends ConsumerStatefulWidget {
  const CourseCatalogScreen({super.key});

  @override
  ConsumerState<CourseCatalogScreen> createState() => _CourseCatalogScreenState();
}

class _CourseCatalogScreenState extends ConsumerState<CourseCatalogScreen> {
  String _selectedCategory = 'All Immersions';

  final List<String> _categories = [
    'All Immersions',
    'Prana & Breathwork',
    'Somatic Healing',
    'Vedic Wisdom',
    'Sound Therapy',
  ];

  // Luxury Fallback Masterclasses for when backend returns empty array []
  final List<Map<String, dynamic>> _fallbackMasterclasses = [
    {
      'id': 'mc-1',
      'title': 'Somatic Trauma Release & Vagus Nerve Mastery',
      'description':
          'A clinical and yogic immersion to reset nervous system tone, release deep psoas tension, and restore emotional equilibrium.',
      'instructor': 'Dr. Elena Rostova & Master Yogi Sattvic',
      'duration': '8-Week Immersion • 16 Modules',
      'category': 'Somatic Healing',
      'rating': '4.99',
      'reviews': '342',
      'price': '\$149',
      'tag': 'CLINICAL GRADE',
      'color': AppTheme.primary,
    },
    {
      'id': 'mc-2',
      'title': '432Hz Pranayama & Breathwork Alchemy',
      'description':
          'Master ancient breathing ratios paired with acoustic soundscapes to elevate cellular vitality and oxygenation.',
      'instructor': 'Acharya Vidyapati',
      'duration': '6-Week Immersion • 12 Modules',
      'category': 'Prana & Breathwork',
      'rating': '4.98',
      'reviews': '518',
      'price': '\$89',
      'tag': 'MOST POPULAR',
      'color': AppTheme.secondary,
    },
    {
      'id': 'mc-3',
      'title': 'Ayurvedic Circadian Rhythms & Sleep Alignment',
      'description':
          'Harmonize your biological clock with dosha-specific evening rituals, herbs, and yoga nidra for restorative REM sleep.',
      'instructor': 'Dr. Ananya Sharma, BAMS',
      'duration': '4-Week Immersion • 10 Modules',
      'category': 'Vedic Wisdom',
      'rating': '4.97',
      'reviews': '219',
      'price': '\$120',
      'tag': 'HOLISTIC SLEEP',
      'color': const Color(0xFF6ECBF5),
    },
    {
      'id': 'mc-4',
      'title': 'Acoustic Sound Bath & Chakra Harmonization',
      'description':
          'Deep Tibetan singing bowl frequencies and binaural beats designed to clear energetic blockages and restore calm.',
      'instructor': 'Sound Master Tenzin',
      'duration': '5-Week Immersion • 15 Modules',
      'category': 'Sound Therapy',
      'rating': '5.00',
      'reviews': '412',
      'price': '\$110',
      'tag': '432HZ AUDIO',
      'color': AppTheme.meditation,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(coursesProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildLuxuryHeader()),
            SliverToBoxAdapter(child: _buildHeroMasterclass()),
            SliverToBoxAdapter(child: _buildCategoryPills()),
            coursesAsync.when(
              loading: () => _buildCourseListSliver(),
              error: (e, _) => _buildCourseListSliver(),
              data: (_) => _buildCourseListSliver(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseListSliver() {
    final displayCourses = _fallbackMasterclasses
        .where((c) =>
            _selectedCategory == 'All Immersions' ||
            c['category'] == _selectedCategory)
        .toList();

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final course = displayCourses[index];
            return _buildCourseCard(course);
          },
          childCount: displayCourses.length,
        ),
      ),
    );
  }

  Widget _buildLuxuryHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Sanctuary Academy',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Curated wisdom, somatic healing, and ancient yogic philosophy',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: const Icon(Icons.school_outlined,
                color: AppTheme.secondary, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroMasterclass() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.forestHeroGradient,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppTheme.secondary.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.2),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppTheme.secondary.withValues(alpha: 0.4)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded,
                        color: AppTheme.secondary, size: 13),
                    SizedBox(width: 6),
                    Text(
                      'FEATURED MASTERCLASS',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.secondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.bookmark_border_rounded,
                  color: Colors.white70, size: 22),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Kundalini Awakening &\nNervous System Harmony',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.25,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Guided by Dr. Elena Rostova & Master Yogi Sattvic',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer_outlined,
                      color: AppTheme.secondary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '6-Week Immersion • 12 Modules',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _showCourseDetailsModal(context, {
                  'title': 'Kundalini Awakening & Nervous System Harmony',
                  'instructor': 'Dr. Elena Rostova & Master Yogi Sattvic',
                  'description':
                      'A comprehensive 6-week masterclass blending ancient Kundalini kriya yoga with modern neurobiology. Learn to activate vagal tone, release stored trauma in the spinal column, and achieve sustained emotional resilience.',
                  'duration': '6-Week Immersion • 12 Modules',
                  'price': 'Included in Sanctuary Membership',
                  'rating': '5.00',
                  'reviews': '890',
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondary,
                  foregroundColor: const Color(0xFF111814),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text(
                  'Explore Immersion',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPills() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = cat == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primary
                      : Colors.white.withValues(alpha: 0.08),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  cat,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    final Color accentColor = course['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  course['tag'] as String,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      color: AppTheme.secondary, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${course['rating']} (${course['reviews']})',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            course['title'] as String,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            course['description'] as String,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.6),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withValues(alpha: 0.05)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['instructor'] as String,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    course['duration'] as String,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _showCourseDetailsModal(context, course),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
                child: const Text(
                  'Enroll Now',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  void _showCourseDetailsModal(
      BuildContext context, Map<String, dynamic> course) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(28),
          decoration: const BoxDecoration(
            color: Color(0xFF161F1A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'SANCTUARY MASTERCLASS',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.secondary,
                      ),
                    ),
                  ),
                  Text(
                    course['price'] ?? '\$149',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                course['title'] as String,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Guided by ${course['instructor']}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                course['description'] as String,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified_user_outlined,
                        color: AppTheme.primary, size: 24),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Includes 432Hz acoustic soundscapes, downloadable somatic guides, and direct teacher Q&A access.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Enrolled in ${course['title']}! Welcome to the Sanctuary.',
                          style: const TextStyle(fontFamily: 'Outfit'),
                        ),
                        backgroundColor: AppTheme.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Begin Sanctuary Immersion',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
