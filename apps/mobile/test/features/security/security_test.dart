// ==============================================================================
// Yoga24X — Flutter Security Provider & Widget Tests
// Tests: Permission evaluation, Role switching, FeatureFlag gating, AccessDenied screen
// ==============================================================================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/security/presentation/providers/security_providers.dart';
import 'package:mobile/features/security/presentation/widgets/permission_guard_widget.dart';
import 'package:mobile/features/security/presentation/screens/access_denied_screen.dart';
import 'package:mobile/features/security/presentation/screens/security_screens.dart';
import 'package:mobile/features/security/domain/models/security_models.dart';

Widget buildTestApp(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(home: child),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Permission Provider Tests
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  group('PermissionState — Logic Tests', () {
    test('hasPermission returns true for ALLOW permission', () {
      final state = PermissionState(
        status: SecurityStatus.loaded,
        permissions: [
          const Permission(key: 'courses:read', effect: 'ALLOW', state: 'DIRECT'),
        ],
      );
      expect(state.hasPermission('courses:read'), isTrue);
    });

    test('hasPermission returns false for DENY permission', () {
      final state = PermissionState(
        status: SecurityStatus.loaded,
        permissions: [
          const Permission(key: 'courses:grade', effect: 'DENY', state: 'OVERRIDDEN'),
        ],
      );
      expect(state.hasPermission('courses:grade'), isFalse);
    });

    test('hasPermission returns false for expired TEMPORARY permission', () {
      final state = PermissionState(
        status: SecurityStatus.loaded,
        permissions: [
          Permission(
            key: 'security:audit_read',
            effect: 'ALLOW',
            state: 'TEMPORARY',
            expiresAt: DateTime.now().subtract(const Duration(hours: 1)), // Expired
          ),
        ],
      );
      expect(state.hasPermission('security:audit_read'), isFalse);
    });

    test('hasAnyPermission returns true when any permission in list is granted', () {
      final state = PermissionState(
        status: SecurityStatus.loaded,
        permissions: [
          const Permission(key: 'courses:read', effect: 'ALLOW', state: 'INHERITED'),
        ],
      );
      expect(state.hasAnyPermission(['courses:read', 'courses:grade']), isTrue);
    });

    test('hasAllPermissions returns false when one is missing', () {
      final state = PermissionState(
        status: SecurityStatus.loaded,
        permissions: [
          const Permission(key: 'courses:read', effect: 'ALLOW', state: 'INHERITED'),
        ],
      );
      expect(state.hasAllPermissions(['courses:read', 'courses:grade']), isFalse);
    });
  });

  group('RoleState — Logic Tests', () {
    test('isAdmin returns true for STUDIO_OWNER', () {
      final state = RoleState(
        status: SecurityStatus.loaded,
        roles: [const UserRole(id: 'STUDIO_OWNER', name: 'STUDIO_OWNER', isSystemRole: true)],
        activeRole: 'STUDIO_OWNER',
      );
      expect(state.isAdmin, isTrue);
    });

    test('isTeacher returns true for MEDITATION_COACH', () {
      final state = RoleState(
        status: SecurityStatus.loaded,
        roles: [const UserRole(id: 'MEDITATION_COACH', name: 'MEDITATION_COACH', isSystemRole: true)],
        activeRole: 'MEDITATION_COACH',
      );
      expect(state.isTeacher, isTrue);
    });

    test('switchActiveRole only switches to a role the user has', () {
      final notifier = RoleNotifier();
      notifier.seedRoles(['STUDENT', 'TEACHER']);
      notifier.switchActiveRole('TEACHER');
      expect(notifier.state.activeRole, 'TEACHER');
      notifier.switchActiveRole('SUPER_ADMIN'); // Not in roles
      expect(notifier.state.activeRole, 'TEACHER'); // Unchanged
    });
  });

  group('FeatureFlagState — Logic Tests', () {
    test('isEnabled returns true for enabled flag', () {
      final state = FeatureFlagState(
        status: SecurityStatus.loaded,
        flags: {
          'ai_pose_coach': const FeatureFlag(key: 'ai_pose_coach', enabled: true, source: 'tenant'),
        },
      );
      expect(state.isEnabled('ai_pose_coach'), isTrue);
    });

    test('isEnabled returns false for missing flag (safe default)', () {
      const state = FeatureFlagState(status: SecurityStatus.loaded, flags: {});
      expect(state.isEnabled('non_existent_flag'), isFalse);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────────
  // Widget Tests
  // ─────────────────────────────────────────────────────────────────────────────

  group('PermissionGuard Widget Tests', () {
    testWidgets('hides child when user lacks permission (hide mode)', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const PermissionGuard(
          permission: 'security:audit_read',
          child: Text('Admin Content'),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Admin Content'), findsNothing);
    });

    testWidgets('shows child when user has permission', (tester) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [
          permissionProvider.overrideWith((ref) {
            final notifier = PermissionNotifier();
            notifier.seedPermissions([
              {'key': 'courses:read', 'effect': 'ALLOW', 'state': 'INHERITED'},
            ]);
            return notifier;
          }),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: PermissionGuard(
              permission: 'courses:read',
              child: Text('Course Content'),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Course Content'), findsOneWidget);
    });

    testWidgets('FeatureFlagGate hides child when flag is disabled', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const FeatureFlagGate(
          flagKey: 'premium_ai_coach',
          child: Text('AI Feature'),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('AI Feature'), findsNothing);
    });

    testWidgets('PermissionGuard disable mode shows child with opacity', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const PermissionGuard(
          permission: 'security:audit_read',
          mode: PermissionGuardMode.disable,
          child: ElevatedButton(onPressed: null, child: Text('Restricted Button')),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Opacity), findsOneWidget);
      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, 0.38);
    });
  });

  group('AccessDeniedScreen Widget Tests', () {
    testWidgets('renders shield icon, title, and go back button', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const AccessDeniedScreen(
          correlationId: 'abc-123-def-456-ghi',
          requiredPermission: 'security:audit_read',
          reason: 'You do not have the required permission',
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Access Denied'), findsOneWidget);
      expect(find.text('You do not have the required permission'), findsOneWidget);
      expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
      expect(find.text('Go Back'), findsOneWidget);
      expect(find.text('Contact Support'), findsOneWidget);
    });

    testWidgets('RoleSwitchSheet shows all user roles', (tester) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [
          roleProvider.overrideWith((ref) {
            final n = RoleNotifier();
            n.seedRoles(['STUDENT', 'TEACHER']);
            return n;
          }),
        ],
        child: const MaterialApp(
          home: Scaffold(body: RoleSwitchSheet()),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Switch Role Context'), findsOneWidget);
      expect(find.text('STUDENT'), findsOneWidget);
      expect(find.text('TEACHER'), findsOneWidget);
    });
  });
}
