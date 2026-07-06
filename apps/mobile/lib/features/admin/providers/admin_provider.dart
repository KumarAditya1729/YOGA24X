// ==============================================================================
// Yoga24X Admin Platform — Riverpod State Provider
// ==============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlatformMetrics {
  final int totalUsers;
  final int activeSubscriptions;
  final num totalRevenue;
  final int dau;
  final int mau;
  final int churnRate;

  const PlatformMetrics({
    required this.totalUsers,
    required this.activeSubscriptions,
    required this.totalRevenue,
    required this.dau,
    required this.mau,
    required this.churnRate,
  });

  factory PlatformMetrics.empty() => const PlatformMetrics(
        totalUsers: 0,
        activeSubscriptions: 0,
        totalRevenue: 0,
        dau: 0,
        mau: 0,
        churnRate: 0,
      );
}

class AdminState {
  final bool isLoading;
  final String? error;
  final PlatformMetrics metrics;
  final List<Map<String, dynamic>> supportTickets;
  final List<Map<String, dynamic>> crmLeads;
  final List<Map<String, dynamic>> cmsArticles;

  const AdminState({
    this.isLoading = false,
    this.error,
    required this.metrics,
    this.supportTickets = const [],
    this.crmLeads = const [],
    this.cmsArticles = const [],
  });

  AdminState copyWith({
    bool? isLoading,
    String? error,
    PlatformMetrics? metrics,
    List<Map<String, dynamic>>? supportTickets,
    List<Map<String, dynamic>>? crmLeads,
    List<Map<String, dynamic>>? cmsArticles,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      metrics: metrics ?? this.metrics,
      supportTickets: supportTickets ?? this.supportTickets,
      crmLeads: crmLeads ?? this.crmLeads,
      cmsArticles: cmsArticles ?? this.cmsArticles,
    );
  }
}

class AdminNotifier extends StateNotifier<AdminState> {
  AdminNotifier() : super(AdminState(metrics: PlatformMetrics.empty()));

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: Wire to real AdminApiService
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(
        isLoading: false,
        metrics: const PlatformMetrics(
          totalUsers: 0,
          activeSubscriptions: 0,
          totalRevenue: 0,
          dau: 0,
          mau: 0,
          churnRate: 0,
        ),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final adminProvider = StateNotifierProvider<AdminNotifier, AdminState>(
  (ref) => AdminNotifier(),
);
