// ==============================================================================
// Yoga24X AI Engineering OS — Auth Repository Domain Contract
// ==============================================================================

import '../entities/auth_entities.dart';

abstract class AuthRepository {
  // Authentication Flows
  Future<AuthResult> loginWithPassword({
    required String emailOrPhone,
    required String password,
    required Map<String, dynamic> deviceInfo,
  });

  Future<AuthResult> register({
    required String email,
    String? phoneNumber,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    required Map<String, dynamic> deviceInfo,
  });

  Future<void> requestOtp({
    required String identifier,
    required String purpose,
    String channel = 'SMS',
  });

  Future<AuthResult> loginWithOtp({
    required String identifier,
    required String otpCode,
    required String purpose,
    required Map<String, dynamic> deviceInfo,
  });

  Future<AuthResult> loginWithGoogle({
    required String idToken,
    required String role,
    required Map<String, dynamic> deviceInfo,
  });

  Future<AuthResult> loginWithApple({
    required String identityToken,
    required String authorizationCode,
    String? firstName,
    String? lastName,
    required String role,
    required Map<String, dynamic> deviceInfo,
  });

  Future<AuthResult> loginWithBiometric({
    required String userId,
    required String deviceFingerprint,
    required String cryptographicSignature,
    required Map<String, dynamic> deviceInfo,
  });

  // Token Rotation & Session Management
  Future<AuthToken> refreshToken();
  Future<void> logout({bool allDevices = false});
  Future<AuthUser?> getCurrentUser();
  
  // Session & Device Controls
  Future<List<UserSession>> listActiveSessions();
  Future<void> revokeSession(String sessionId);
  Future<void> revokeAllOtherSessions();
  Future<List<TrustedDevice>> listTrustedDevices();
  Future<TrustedDevice> registerTrustedDevice({
    required String deviceFingerprint,
    required String deviceName,
    String? publicKey,
  });
  Future<void> revokeTrustedDevice(String fingerprint);

  // Password Reset
  Future<void> resetPassword({
    required String identifier,
    required String otpCode,
    required String newPassword,
  });

  // Local Storage Check
  Future<bool> isAuthenticated();
}
