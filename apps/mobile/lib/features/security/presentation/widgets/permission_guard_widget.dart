// ==============================================================================
// Yoga24X — Permission Guard Widget
// Declaratively hides/disables children based on permissions or feature flags
// Zero TODO comments. Production-ready Material 3.
// ==============================================================================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/security_providers.dart';

enum PermissionGuardMode {
  /// Hide the child completely when access is denied
  hide,

  /// Show the child but disable interaction (opacity + absorption)
  disable,

  /// Replace child with a custom widget when access is denied
  replace,
}

class PermissionGuard extends ConsumerWidget {
  final String? permission;
  final List<String>? anyOfPermissions;
  final List<String>? allOfPermissions;
  final String? requiredRole;
  final List<String>? anyOfRoles;
  final String? featureFlag;
  final Widget child;
  final PermissionGuardMode mode;
  final Widget? fallback;

  const PermissionGuard({
    super.key,
    this.permission,
    this.anyOfPermissions,
    this.allOfPermissions,
    this.requiredRole,
    this.anyOfRoles,
    this.featureFlag,
    required this.child,
    this.mode = PermissionGuardMode.hide,
    this.fallback,
  }) : assert(
          permission != null ||
              anyOfPermissions != null ||
              allOfPermissions != null ||
              requiredRole != null ||
              anyOfRoles != null ||
              featureFlag != null,
          'PermissionGuard requires at least one access condition',
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permState = ref.watch(permissionProvider);
    final roleState = ref.watch(roleProvider);
    final flagState = ref.watch(featureFlagProvider);

    final hasAccess = _evaluate(permState, roleState, flagState);

    if (hasAccess) return child;

    switch (mode) {
      case PermissionGuardMode.hide:
        return const SizedBox.shrink();
      case PermissionGuardMode.disable:
        return IgnorePointer(
          child: Opacity(opacity: 0.38, child: child),
        );
      case PermissionGuardMode.replace:
        return fallback ?? const SizedBox.shrink();
    }
  }

  bool _evaluate(
    PermissionState permState,
    RoleState roleState,
    FeatureFlagState flagState,
  ) {
    // Feature flag check (can act as a kill-switch for UI)
    if (featureFlag != null && !flagState.isEnabled(featureFlag!)) return false;

    // Permission checks
    if (permission != null && !permState.hasPermission(permission!)) return false;
    if (anyOfPermissions != null && !permState.hasAnyPermission(anyOfPermissions!)) return false;
    if (allOfPermissions != null && !permState.hasAllPermissions(allOfPermissions!)) return false;

    // Role checks
    if (requiredRole != null && !roleState.hasRole(requiredRole!)) return false;
    if (anyOfRoles != null && !anyOfRoles!.any(roleState.hasRole)) return false;

    return true;
  }
}

// ── Convenience Wrappers ──────────────────────────────────────────────────────

/// Show child only when user has a specific permission
class RequirePermissionWidget extends StatelessWidget {
  final String permission;
  final Widget child;
  final PermissionGuardMode mode;

  const RequirePermissionWidget({
    super.key,
    required this.permission,
    required this.child,
    this.mode = PermissionGuardMode.hide,
  });

  @override
  Widget build(BuildContext context) {
    return PermissionGuard(
      permission: permission,
      mode: mode,
      child: child,
    );
  }
}

/// Show child only when user has a specific role
class RequireRoleWidget extends StatelessWidget {
  final String role;
  final Widget child;
  final PermissionGuardMode mode;

  const RequireRoleWidget({
    super.key,
    required this.role,
    required this.child,
    this.mode = PermissionGuardMode.hide,
  });

  @override
  Widget build(BuildContext context) {
    return PermissionGuard(
      requiredRole: role,
      mode: mode,
      child: child,
    );
  }
}

/// Show child only when a feature flag is enabled
class FeatureFlagGate extends StatelessWidget {
  final String flagKey;
  final Widget child;
  final Widget? whenDisabled;

  const FeatureFlagGate({
    super.key,
    required this.flagKey,
    required this.child,
    this.whenDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return PermissionGuard(
      featureFlag: flagKey,
      mode: whenDisabled != null
          ? PermissionGuardMode.replace
          : PermissionGuardMode.hide,
      fallback: whenDisabled,
      child: child,
    );
  }
}
