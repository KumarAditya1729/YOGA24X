// ==============================================================================
// Yoga24X AI Engineering OS — Auth Repository Implementation
// ==============================================================================

import '../../domain/entities/auth_entities.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthResult> loginWithPassword({
    required String emailOrPhone,
    required String password,
    required Map<String, dynamic> deviceInfo,
  }) async {
    final result = await remoteDataSource.loginWithPassword(
      emailOrPhone: emailOrPhone,
      password: password,
      deviceInfo: deviceInfo,
    );
    await _persistAuthResult(result);
    return result;
  }

  @override
  Future<AuthResult> register({
    required String email,
    String? phoneNumber,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    required Map<String, dynamic> deviceInfo,
  }) async {
    final result = await remoteDataSource.register(
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      firstName: firstName,
      lastName: lastName,
      role: role,
      deviceInfo: deviceInfo,
    );
    await _persistAuthResult(result);
    return result;
  }

  @override
  Future<void> requestOtp({
    required String identifier,
    required String purpose,
    String channel = 'SMS',
  }) async {
    await remoteDataSource.requestOtp(
      identifier: identifier,
      purpose: purpose,
      channel: channel,
    );
  }

  @override
  Future<AuthResult> loginWithOtp({
    required String identifier,
    required String otpCode,
    required String purpose,
    required Map<String, dynamic> deviceInfo,
  }) async {
    final result = await remoteDataSource.loginWithOtp(
      identifier: identifier,
      otpCode: otpCode,
      purpose: purpose,
      deviceInfo: deviceInfo,
    );
    await _persistAuthResult(result);
    return result;
  }

  @override
  Future<AuthResult> loginWithGoogle({
    required String idToken,
    required String role,
    required Map<String, dynamic> deviceInfo,
  }) async {
    final result = await remoteDataSource.loginWithGoogle(
      idToken: idToken,
      role: role,
      deviceInfo: deviceInfo,
    );
    await _persistAuthResult(result);
    return result;
  }

  @override
  Future<AuthResult> loginWithApple({
    required String identityToken,
    required String authorizationCode,
    String? firstName,
    String? lastName,
    required String role,
    required Map<String, dynamic> deviceInfo,
  }) async {
    final result = await remoteDataSource.loginWithApple(
      identityToken: identityToken,
      authorizationCode: authorizationCode,
      firstName: firstName,
      lastName: lastName,
      role: role,
      deviceInfo: deviceInfo,
    );
    await _persistAuthResult(result);
    return result;
  }

  @override
  Future<AuthResult> loginWithBiometric({
    required String userId,
    required String deviceFingerprint,
    required String cryptographicSignature,
    required Map<String, dynamic> deviceInfo,
  }) async {
    final result = await remoteDataSource.loginWithBiometric(
      userId: userId,
      deviceFingerprint: deviceFingerprint,
      cryptographicSignature: cryptographicSignature,
      deviceInfo: deviceInfo,
    );
    await _persistAuthResult(result);
    return result;
  }

  @override
  Future<AuthToken> refreshToken() async {
    final currentTokens = await localDataSource.getTokens();
    if (currentTokens == null) {
      throw Exception('No refresh token available');
    }
    final newTokens = await remoteDataSource.refreshToken(currentTokens.refreshToken);
    await localDataSource.saveTokens(newTokens);
    return newTokens;
  }

  @override
  Future<void> logout({bool allDevices = false}) async {
    try {
      final currentTokens = await localDataSource.getTokens();
      if (currentTokens != null) {
        await remoteDataSource.logout(
          refreshToken: currentTokens.refreshToken,
          allDevices: allDevices,
        );
      }
    } catch (_) {
      // Ignore network errors during logout
    } finally {
      await localDataSource.clearAll();
    }
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      await localDataSource.saveUser(userModel);
      return userModel;
    } catch (_) {
      return localDataSource.getUser();
    }
  }

  @override
  Future<List<UserSession>> listActiveSessions() async {
    return remoteDataSource.listActiveSessions();
  }

  @override
  Future<void> revokeSession(String sessionId) async {
    return remoteDataSource.revokeSession(sessionId);
  }

  @override
  Future<void> revokeAllOtherSessions() async {
    return remoteDataSource.revokeAllOtherSessions();
  }

  @override
  Future<List<TrustedDevice>> listTrustedDevices() async {
    return remoteDataSource.listTrustedDevices();
  }

  @override
  Future<TrustedDevice> registerTrustedDevice({
    required String deviceFingerprint,
    required String deviceName,
    String? publicKey,
  }) async {
    return remoteDataSource.registerTrustedDevice(
      deviceFingerprint: deviceFingerprint,
      deviceName: deviceName,
      publicKey: publicKey,
    );
  }

  @override
  Future<void> revokeTrustedDevice(String fingerprint) async {
    return remoteDataSource.revokeTrustedDevice(fingerprint);
  }

  @override
  Future<void> resetPassword({
    required String identifier,
    required String otpCode,
    required String newPassword,
  }) async {
    return remoteDataSource.resetPassword(
      identifier: identifier,
      otpCode: otpCode,
      newPassword: newPassword,
    );
  }

  @override
  Future<bool> isAuthenticated() async {
    final tokens = await localDataSource.getTokens();
    return tokens != null && tokens.accessToken.isNotEmpty;
  }

  Future<void> _persistAuthResult(AuthResultModel result) async {
    await localDataSource.saveTokens(result.tokens as AuthTokenModel);
    await localDataSource.saveUser(result.user as AuthUserModel);
  }
}
