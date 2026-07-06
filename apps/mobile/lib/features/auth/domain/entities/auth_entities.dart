// ==============================================================================
// Yoga24X AI Engineering OS — Auth Domain Entities (User, Token, Session)
// ==============================================================================

import 'package:equatable/equatable.dart';

enum UserRole {
  student,
  teacher,
  doctor,
  nutritionist,
  meditationCoach,
  studioOwner,
  corporateHr,
  admin,
  superAdmin,
}

enum UserStatus {
  active,
  suspended,
  pendingVerification,
  banned,
  deleted,
}

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? phoneNumber;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final List<UserRole> roles;
  final UserStatus status;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool twoFactorEnabled;
  final String? tenantId;

  const AuthUser({
    required this.id,
    required this.email,
    this.phoneNumber,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
    required this.roles,
    required this.status,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.twoFactorEnabled,
    this.tenantId,
  });

  String get fullName => '$firstName $lastName'.trim();
  bool get isTeacher => roles.contains(UserRole.teacher);
  bool get isAdmin => roles.contains(UserRole.admin) || roles.contains(UserRole.superAdmin);

  @override
  List<Object?> get props => [
        id,
        email,
        phoneNumber,
        firstName,
        lastName,
        avatarUrl,
        roles,
        status,
        isEmailVerified,
        isPhoneVerified,
        twoFactorEnabled,
        tenantId,
      ];
}

class AuthToken extends Equatable {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;

  const AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    this.tokenType = 'Bearer',
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresIn, tokenType];
}

class UserSession extends Equatable {
  final String sessionId;
  final String deviceType;
  final String osVersion;
  final String appVersion;
  final String? ipAddress;
  final String? userAgent;
  final DateTime createdAt;
  final DateTime lastActiveAt;
  final bool isCurrentSession;

  const UserSession({
    required this.sessionId,
    required this.deviceType,
    required this.osVersion,
    required this.appVersion,
    this.ipAddress,
    this.userAgent,
    required this.createdAt,
    required this.lastActiveAt,
    this.isCurrentSession = false,
  });

  @override
  List<Object?> get props => [
        sessionId,
        deviceType,
        osVersion,
        appVersion,
        ipAddress,
        userAgent,
        createdAt,
        lastActiveAt,
        isCurrentSession,
      ];
}

class TrustedDevice extends Equatable {
  final String id;
  final String deviceFingerprint;
  final String deviceName;
  final DateTime createdAt;
  final DateTime lastUsedAt;
  final bool isRevoked;

  const TrustedDevice({
    required this.id,
    required this.deviceFingerprint,
    required this.deviceName,
    required this.createdAt,
    required this.lastUsedAt,
    this.isRevoked = false,
  });

  @override
  List<Object?> get props => [id, deviceFingerprint, deviceName, createdAt, lastUsedAt, isRevoked];
}

class AuthResult extends Equatable {
  final AuthUser user;
  final AuthToken tokens;
  final String sessionId;
  final bool isTrustedDevice;
  final bool requiresMfa;
  final int riskScore;

  const AuthResult({
    required this.user,
    required this.tokens,
    required this.sessionId,
    this.isTrustedDevice = false,
    this.requiresMfa = false,
    this.riskScore = 0,
  });

  @override
  List<Object?> get props => [user, tokens, sessionId, isTrustedDevice, requiresMfa, riskScore];
}
