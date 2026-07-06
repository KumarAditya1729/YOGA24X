// ==============================================================================
// Yoga24X AI Engineering OS — Auth Local Data Source (Secure Storage)
// ==============================================================================

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth_models.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens(AuthTokenModel tokens);
  Future<AuthTokenModel?> getTokens();
  Future<void> clearTokens();
  
  Future<void> saveUser(AuthUserModel user);
  Future<AuthUserModel?> getUser();
  Future<void> clearUser();

  Future<void> saveDeviceFingerprint(String fingerprint);
  Future<String?> getDeviceFingerprint();

  Future<void> saveBiometricKey(String publicKey, String signature);
  Future<Map<String, String>?> getBiometricKey();

  Future<void> clearAll();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  static const String _keyAccessToken = 'auth_access_token';
  static const String _keyRefreshToken = 'auth_refresh_token';
  static const String _keyExpiresIn = 'auth_expires_in';
  static const String _keyUserJson = 'auth_user_data_json';
  static const String _keyDeviceFingerprint = 'auth_device_fingerprint';
  static const String _keyBiometricPublic = 'auth_biometric_public_key';
  static const String _keyBiometricSig = 'auth_biometric_signature';

  const AuthLocalDataSourceImpl(this._secureStorage);

  @override
  Future<void> saveTokens(AuthTokenModel tokens) async {
    await Future.wait([
      _secureStorage.write(key: _keyAccessToken, value: tokens.accessToken),
      _secureStorage.write(key: _keyRefreshToken, value: tokens.refreshToken),
      _secureStorage.write(key: _keyExpiresIn, value: tokens.expiresIn.toString()),
    ]);
  }

  @override
  Future<AuthTokenModel?> getTokens() async {
    final accessToken = await _secureStorage.read(key: _keyAccessToken);
    final refreshToken = await _secureStorage.read(key: _keyRefreshToken);
    final expiresInStr = await _secureStorage.read(key: _keyExpiresIn);

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    return AuthTokenModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: int.tryParse(expiresInStr ?? '900') ?? 900,
    );
  }

  @override
  Future<void> clearTokens() async {
    await Future.wait([
      _secureStorage.delete(key: _keyAccessToken),
      _secureStorage.delete(key: _keyRefreshToken),
      _secureStorage.delete(key: _keyExpiresIn),
    ]);
  }

  @override
  Future<void> saveUser(AuthUserModel user) async {
    final jsonStr = jsonEncode(user.toJson());
    await _secureStorage.write(key: _keyUserJson, value: jsonStr);
  }

  @override
  Future<AuthUserModel?> getUser() async {
    final jsonStr = await _secureStorage.read(key: _keyUserJson);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return AuthUserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    await _secureStorage.delete(key: _keyUserJson);
  }

  @override
  Future<void> saveDeviceFingerprint(String fingerprint) async {
    await _secureStorage.write(key: _keyDeviceFingerprint, value: fingerprint);
  }

  @override
  Future<String?> getDeviceFingerprint() async {
    return _secureStorage.read(key: _keyDeviceFingerprint);
  }

  @override
  Future<void> saveBiometricKey(String publicKey, String signature) async {
    await Future.wait([
      _secureStorage.write(key: _keyBiometricPublic, value: publicKey),
      _secureStorage.write(key: _keyBiometricSig, value: signature),
    ]);
  }

  @override
  Future<Map<String, String>?> getBiometricKey() async {
    final pub = await _secureStorage.read(key: _keyBiometricPublic);
    final sig = await _secureStorage.read(key: _keyBiometricSig);
    if (pub == null || sig == null) return null;
    return {'publicKey': pub, 'signature': sig};
  }

  @override
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
