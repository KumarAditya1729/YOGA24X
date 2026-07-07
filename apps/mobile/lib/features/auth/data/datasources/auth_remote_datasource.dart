// ==============================================================================
// Yoga24X AI Engineering OS — Auth Remote Data Source (Dio API Client)
// ==============================================================================

import 'package:dio/dio.dart';
import '../models/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResultModel> loginWithPassword({
    required String emailOrPhone,
    required String password,
    required Map<String, dynamic> deviceInfo,
  });

  Future<AuthResultModel> register({
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
    required String channel,
  });

  Future<AuthResultModel> loginWithOtp({
    required String identifier,
    required String otpCode,
    required String purpose,
    required Map<String, dynamic> deviceInfo,
  });

  Future<AuthResultModel> loginWithGoogle({
    required String idToken,
    required String role,
    required Map<String, dynamic> deviceInfo,
  });

  Future<AuthResultModel> loginWithApple({
    required String identityToken,
    required String authorizationCode,
    String? firstName,
    String? lastName,
    required String role,
    required Map<String, dynamic> deviceInfo,
  });

  Future<AuthResultModel> loginWithBiometric({
    required String userId,
    required String deviceFingerprint,
    required String cryptographicSignature,
    required Map<String, dynamic> deviceInfo,
  });

  Future<AuthTokenModel> refreshToken(String refreshToken);
  Future<void> logout({required String refreshToken, bool allDevices = false});
  Future<AuthUserModel> getCurrentUser();

  Future<List<UserSessionModel>> listActiveSessions();
  Future<void> revokeSession(String sessionId);
  Future<void> revokeAllOtherSessions();
  Future<List<TrustedDeviceModel>> listTrustedDevices();
  Future<TrustedDeviceModel> registerTrustedDevice({
    required String deviceFingerprint,
    required String deviceName,
    String? publicKey,
  });
  Future<void> revokeTrustedDevice(String fingerprint);

  Future<void> resetPassword({
    required String identifier,
    required String otpCode,
    required String newPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  const AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResultModel> loginWithPassword({
    required String emailOrPhone,
    required String password,
    required Map<String, dynamic> deviceInfo,
  }) async {
    final response = await dio.post('/api/v1/auth/login', data: {
      'emailOrPhone': emailOrPhone,
      'password': password,
      'deviceInfo': deviceInfo,
    });
    return AuthResultModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AuthResultModel> register({
    required String email,
    String? phoneNumber,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    required Map<String, dynamic> deviceInfo,
  }) async {
    final response = await dio.post('/api/v1/auth/register', data: {
      'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'deviceInfo': deviceInfo,
    });
    return AuthResultModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> requestOtp({
    required String identifier,
    required String purpose,
    required String channel,
  }) async {
    await dio.post('/api/v1/auth/otp/request', data: {
      'identifier': identifier,
      'purpose': purpose,
      'channel': channel,
    });
  }

  @override
  Future<AuthResultModel> loginWithOtp({
    required String identifier,
    required String otpCode,
    required String purpose,
    required Map<String, dynamic> deviceInfo,
  }) async {
    final response = await dio.post('/api/v1/auth/otp/verify', data: {
      'identifier': identifier,
      'otpCode': otpCode,
      'purpose': purpose,
      'deviceInfo': deviceInfo,
    });
    return AuthResultModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AuthResultModel> loginWithGoogle({
    required String idToken,
    required String role,
    required Map<String, dynamic> deviceInfo,
  }) async {
    final response = await dio.post('/api/v1/auth/oauth/google', data: {
      'idToken': idToken,
      'role': role,
      'deviceInfo': deviceInfo,
    });
    return AuthResultModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AuthResultModel> loginWithApple({
    required String identityToken,
    required String authorizationCode,
    String? firstName,
    String? lastName,
    required String role,
    required Map<String, dynamic> deviceInfo,
  }) async {
    final response = await dio.post('/api/v1/auth/oauth/apple', data: {
      'identityToken': identityToken,
      'authorizationCode': authorizationCode,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      'role': role,
      'deviceInfo': deviceInfo,
    });
    return AuthResultModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AuthResultModel> loginWithBiometric({
    required String userId,
    required String deviceFingerprint,
    required String cryptographicSignature,
    required Map<String, dynamic> deviceInfo,
  }) async {
    final response = await dio.post('/api/v1/auth/biometric/login', data: {
      'userId': userId,
      'deviceFingerprint': deviceFingerprint,
      'cryptographicSignature': cryptographicSignature,
      'deviceInfo': deviceInfo,
    });
    return AuthResultModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AuthTokenModel> refreshToken(String refreshToken) async {
    final response = await dio.post('/api/v1/auth/refresh', data: {
      'refreshToken': refreshToken,
    });
    return AuthTokenModel.fromJson(response.data['tokens'] as Map<String, dynamic>);
  }

  @override
  Future<void> logout({required String refreshToken, bool allDevices = false}) async {
    await dio.post('/api/v1/auth/logout', data: {
      'refreshToken': refreshToken,
      'allDevices': allDevices,
    });
  }

  @override
  Future<AuthUserModel> getCurrentUser() async {
    final response = await dio.get('/api/v1/auth/me');
    return AuthUserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<UserSessionModel>> listActiveSessions() async {
    final response = await dio.get('/api/v1/sessions');
    final list = response.data as List<dynamic>;
    return list.map((e) => UserSessionModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> revokeSession(String sessionId) async {
    await dio.delete('/api/v1/sessions/$sessionId');
  }

  @override
  Future<void> revokeAllOtherSessions() async {
    await dio.delete('/api/v1/sessions/revoke/others');
  }

  @override
  Future<List<TrustedDeviceModel>> listTrustedDevices() async {
    final response = await dio.get('/api/v1/sessions/devices/trusted');
    final list = response.data as List<dynamic>;
    return list.map((e) => TrustedDeviceModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<TrustedDeviceModel> registerTrustedDevice({
    required String deviceFingerprint,
    required String deviceName,
    String? publicKey,
  }) async {
    final response = await dio.post('/api/v1/sessions/devices/trusted', data: {
      'deviceFingerprint': deviceFingerprint,
      'deviceName': deviceName,
      if (publicKey != null) 'publicKey': publicKey,
    });
    return TrustedDeviceModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> revokeTrustedDevice(String fingerprint) async {
    await dio.delete('/api/v1/sessions/devices/trusted/$fingerprint');
  }

  @override
  Future<void> resetPassword({
    required String identifier,
    required String otpCode,
    required String newPassword,
  }) async {
    await dio.post('/api/v1/auth/password/reset', data: {
      'identifier': identifier,
      'otpCode': otpCode,
      'newPassword': newPassword,
    });
  }
}
