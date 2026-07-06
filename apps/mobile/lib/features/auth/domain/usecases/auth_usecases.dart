// ==============================================================================
// Yoga24X AI Engineering OS — Auth Domain Use Cases
// ==============================================================================

import '../entities/auth_entities.dart';
import '../repositories/auth_repository.dart';

class LoginWithPasswordUseCase {
  final AuthRepository repository;
  LoginWithPasswordUseCase(this.repository);

  Future<AuthResult> call({
    required String emailOrPhone,
    required String password,
    required Map<String, dynamic> deviceInfo,
  }) {
    return repository.loginWithPassword(
      emailOrPhone: emailOrPhone,
      password: password,
      deviceInfo: deviceInfo,
    );
  }
}

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<AuthResult> call({
    required String email,
    String? phoneNumber,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    required Map<String, dynamic> deviceInfo,
  }) {
    return repository.register(
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      firstName: firstName,
      lastName: lastName,
      role: role,
      deviceInfo: deviceInfo,
    );
  }
}

class RequestOtpUseCase {
  final AuthRepository repository;
  RequestOtpUseCase(this.repository);

  Future<void> call({
    required String identifier,
    required String purpose,
    String channel = 'SMS',
  }) {
    return repository.requestOtp(identifier: identifier, purpose: purpose, channel: channel);
  }
}

class LoginWithOtpUseCase {
  final AuthRepository repository;
  LoginWithOtpUseCase(this.repository);

  Future<AuthResult> call({
    required String identifier,
    required String otpCode,
    required String purpose,
    required Map<String, dynamic> deviceInfo,
  }) {
    return repository.loginWithOtp(
      identifier: identifier,
      otpCode: otpCode,
      purpose: purpose,
      deviceInfo: deviceInfo,
    );
  }
}

class LoginWithGoogleUseCase {
  final AuthRepository repository;
  LoginWithGoogleUseCase(this.repository);

  Future<AuthResult> call({
    required String idToken,
    required String role,
    required Map<String, dynamic> deviceInfo,
  }) {
    return repository.loginWithGoogle(idToken: idToken, role: role, deviceInfo: deviceInfo);
  }
}

class LoginWithAppleUseCase {
  final AuthRepository repository;
  LoginWithAppleUseCase(this.repository);

  Future<AuthResult> call({
    required String identityToken,
    required String authorizationCode,
    String? firstName,
    String? lastName,
    required String role,
    required Map<String, dynamic> deviceInfo,
  }) {
    return repository.loginWithApple(
      identityToken: identityToken,
      authorizationCode: authorizationCode,
      firstName: firstName,
      lastName: lastName,
      role: role,
      deviceInfo: deviceInfo,
    );
  }
}

class LoginWithBiometricUseCase {
  final AuthRepository repository;
  LoginWithBiometricUseCase(this.repository);

  Future<AuthResult> call({
    required String userId,
    required String deviceFingerprint,
    required String cryptographicSignature,
    required Map<String, dynamic> deviceInfo,
  }) {
    return repository.loginWithBiometric(
      userId: userId,
      deviceFingerprint: deviceFingerprint,
      cryptographicSignature: cryptographicSignature,
      deviceInfo: deviceInfo,
    );
  }
}

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  Future<void> call({bool allDevices = false}) {
    return repository.logout(allDevices: allDevices);
  }
}
