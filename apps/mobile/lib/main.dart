// ==============================================================================
// Yoga24X AI Engineering OS — Flutter Mobile Super App Main Entrypoint
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/auth.dart';
import 'features/wellness/presentation/screens/dashboard/wellness_dashboard_screen.dart';
import 'features/wellness/presentation/screens/luxury_home_experience.dart';
import 'features/learning/presentation/screens/course_catalog_screen.dart';
import 'features/learning/presentation/screens/course_detail_screen.dart';
import 'features/learning/presentation/screens/lesson_player_screen.dart';
import 'features/learning/presentation/screens/live_event_browser_screen.dart';
import 'features/learning/presentation/screens/teacher_publishing_dashboard.dart';
import 'features/learning/presentation/screens/quiz_engine_screen.dart';
import 'features/learning/presentation/screens/certificate_view_screen.dart';
import 'features/learning/presentation/screens/student_progress_dashboard.dart';
import 'features/booking/presentation/screens/unified_calendar_screen.dart';
import 'features/booking/presentation/screens/booking_flow_screen.dart';
import 'features/booking/presentation/screens/booking_history_screen.dart';
import 'features/booking/presentation/screens/attendance_scanner_screen.dart';
import 'features/booking/presentation/screens/waitlist_manager_screen.dart';
import 'features/booking/presentation/screens/reschedule_flow_screen.dart';
import 'features/booking/presentation/screens/cancellation_flow_screen.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: Yoga24XApp(),
    ),
  );
}

class Yoga24XApp extends ConsumerStatefulWidget {
  const Yoga24XApp({super.key});

  @override
  ConsumerState<Yoga24XApp> createState() => _Yoga24XAppState();
}

class _Yoga24XAppState extends ConsumerState<Yoga24XApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(authStateNotifierProvider.notifier).checkAuthentication();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateNotifierProvider);

    return MaterialApp(
      title: 'Yoga24X — AI Yoga & Wellness Super App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: _buildHome(authState),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/auth/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/auth/register':
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
          case '/auth/otp-verify':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return MaterialPageRoute(
              builder: (_) => OtpVerificationScreen(
                identifier: args['identifier'] as String? ?? '',
                purpose: args['purpose'] as String? ?? 'LOGIN_OTP',
              ),
            );
          case '/auth/biometric-setup':
            return MaterialPageRoute(builder: (_) => const BiometricSetupScreen());
          case '/auth/active-sessions':
            return MaterialPageRoute(builder: (_) => const ActiveSessionsScreen());
          case '/home':
            return MaterialPageRoute(builder: (_) => const SuperAppMainShell());
          case '/wellness':
            return MaterialPageRoute(builder: (_) => const WellnessDashboardScreen());
          case '/learning/courses':
            return MaterialPageRoute(builder: (_) => const CourseCatalogScreen());
          case '/learning/course-detail':
            return MaterialPageRoute(builder: (_) => const CourseDetailScreen());
          case '/learning/lesson':
            return MaterialPageRoute(builder: (_) => const LessonPlayerScreen());
          case '/learning/events':
            return MaterialPageRoute(builder: (_) => const LiveEventBrowserScreen());
          case '/learning/publishing':
            return MaterialPageRoute(builder: (_) => const TeacherPublishingDashboard());
          case '/learning/quiz':
            return MaterialPageRoute(builder: (_) => const QuizEngineScreen());
          case '/learning/certificate':
            return MaterialPageRoute(builder: (_) => const CertificateViewScreen());
          case '/learning/progress':
            return MaterialPageRoute(builder: (_) => const StudentProgressDashboard());
          // ── Booking & Scheduling Routes (Prompt 7) ─────────────────────────
          case '/booking/calendar':
            return MaterialPageRoute(builder: (_) => const UnifiedCalendarScreen());
          case '/booking/flow':
            return MaterialPageRoute(
                builder: (_) => const BookingFlowScreen());
          case '/booking/history':
            return MaterialPageRoute(builder: (_) => const BookingHistoryScreen());
          case '/booking/waitlist':
            return MaterialPageRoute(builder: (_) => const WaitlistManagerScreen());
          case '/booking/reschedule':
            final bookingId = settings.arguments as String? ?? '';
            return MaterialPageRoute(
                builder: (_) => RescheduleFlowScreen(bookingId: bookingId));
          case '/booking/cancel':
            final bookingId = settings.arguments as String? ?? '';
            return MaterialPageRoute(
                builder: (_) => CancellationFlowScreen(bookingId: bookingId));
          case '/booking/check-in':
            final bookingId = settings.arguments as String? ?? '';
            return MaterialPageRoute(
                builder: (_) => AttendanceScannerScreen(bookingId: bookingId));
          default:
            return null;
        }
      },
    );
  }

  Widget _buildHome(AuthState authState) {
    if (authState.status == AuthStatus.loading || authState.status == AuthStatus.initial) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (authState.status == AuthStatus.authenticated && authState.user != null) {
      return const SuperAppMainShell();
    } else {
      return const LoginScreen();
    }
  }
}

class MockHomeScreen extends StatelessWidget {
  const MockHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SuperAppMainShell();
  }
}

class SuperAppMainShell extends ConsumerStatefulWidget {
  const SuperAppMainShell({super.key});

  @override
  ConsumerState<SuperAppMainShell> createState() => _SuperAppMainShellState();
}

class _SuperAppMainShellState extends ConsumerState<SuperAppMainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateNotifierProvider).user;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final pages = [
      const LuxuryHomeExperienceScreen(),
      const WellnessDashboardScreen(),
      const UnifiedCalendarScreen(),
      const CourseCatalogScreen(),
      _buildProfileTab(context, ref, user, theme, isDark),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
          border: Border(
            top: BorderSide(
              color: isDark ? AppTheme.borderDark : Colors.black.withValues(alpha: 0.05),
              width: 1.0,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 25,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: isDark ? AppTheme.secondary : AppTheme.primary,
          unselectedItemColor: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
          selectedLabelStyle: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w700, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w500, fontSize: 11),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.self_improvement_outlined),
              activeIcon: Icon(Icons.self_improvement),
              label: 'Today',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Wellness',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school),
              label: 'Academy',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context, WidgetRef ref, AuthUser? user, ThemeData theme, bool isDark) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account & Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      (user?.firstName.isNotEmpty == true ? user!.firstName[0] : 'Y').toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user?.firstName ?? "Yoga"} ${user?.lastName ?? "Warrior"}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(user?.email ?? 'warrior@yoga24x.com', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          children: (user?.roles ?? [UserRole.student]).map((r) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                              child: Text(r.name.toUpperCase(), style: TextStyle(color: theme.colorScheme.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.security, color: Colors.blue),
              title: const Text('Active Sessions & Devices', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Manage signed-in devices & tokens'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () => Navigator.pushNamed(context, '/auth/active-sessions'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.fingerprint, color: Colors.teal),
              title: const Text('Biometric Passkey Setup', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Touch ID / Face ID quick login'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () => Navigator.pushNamed(context, '/auth/biometric-setup'),
            ),
            const Divider(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out of Ecosystem'),
                onPressed: () {
                  ref.read(authStateNotifierProvider.notifier).logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
