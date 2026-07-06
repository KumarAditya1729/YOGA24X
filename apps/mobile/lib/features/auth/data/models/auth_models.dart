// ==============================================================================
// Yoga24X AI Engineering OS — Auth Data Models (JSON Serialization)
// ==============================================================================

import '../../domain/entities/auth_entities.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    super.phoneNumber,
    required super.firstName,
    required super.lastName,
    super.avatarUrl,
    required super.roles,
    required super.status,
    required super.isEmailVerified,
    required super.isPhoneVerified,
    required super.twoFactorEnabled,
    super.tenantId,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      firstName: json['firstName'] as String? ?? 'Yoga',
      lastName: json['lastName'] as String? ?? 'Student',
      avatarUrl: json['avatarUrl'] as String?,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => _parseRole(e.toString()))
              .toList() ??
          [UserRole.student],
      status: _parseStatus(json['status']?.toString() ?? 'ACTIVE'),
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
      twoFactorEnabled: json['twoFactorEnabled'] as bool? ?? false,
      tenantId: json['tenantId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'avatarUrl': avatarUrl,
      'roles': roles.map((r) => r.name.toUpperCase()).toList(),
      'status': status.name.toUpperCase(),
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'twoFactorEnabled': twoFactorEnabled,
      'tenantId': tenantId,
    };
  }

  static UserRole _parseRole(String roleStr) {
    switch (roleStr.toUpperCase()) {
      case 'TEACHER':
        return UserRole.teacher;
      case 'DOCTOR':
        return UserRole.doctor;
      case 'NUTRITIONIST':
        return UserRole.nutritionist;
      case 'MEDITATION_COACH':
        return UserRole.meditationCoach;
      case 'STUDIO_OWNER':
        return UserRole.studioOwner;
      case 'CORPORATE_HR':
        return UserRole.corporateHr;
      case 'ADMIN':
        return UserRole.admin;
      case 'SUPER_ADMIN':
        return UserRole.superAdmin;
      default:
        return UserRole.student;
    }
  }

  static UserStatus _parseStatus(String statusStr) {
    switch (statusStr.toUpperCase()) {
      case 'SUSPENDED':
        return UserStatus.suspended;
      case 'PENDING_VERIFICATION':
        return UserStatus.pendingVerification;
      case 'BANNED':
        return UserStatus.banned;
      case 'DELETED':
        return UserStatus.deleted;
      default:
        return UserStatus.active;
    }
  }
}

class AuthTokenModel extends AuthToken {
  const AuthTokenModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresIn,
    super.tokenType,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 900,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
      'tokenType': tokenType,
    };
  }
}

class UserSessionModel extends UserSession {
  const UserSessionModel({
    required super.sessionId,
    required super.deviceType,
    required super.osVersion,
    required super.appVersion,
    super.ipAddress,
    super.userAgent,
    required super.createdAt,
    required super.lastActiveAt,
    super.isCurrentSession,
  });

  factory UserSessionModel.fromJson(Map<String, dynamic> json) {
    return UserSessionModel(
      sessionId: json['id'] as String? ?? json['sessionId'] as String,
      deviceType: json['deviceType'] as String? ?? 'MOBILE',
      osVersion: json['osVersion'] as String? ?? 'N/A',
      appVersion: json['appVersion'] as String? ?? '1.0.0',
      ipAddress: json['ipAddress'] as String?,
      userAgent: json['userAgent'] as String?,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      lastActiveAt: DateTime.tryParse(json['lastActiveAt']?.toString() ?? '') ?? DateTime.now(),
      isCurrentSession: json['isCurrentSession'] as bool? ?? false,
    );
  }
}

class TrustedDeviceModel extends TrustedDevice {
  const TrustedDeviceModel({
    required super.id,
    required super.deviceFingerprint,
    required super.deviceName,
    required super.createdAt,
    required super.lastUsedAt,
    super.isRevoked,
  });

  factory TrustedDeviceModel.fromJson(Map<String, dynamic> json) {
    return TrustedDeviceModel(
      id: json['id'] as String,
      deviceFingerprint: json['deviceFingerprint'] as String,
      deviceName: json['deviceName'] as String? ?? 'Trusted Device',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      lastUsedAt: DateTime.tryParse(json['lastUsedAt']?.toString() ?? '') ?? DateTime.now(),
      isRevoked: json['isRevoked'] as bool? ?? false,
    );
  }
}

class AuthResultModel extends AuthResult {
  const AuthResultModel({
    required super.user,
    required super.tokens,
    required super.sessionId,
    super.isTrustedDevice,
    super.requiresMfa,
    super.riskScore,
  });

  factory AuthResultModel.fromJson(Map<String, dynamic> json) {
    return AuthResultModel(
      user: AuthUserModel.fromJson(json['user'] as Map<String, dynamic>),
      tokens: AuthTokenModel.fromJson(json['tokens'] as Map<String, dynamic>),
      sessionId: (json['session'] as Map<String, dynamic>)['sessionId'] as String? ?? '',
      isTrustedDevice: (json['session'] as Map<String, dynamic>)['isTrustedDevice'] as bool? ?? false,
      requiresMfa: json['requiresMfa'] as bool? ?? false,
      riskScore: (json['risk'] as Map<String, dynamic>?)?['score'] as int? ?? 0,
    );
  }
}
