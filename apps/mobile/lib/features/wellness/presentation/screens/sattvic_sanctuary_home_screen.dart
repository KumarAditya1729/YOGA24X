// ==============================================================================
// Yoga24X AI Engineering OS — 2026 Luxury Sattvic Sanctuary Home Experience
// Embodying Alo Moves, WHOOP, Calm, Apple Fitness+ & Superhuman Aesthetics
// ==============================================================================

import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/auth.dart';
import '../../../../features/learning/presentation/screens/course_detail_screen.dart';
import '../../../../features/learning/presentation/screens/lesson_player_screen.dart';

class SattvicSanctuaryHomeScreen extends ConsumerStatefulWidget {
  const SattvicSanctuaryHomeScreen({super.key});

  @override
  ConsumerState<SattvicSanctuaryHomeScreen> createState() => _SattvicSanctuaryHomeScreenState();
}

class _SattvicSanctuaryHomeScreenState extends ConsumerState<SattvicSanctuaryHomeScreen>
    with TickerProviderStateMixin {
  int _selectedTab = 0;
  late AnimationController _ambientController;
  late AnimationController _ringController;
  bool _isPlayingAudio = false;

  final List<String> _sanctuaryTabs = [
    '☀️ Today\'s Sanctuary',
    '📊 Biometric Telemetry',
    '🧘 Studio Academy',
    '🌙 Vedic Sleep & Rest',
  ];

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
  }

  @override
  void dispose() {
    _ambientController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  String _getTimeOfDayGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Peaceful Morning';
    if (hour < 17) return 'Serene Afternoon';
    return 'Tranquil Evening';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateNotifierProvider);
    final user = authState.user;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF090D0B) : const Color(0xFFF7F9F8),
      body: Stack(
        children: [
          // ── 1. Ambient Glowing Spheres (Visual Exhale Background) ─────────
          _buildAmbientBackground(isDark),

          // ── 2. Main Sanctuary Content ─────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Header & Greeting
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                  child: _buildSanctuaryHeader(user, theme, isDark),
                ),

                // Horizontal Progressive Disclosure Pills
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildSanctuaryTabPills(isDark),
                ),

                // Animated Tab Content Area
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: _buildActiveTabContent(isDark, theme),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Ambient Glass Background ──────────────────────────────────────────────
  Widget _buildAmbientBackground(bool isDark) {
    return AnimatedBuilder(
      animation: _ambientController,
      builder: (context, child) {
        final shift = math.sin(_ambientController.value * math.pi * 2) * 20;
        return Stack(
          children: [
            // Top Right Organic Sage Glow
            Positioned(
              top: -60 + shift,
              right: -60 - shift,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      isDark
                          ? const Color(0xFF385E4D).withValues(alpha: 0.38)
                          : const Color(0xFF385E4D).withValues(alpha: 0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Left Sanctuary Gold Glow
            Positioned(
              bottom: 40 - shift,
              left: -80 + shift,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      isDark
                          ? const Color(0xFFC5A059).withValues(alpha: 0.25)
                          : const Color(0xFFC5A059).withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Middle Right Forest Glow
            Positioned(
              top: 300,
              right: -100,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      isDark
                          ? const Color(0xFF1B5E57).withValues(alpha: 0.22)
                          : const Color(0xFF1B5E57).withValues(alpha: 0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Header & Greeting ─────────────────────────────────────────────────────
  Widget _buildSanctuaryHeader(AuthUser? user, ThemeData theme, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getTimeOfDayGreeting(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.6,
                color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              user?.firstName ?? 'Aditya',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.6,
                color: isDark ? Colors.white : const Color(0xFF1B2C24),
              ),
            ),
          ],
        ),
        // Sanctuary Status Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.12) : const Color(0xFF385E4D).withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF4ADE80),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Sattvic • Day 7',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1B2C24),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Horizontal Sanctuary Selector Pills ───────────────────────────────────
  Widget _buildSanctuaryTabPills(bool isDark) {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _sanctuaryTabs.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedTab == index;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedTab = index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? const Color(0xFF385E4D) : const Color(0xFF1B5E57))
                    : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.7)),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFC5A059)
                      : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06)),
                  width: isSelected ? 1.5 : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF385E4D).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: Text(
                _sanctuaryTabs[index],
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppTheme.textSecondaryDark : const Color(0xFF4A6B5B)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Active Tab Switcher ───────────────────────────────────────────────────
  Widget _buildActiveTabContent(bool isDark, ThemeData theme) {
    switch (_selectedTab) {
      case 0:
        return _buildTodaysSanctuaryTab(isDark, theme, key: const ValueKey(0));
      case 1:
        return _buildBiometricTelemetryTab(isDark, theme, key: const ValueKey(1));
      case 2:
        return _buildStudioAcademyTab(isDark, theme, key: const ValueKey(2));
      case 3:
        return _buildVedicSleepTab(isDark, theme, key: const ValueKey(3));
      default:
        return const SizedBox.shrink();
    }
  }

  // ==========================================================================
  // TAB 0: TODAY'S SANCTUARY (Whoop Ring + Cinematic Hero + 432Hz Audio)
  // ==========================================================================
  Widget _buildTodaysSanctuaryTab(bool isDark, ThemeData theme, {Key? key}) {
    return SingleChildScrollView(
      key: key,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Whoop / Apple Fitness+ Prana Readiness Card ─────────────────
          _buildGlassCard(
            isDark: isDark,
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                // Custom Glowing Biometric Ring
                SizedBox(
                  width: 110,
                  height: 110,
                  child: AnimatedBuilder(
                    animation: _ringController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _BiometricRingPainter(
                          progress: 0.94 * _ringController.value,
                          ringColor: const Color(0xFF4ADE80),
                          trackColor: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.08),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${(94 * _ringController.value).toInt()}%',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : const Color(0xFF1B2C24),
                                ),
                              ),
                              Text(
                                'PRANA',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.0,
                                  color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 22),
                // Telemetry Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ADE80).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'OPTIMAL RECOVERY',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your nervous system is in deep harmony. Ideal for vigorous Vinyasa or Kundalini practice.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          height: 1.4,
                          color: isDark ? AppTheme.textSecondaryDark : const Color(0xFF4A6B5B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMiniMetric('HRV', '88 ms', const Color(0xFF60A5FA), isDark),
                          _buildMiniMetric('RHR', '54 bpm', const Color(0xFFF43F5E), isDark),
                          _buildMiniMetric('DOSHA', 'Vata-Pitta', const Color(0xFFC5A059), isDark),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Cinematic Masterclass Hero Card (Alo Moves Style) ───────────
          Text(
            'TODAY\'S FEATURED IMMERSION',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: isDark ? AppTheme.textSecondaryDark : const Color(0xFF6B8A7A),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LessonPlayerScreen(),
                ),
              );
            },
            child: Container(
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1B5E57).withValues(alpha: 0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image / Gradient
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xFF1B5E57),
                            Color(0xFF0D2824),
                          ],
                        ),
                      ),
                    ),
                    // Ambient Light Overlay
                    Positioned(
                      top: -40,
                      right: -40,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFC5A059).withValues(alpha: 0.25),
                        ),
                      ),
                    ),
                    // Content Overlay
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.headphones, color: Color(0xFFC5A059), size: 14),
                                    SizedBox(width: 6),
                                    Text(
                                      '432Hz SOUNDSCAPE',
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '45 MIN • MASTERCLASS',
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kundalini Awakening &\nNervous System Harmony',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Guided by Dr. Elena Rostova • ★ 4.99 (1,420 Mastered)',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Begin Immersion Pill Button
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC5A059),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFC5A059).withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Begin Immersion',
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0D1B16),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.play_arrow_rounded, color: Color(0xFF0D1B16), size: 18),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Interactive 432Hz Soundscape Player ─────────────────────────
          _buildGlassCard(
            isDark: isDark,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _isPlayingAudio = !_isPlayingAudio),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF385E4D) : const Color(0xFF1B5E57),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF385E4D).withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isPlayingAudio ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chandra Bhedana Soundscape',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF1B2C24),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC5A059).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '432 Hz',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFC5A059),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isPlayingAudio ? 'Playing • Vagus Nerve Harmonics' : 'Paused • Tap to restore calm',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: isDark ? AppTheme.textSecondaryDark : const Color(0xFF6B8A7A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 1: BIOMETRIC TELEMETRY (Whoop / Oura Style Deep Dive)
  // ==========================================================================
  Widget _buildBiometricTelemetryTab(bool isDark, ThemeData theme, {Key? key}) {
    return SingleChildScrollView(
      key: key,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Telemetry Overview Hero
          _buildGlassCard(
            isDark: isDark,
            padding: const EdgeInsets.all(26),
            child: Column(
              children: [
                const Text(
                  'NERVOUS SYSTEM BIOMETRICS',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: Color(0xFFC5A059),
                  ),
                ),
                const SizedBox(height: 24),
                // Triple Concentric Rings Representation
                SizedBox(
                  height: 180,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer Ring: Prana Recovery (94%)
                      SizedBox(
                        width: 170,
                        height: 170,
                        child: CustomPaint(
                          painter: _BiometricRingPainter(
                            progress: 0.94,
                            ringColor: const Color(0xFF4ADE80),
                            trackColor: isDark ? Colors.white10 : Colors.black12,
                            strokeWidth: 10,
                          ),
                        ),
                      ),
                      // Middle Ring: HRV Readiness (88%)
                      SizedBox(
                        width: 130,
                        height: 130,
                        child: CustomPaint(
                          painter: _BiometricRingPainter(
                            progress: 0.88,
                            ringColor: const Color(0xFF60A5FA),
                            trackColor: isDark ? Colors.white10 : Colors.black12,
                            strokeWidth: 10,
                          ),
                        ),
                      ),
                      // Inner Ring: Ayurvedic Balance (78%)
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: CustomPaint(
                          painter: _BiometricRingPainter(
                            progress: 0.78,
                            ringColor: const Color(0xFFC5A059),
                            trackColor: isDark ? Colors.white10 : Colors.black12,
                            strokeWidth: 10,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '94%',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF1B2C24),
                            ),
                          ),
                          const Text(
                            'OVERALL',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLegendItem('Recovery', const Color(0xFF4ADE80), '94%'),
                    _buildLegendItem('HRV Readiness', const Color(0xFF60A5FA), '88 ms'),
                    _buildLegendItem('Dosha Balance', const Color(0xFFC5A059), '78%'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // HRV Trend Analysis
          _buildGlassCard(
            isDark: isDark,
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '7-DAY HRV VARIABILITY',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: isDark ? Colors.white : const Color(0xFF1B2C24),
                      ),
                    ),
                    const Icon(Icons.show_chart_rounded, color: Color(0xFF60A5FA), size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Your parasympathetic nervous system is thriving. Average nightly HRV increased by +12ms this week.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    height: 1.4,
                    color: isDark ? AppTheme.textSecondaryDark : const Color(0xFF4A6B5B),
                  ),
                ),
                const SizedBox(height: 16),
                // Simulated Bar Chart
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBarDay('Mon', 0.65, isDark),
                    _buildBarDay('Tue', 0.70, isDark),
                    _buildBarDay('Wed', 0.60, isDark),
                    _buildBarDay('Thu', 0.82, isDark),
                    _buildBarDay('Fri', 0.88, isDark),
                    _buildBarDay('Sat', 0.92, isDark),
                    _buildBarDay('Sun', 0.94, isDark, isToday: true),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 2: STUDIO ACADEMY (Alo Moves Style)
  // ==========================================================================
  Widget _buildStudioAcademyTab(bool isDark, ThemeData theme, {Key? key}) {
    return SingleChildScrollView(
      key: key,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURATED MASTERCLASS SERIES',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: isDark ? AppTheme.textSecondaryDark : const Color(0xFF6B8A7A),
            ),
          ),
          const SizedBox(height: 14),
          _buildAcademyCourseCard(
            title: 'Somatic Healing & Vagus Nerve Mastery',
            teacher: 'Master Rajesh Sharma',
            rating: '★ 4.99',
            modules: '6 Modules • 3.5 Hours',
            badge: '432Hz SOUND',
            color: const Color(0xFF1B5E57),
            isDark: isDark,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CourseDetailScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildAcademyCourseCard(
            title: 'Vedic Meditation & Kriya Awakening',
            teacher: 'Ananya Iyer',
            rating: '★ 4.98',
            modules: '8 Modules • 5 Hours',
            badge: 'SANCTUARY EXCLUSIVE',
            color: const Color(0xFF385E4D),
            isDark: isDark,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CourseDetailScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 3: VEDIC SLEEP & REST (Calm Style)
  // ==========================================================================
  Widget _buildVedicSleepTab(bool isDark, ThemeData theme, {Key? key}) {
    return SingleChildScrollView(
      key: key,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGlassCard(
            isDark: isDark,
            padding: const EdgeInsets.all(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.nightlight_round, color: Color(0xFFC5A059), size: 22),
                    SizedBox(width: 10),
                    Text(
                      'YOGA NIDRA & SACRED REST',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Color(0xFFC5A059),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Experience conscious deep sleep. 30 minutes of Yoga Nidra is equivalent to 3 hours of restorative delta-wave sleep.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    height: 1.5,
                    color: isDark ? AppTheme.textSecondaryDark : const Color(0xFF4A6B5B),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black26 : Colors.white60,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Celestial Delta Waves',
                            style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 4),
                          Text('60 Min • Sleep Timer Enabled', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                      Icon(Icons.play_circle_fill_rounded, color: Color(0xFFC5A059), size: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ── Reusable Glassmorphic Card Helper ─────────────────────────────────────
  Widget _buildGlassCard({
    required bool isDark,
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding ?? const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF141F1A).withValues(alpha: 0.75)
                : Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : const Color(0xFF385E4D).withValues(alpha: 0.12),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  // ── Mini Metric Badge Helper ──────────────────────────────────────────────
  Widget _buildMiniMetric(String label, String value, Color color, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isDark ? AppTheme.textSecondaryDark : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  // ── Legend Item Helper ────────────────────────────────────────────────────
  Widget _buildLegendItem(String label, Color color, String value) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            Text(value, style: const TextStyle(fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }

  // ── Simulated Bar Chart Day Helper ────────────────────────────────────────
  Widget _buildBarDay(String day, double heightRatio, bool isDark, {bool isToday = false}) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 80 * heightRatio,
          decoration: BoxDecoration(
            color: isToday
                ? const Color(0xFF4ADE80)
                : (isDark ? Colors.white.withValues(alpha: 0.15) : const Color(0xFF385E4D).withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 11,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            color: isToday ? const Color(0xFF4ADE80) : Colors.grey,
          ),
        ),
      ],
    );
  }

  // ── Academy Course Card Helper ────────────────────────────────────────────
  Widget _buildAcademyCourseCard({
    required String title,
    required String teacher,
    required String rating,
    required String modules,
    required String badge,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: _buildGlassCard(
        isDark: isDark,
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Center(
                child: Icon(Icons.self_improvement, color: Colors.white, size: 32),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC5A059).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(fontFamily: 'Outfit', fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFFC5A059)),
                        ),
                      ),
                      Text(rating, style: const TextStyle(fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFC5A059))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF1B2C24)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$teacher • $modules',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: isDark ? AppTheme.textSecondaryDark : const Color(0xFF6B8A7A)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// ── Biometric Ring Custom Painter (Whoop & Apple Fitness+ Style) ────────────
class _BiometricRingPainter extends CustomPainter {
  final double progress;
  final Color ringColor;
  final Color trackColor;
  final double strokeWidth;

  _BiometricRingPainter({
    required this.progress,
    required this.ringColor,
    required this.trackColor,
    this.strokeWidth = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;

    // Draw Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Draw Active Ring
    final ringPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Glowing shadow for active ring
    final shadowPaint = Paint()
      ..color = ringColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, false, shadowPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, false, ringPaint);
  }

  @override
  bool shouldRepaint(covariant _BiometricRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.ringColor != ringColor;
  }
}
