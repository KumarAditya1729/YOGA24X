// ==============================================================================
// Yoga24X AI Engineering OS — Session & Trusted Device Riverpod State
// ==============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth_entities.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_providers.dart';

class SessionState {
  final bool isLoading;
  final List<UserSession> sessions;
  final List<TrustedDevice> trustedDevices;
  final String? errorMessage;

  const SessionState({
    this.isLoading = false,
    this.sessions = const [],
    this.trustedDevices = const [],
    this.errorMessage,
  });

  SessionState copyWith({
    bool? isLoading,
    List<UserSession>? sessions,
    List<TrustedDevice>? trustedDevices,
    String? errorMessage,
  }) {
    return SessionState(
      isLoading: isLoading ?? this.isLoading,
      sessions: sessions ?? this.sessions,
      trustedDevices: trustedDevices ?? this.trustedDevices,
      errorMessage: errorMessage,
    );
  }
}

class SessionNotifier extends StateNotifier<SessionState> {
  final AuthRepository _repository;

  SessionNotifier(this._repository) : super(const SessionState());

  Future<void> loadSessionsAndDevices() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final sessions = await _repository.listActiveSessions();
      final devices = await _repository.listTrustedDevices();
      state = state.copyWith(isLoading: false, sessions: sessions, trustedDevices: devices);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> revokeSession(String sessionId) async {
    try {
      await _repository.revokeSession(sessionId);
      state = state.copyWith(
        sessions: state.sessions.where((s) => s.sessionId != sessionId).toList(),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> revokeAllOtherSessions() async {
    try {
      await _repository.revokeAllOtherSessions();
      await loadSessionsAndDevices();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> revokeTrustedDevice(String fingerprint) async {
    try {
      await _repository.revokeTrustedDevice(fingerprint);
      state = state.copyWith(
        trustedDevices: state.trustedDevices.where((d) => d.deviceFingerprint != fingerprint).toList(),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

final sessionNotifierProvider = StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier(ref.watch(authRepositoryProvider));
});
