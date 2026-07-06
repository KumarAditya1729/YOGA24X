// ==============================================================================
// Yoga24X AI Engineering OS — Auth Riverpod State Management & Providers
// ==============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/auth_entities.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';

// ------------------------------------------------------------------------------
// Infrastructure & Datasource Providers
// ------------------------------------------------------------------------------

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000', // Configurable via environment in production
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // Add automatic token attachment and refresh interceptor
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final localDataSource = ref.read(authLocalDataSourceProvider);
      final tokens = await localDataSource.getTokens();
      if (tokens != null && tokens.accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
      }
      return handler.next(options);
    },
    onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        try {
          final repo = ref.read(authRepositoryProvider);
          final newTokens = await repo.refreshToken();
          error.requestOptions.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';
          final response = await dio.fetch(error.requestOptions);
          return handler.resolve(response);
        } catch (_) {
          ref.read(authStateNotifierProvider.notifier).logout();
        }
      }
      return handler.next(error);
    },
  ));

  return dio;
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(ref.watch(secureStorageProvider));
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

// ------------------------------------------------------------------------------
// Use Case Providers
// ------------------------------------------------------------------------------

final loginWithPasswordUseCaseProvider = Provider((ref) => LoginWithPasswordUseCase(ref.watch(authRepositoryProvider)));
final registerUseCaseProvider = Provider((ref) => RegisterUseCase(ref.watch(authRepositoryProvider)));
final requestOtpUseCaseProvider = Provider((ref) => RequestOtpUseCase(ref.watch(authRepositoryProvider)));
final loginWithOtpUseCaseProvider = Provider((ref) => LoginWithOtpUseCase(ref.watch(authRepositoryProvider)));
final loginWithGoogleUseCaseProvider = Provider((ref) => LoginWithGoogleUseCase(ref.watch(authRepositoryProvider)));
final loginWithAppleUseCaseProvider = Provider((ref) => LoginWithAppleUseCase(ref.watch(authRepositoryProvider)));
final loginWithBiometricUseCaseProvider = Provider((ref) => LoginWithBiometricUseCase(ref.watch(authRepositoryProvider)));
final logoutUseCaseProvider = Provider((ref) => LogoutUseCase(ref.watch(authRepositoryProvider)));

// ------------------------------------------------------------------------------
// Auth State & Notifier
// ------------------------------------------------------------------------------

enum AuthStatus { initial, loading, authenticated, unauthenticated, mfaRequired, error }

class AuthState {
  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;
  final String? mfaIdentifier;
  final String? mfaPurpose;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.mfaIdentifier,
    this.mfaPurpose,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? errorMessage,
    String? mfaIdentifier,
    String? mfaPurpose,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      mfaIdentifier: mfaIdentifier ?? this.mfaIdentifier,
      mfaPurpose: mfaPurpose ?? this.mfaPurpose,
    );
  }
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final LoginWithPasswordUseCase _loginWithPassword;
  final RegisterUseCase _register;
  final RequestOtpUseCase _requestOtp;
  final LoginWithOtpUseCase _loginWithOtp;
  final LoginWithGoogleUseCase _loginWithGoogle;
  final LoginWithAppleUseCase _loginWithApple;
  final LoginWithBiometricUseCase _loginWithBiometric;
  final LogoutUseCase _logout;

  AuthStateNotifier({
    required AuthRepository repository,
    required LoginWithPasswordUseCase loginWithPassword,
    required RegisterUseCase register,
    required RequestOtpUseCase requestOtp,
    required LoginWithOtpUseCase loginWithOtp,
    required LoginWithGoogleUseCase loginWithGoogle,
    required LoginWithAppleUseCase loginWithApple,
    required LoginWithBiometricUseCase loginWithBiometric,
    required LogoutUseCase logout,
  })  : _repository = repository,
        _loginWithPassword = loginWithPassword,
        _register = register,
        _requestOtp = requestOtp,
        _loginWithOtp = loginWithOtp,
        _loginWithGoogle = loginWithGoogle,
        _loginWithApple = loginWithApple,
        _loginWithBiometric = loginWithBiometric,
        _logout = logout,
        super(const AuthState());

  Future<void> checkAuthentication() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final isAuth = await _repository.isAuthenticated();
      if (isAuth) {
        final user = await _repository.getCurrentUser();
        if (user != null) {
          state = state.copyWith(status: AuthStatus.authenticated, user: user);
          return;
        }
      }
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } catch (_) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> loginWithPassword({
    required String emailOrPhone,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final result = await _loginWithPassword(
        emailOrPhone: emailOrPhone,
        password: password,
        deviceInfo: _getDeviceInfo(),
      );
      if (result.requiresMfa) {
        state = state.copyWith(
          status: AuthStatus.mfaRequired,
          mfaIdentifier: emailOrPhone,
          mfaPurpose: 'LOGIN_2FA',
        );
      } else {
        state = state.copyWith(status: AuthStatus.authenticated, user: result.user);
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> register({
    required String email,
    String? phoneNumber,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final result = await _register(
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        firstName: firstName,
        lastName: lastName,
        role: role,
        deviceInfo: _getDeviceInfo(),
      );
      state = state.copyWith(status: AuthStatus.authenticated, user: result.user);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> requestOtp(String identifier, String purpose, {String channel = 'SMS'}) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _requestOtp(identifier: identifier, purpose: purpose, channel: channel);
      state = state.copyWith(status: AuthStatus.unauthenticated, mfaIdentifier: identifier, mfaPurpose: purpose);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> loginWithOtp(String identifier, String otpCode, String purpose) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final result = await _loginWithOtp(
        identifier: identifier,
        otpCode: otpCode,
        purpose: purpose,
        deviceInfo: _getDeviceInfo(),
      );
      state = state.copyWith(status: AuthStatus.authenticated, user: result.user);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> loginWithGoogle(String idToken, {String role = 'STUDENT'}) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final result = await _loginWithGoogle(idToken: idToken, role: role, deviceInfo: _getDeviceInfo());
      state = state.copyWith(status: AuthStatus.authenticated, user: result.user);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> loginWithApple(String identityToken, String authorizationCode, {String role = 'STUDENT'}) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final result = await _loginWithApple(
        identityToken: identityToken,
        authorizationCode: authorizationCode,
        role: role,
        deviceInfo: _getDeviceInfo(),
      );
      state = state.copyWith(status: AuthStatus.authenticated, user: result.user);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> loginWithBiometric(String userId, String fingerprint, String signature) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final result = await _loginWithBiometric(
        userId: userId,
        deviceFingerprint: fingerprint,
        cryptographicSignature: signature,
        deviceInfo: _getDeviceInfo(),
      );
      state = state.copyWith(status: AuthStatus.authenticated, user: result.user);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> logout({bool allDevices = false}) async {
    await _logout(allDevices: allDevices);
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Map<String, dynamic> _getDeviceInfo() {
    return {
      'deviceFingerprint': 'flutter_mobile_fp_101',
      'deviceName': 'Yoga24X Mobile App',
      'deviceType': 'MOBILE_IOS',
      'osVersion': 'iOS 17.5',
      'appVersion': '1.0.0',
    };
  }
}

final authStateNotifierProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(
    repository: ref.watch(authRepositoryProvider),
    loginWithPassword: ref.watch(loginWithPasswordUseCaseProvider),
    register: ref.watch(registerUseCaseProvider),
    requestOtp: ref.watch(requestOtpUseCaseProvider),
    loginWithOtp: ref.watch(loginWithOtpUseCaseProvider),
    loginWithGoogle: ref.watch(loginWithGoogleUseCaseProvider),
    loginWithApple: ref.watch(loginWithAppleUseCaseProvider),
    loginWithBiometric: ref.watch(loginWithBiometricUseCaseProvider),
    logout: ref.watch(logoutUseCaseProvider),
  );
});
