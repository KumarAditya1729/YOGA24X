// ==============================================================================
// Yoga24X AI Engineering OS — Flutter Mobile Super App Main Entrypoint
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/auth.dart';
import 'features/wellness/presentation/screens/dashboard/wellness_dashboard_screen.dart';
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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD0BCFF),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Inter',
      ),
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
            return MaterialPageRoute(builder: (_) => const MockHomeScreen());
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
      return const MockHomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}

class MockHomeScreen extends ConsumerWidget {
  const MockHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateNotifierProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user?.firstName ?? "Yoga Warrior"}!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.security),
            tooltip: 'Active Sessions',
            onPressed: () => Navigator.pushNamed(context, '/auth/active-sessions'),
          ),
          IconButton(
            icon: const Icon(Icons.fingerprint),
            tooltip: 'Biometric Setup',
            onPressed: () => Navigator.pushNamed(context, '/auth/biometric-setup'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () {
              ref.read(authStateNotifierProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.self_improvement, size: 80, color: Color(0xFF6750A4)),
              const SizedBox(height: 16),
              Text(
                'Yoga24X Super App Dashboard',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Role: ${user?.roles.map((r) => r.name.toUpperCase()).join(", ") ?? "STUDENT"}',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.security),
                label: const Text('Manage Active Sessions & Devices'),
                onPressed: () => Navigator.pushNamed(context, '/auth/active-sessions'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.favorite, color: Colors.red),
                label: const Text('Open Wellness & Health Hub'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.pushNamed(context, '/wellness'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
