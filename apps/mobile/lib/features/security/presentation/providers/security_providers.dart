// ==============================================================================
// Yoga24X — Security Riverpod Providers (Flutter)
// Permission, Role, FeatureFlag & Tenant providers with cache-aside
// ==============================================================================
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../domain/models/security_models.dart';

// ── Shared Security State Base ─────────────────────────────────────────────────

enum SecurityStatus { initial, loading, loaded, error }

// ─────────────────────────────────────────────────────────────────────────────
// PART A — Permission Provider
// ─────────────────────────────────────────────────────────────────────────────

class PermissionState extends Equatable {
  final SecurityStatus status;
  final List<Permission> permissions;
  final String? error;

  const PermissionState({
    this.status = SecurityStatus.initial,
    this.permissions = const [],
    this.error,
  });

  PermissionState copyWith({
    SecurityStatus? status,
    List<Permission>? permissions,
    String? error,
  }) =>
      PermissionState(
        status: status ?? this.status,
        permissions: permissions ?? this.permissions,
        error: error ?? this.error,
      );

  bool hasPermission(String key) =>
      permissions.any((p) => p.key == key && p.isActive);

  bool hasAnyPermission(List<String> keys) =>
      keys.any(hasPermission);

  bool hasAllPermissions(List<String> keys) =>
      keys.every(hasPermission);

  @override
  List<Object?> get props => [status, permissions, error];
}

class PermissionNotifier extends StateNotifier<PermissionState> {
  PermissionNotifier() : super(const PermissionState());

  /// Called after login to seed user permissions from JWT claims
  void seedPermissions(List<Map<String, dynamic>> rawPermissions) {
    final permissions = rawPermissions
        .map(
          (p) => Permission(
            key: p['key'] as String,
            effect: p['effect'] as String? ?? 'ALLOW',
            state: p['state'] as String? ?? 'DIRECT',
            expiresAt: p['expiresAt'] != null
                ? DateTime.tryParse(p['expiresAt'] as String)
                : null,
          ),
        )
        .toList();

    state = state.copyWith(
      status: SecurityStatus.loaded,
      permissions: permissions,
    );
  }

  void clear() {
    state = const PermissionState();
  }
}

final permissionProvider =
    StateNotifierProvider<PermissionNotifier, PermissionState>(
  (ref) => PermissionNotifier(),
);

// ─────────────────────────────────────────────────────────────────────────────
// PART B — Role Provider
// ─────────────────────────────────────────────────────────────────────────────

class RoleState extends Equatable {
  final SecurityStatus status;
  final List<UserRole> roles;
  final String? activeRole; // for multi-role switching
  final String? error;

  const RoleState({
    this.status = SecurityStatus.initial,
    this.roles = const [],
    this.activeRole,
    this.error,
  });

  RoleState copyWith({
    SecurityStatus? status,
    List<UserRole>? roles,
    String? activeRole,
    String? error,
  }) =>
      RoleState(
        status: status ?? this.status,
        roles: roles ?? this.roles,
        activeRole: activeRole ?? this.activeRole,
        error: error ?? this.error,
      );

  bool hasRole(String roleName) => roles.any((r) => r.name == roleName);

  bool get isAdmin =>
      hasRole('SUPER_ADMIN') ||
      hasRole('PLATFORM_ADMIN') ||
      hasRole('STUDIO_OWNER') ||
      hasRole('STUDIO_MANAGER');

  bool get isTeacher => hasRole('TEACHER') || hasRole('MEDITATION_COACH');

  bool get isDoctor => hasRole('DOCTOR');

  @override
  List<Object?> get props => [status, roles, activeRole, error];
}

class RoleNotifier extends StateNotifier<RoleState> {
  RoleNotifier() : super(const RoleState());

  void seedRoles(List<String> roleNames) {
    final roles = roleNames
        .map((name) => UserRole(id: name, name: name, isSystemRole: true))
        .toList();
    state = state.copyWith(
      status: SecurityStatus.loaded,
      roles: roles,
      activeRole: roles.isNotEmpty ? roles.first.name : null,
    );
  }

  void switchActiveRole(String roleName) {
    if (!state.hasRole(roleName)) return;
    state = state.copyWith(activeRole: roleName);
  }

  void clear() {
    state = const RoleState();
  }
}

final roleProvider = StateNotifierProvider<RoleNotifier, RoleState>(
  (ref) => RoleNotifier(),
);

// ─────────────────────────────────────────────────────────────────────────────
// PART C — Feature Flag Provider
// ─────────────────────────────────────────────────────────────────────────────

class FeatureFlagState extends Equatable {
  final SecurityStatus status;
  final Map<String, FeatureFlag> flags;
  final String? error;

  const FeatureFlagState({
    this.status = SecurityStatus.initial,
    this.flags = const {},
    this.error,
  });

  FeatureFlagState copyWith({
    SecurityStatus? status,
    Map<String, FeatureFlag>? flags,
    String? error,
  }) =>
      FeatureFlagState(
        status: status ?? this.status,
        flags: flags ?? this.flags,
        error: error ?? this.error,
      );

  bool isEnabled(String key) => flags[key]?.enabled ?? false;
  FeatureFlag? getFlag(String key) => flags[key];

  @override
  List<Object?> get props => [status, flags, error];
}

class FeatureFlagNotifier extends StateNotifier<FeatureFlagState> {
  FeatureFlagNotifier() : super(const FeatureFlagState());

  void seedFlags(List<Map<String, dynamic>> rawFlags) {
    final flagMap = <String, FeatureFlag>{};
    for (final raw in rawFlags) {
      final key = raw['key'] as String;
      flagMap[key] = FeatureFlag(
        key: key,
        enabled: raw['enabled'] as bool? ?? false,
        source: raw['source'] as String? ?? 'global',
        configJson: raw['configJson'] as Map<String, dynamic>?,
      );
    }
    state = state.copyWith(
      status: SecurityStatus.loaded,
      flags: flagMap,
    );
  }

  void updateFlag(String key, bool enabled) {
    final updated = Map<String, FeatureFlag>.from(state.flags);
    final existing = updated[key];
    if (existing != null) {
      updated[key] = FeatureFlag(
        key: key,
        enabled: enabled,
        source: existing.source,
        configJson: existing.configJson,
      );
      state = state.copyWith(flags: updated);
    }
  }

  void clear() {
    state = const FeatureFlagState();
  }
}

final featureFlagProvider =
    StateNotifierProvider<FeatureFlagNotifier, FeatureFlagState>(
  (ref) => FeatureFlagNotifier(),
);

// ─────────────────────────────────────────────────────────────────────────────
// PART D — Tenant Provider
// ─────────────────────────────────────────────────────────────────────────────

class TenantState extends Equatable {
  final SecurityStatus status;
  final TenantInfo? tenant;
  final String? error;

  const TenantState({
    this.status = SecurityStatus.initial,
    this.tenant,
    this.error,
  });

  TenantState copyWith({
    SecurityStatus? status,
    TenantInfo? tenant,
    String? error,
  }) =>
      TenantState(
        status: status ?? this.status,
        tenant: tenant ?? this.tenant,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [status, tenant, error];
}

class TenantNotifier extends StateNotifier<TenantState> {
  TenantNotifier() : super(const TenantState());

  void setTenant(Map<String, dynamic> raw) {
    state = state.copyWith(
      status: SecurityStatus.loaded,
      tenant: TenantInfo(
        id: raw['id'] as String,
        name: raw['name'] as String,
        slug: raw['slug'] as String,
        plan: raw['plan'] as String? ?? 'FREE',
        status: raw['status'] as String? ?? 'ACTIVE',
        brandingJson: raw['brandingJson'] as Map<String, dynamic>? ?? {},
        configJson: raw['configJson'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  void clear() {
    state = const TenantState();
  }
}

final tenantProvider = StateNotifierProvider<TenantNotifier, TenantState>(
  (ref) => TenantNotifier(),
);
