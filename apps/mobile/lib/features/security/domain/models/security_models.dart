// ==============================================================================
// Yoga24X — Security Domain Models (Flutter)
// Immutable, Equatable value objects for all security domain entities
// ==============================================================================
import 'package:equatable/equatable.dart';

// ── Permission ─────────────────────────────────────────────────────────────────

class Permission extends Equatable {
  final String key; // "module:action"
  final String effect; // ALLOW | DENY | CONDITIONAL
  final String state; // DIRECT | INHERITED | OVERRIDDEN | TEMPORARY
  final DateTime? expiresAt;

  const Permission({
    required this.key,
    required this.effect,
    required this.state,
    this.expiresAt,
  });

  bool get isExpired => expiresAt != null && expiresAt!.isBefore(DateTime.now());
  bool get isActive => !isExpired && effect == 'ALLOW';

  @override
  List<Object?> get props => [key, effect, state, expiresAt];
}

// ── User Role ──────────────────────────────────────────────────────────────────

class UserRole extends Equatable {
  final String id;
  final String name;
  final String? description;
  final bool isSystemRole;

  const UserRole({
    required this.id,
    required this.name,
    this.description,
    required this.isSystemRole,
  });

  @override
  List<Object?> get props => [id, name];
}

// ── Tenant ─────────────────────────────────────────────────────────────────────

class TenantInfo extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String plan;
  final String status;
  final Map<String, dynamic> brandingJson;
  final Map<String, dynamic> configJson;

  const TenantInfo({
    required this.id,
    required this.name,
    required this.slug,
    required this.plan,
    required this.status,
    required this.brandingJson,
    required this.configJson,
  });

  // Branding helpers
  String? get primaryColor => brandingJson['primaryColor'] as String?;
  String? get logoUrl => brandingJson['logoUrl'] as String?;
  String? get appName => brandingJson['appName'] as String?;

  @override
  List<Object?> get props => [id, slug, plan, status];
}

// ── Organization ────────────────────────────────────────────────────────────────

class OrganizationInfo extends Equatable {
  final String id;
  final String name;
  final String type;
  final String status;
  final String? logoUrl;
  final String memberRole;

  const OrganizationInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    this.logoUrl,
    required this.memberRole,
  });

  @override
  List<Object?> get props => [id, name, type];
}

// ── Feature Flag ──────────────────────────────────────────────────────────────

class FeatureFlag extends Equatable {
  final String key;
  final bool enabled;
  final String source; // kill_switch | user | org | tenant | global
  final Map<String, dynamic>? configJson;

  const FeatureFlag({
    required this.key,
    required this.enabled,
    required this.source,
    this.configJson,
  });

  @override
  List<Object?> get props => [key, enabled, source];
}

// ── Security Event Log Entry ───────────────────────────────────────────────────

class SecurityEventEntry extends Equatable {
  final String id;
  final String eventType;
  final String severity;
  final String description;
  final bool isAcknowledged;
  final DateTime createdAt;

  const SecurityEventEntry({
    required this.id,
    required this.eventType,
    required this.severity,
    required this.description,
    required this.isAcknowledged,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, eventType, createdAt];
}
