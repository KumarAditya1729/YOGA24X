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
      // Attempt real API call if backend is online
      // final response = await _dio.get('/api/v1/admin/dashboard');
      // ...
      throw Exception('Standalone demo fallback');
    } catch (e) {
      // Standalone Demo Fallback with rich realistic enterprise data
      await Future.delayed(const Duration(milliseconds: 300));
      state = state.copyWith(
        isLoading: false,
        metrics: const PlatformMetrics(
          totalUsers: 24850,
          activeSubscriptions: 8420,
          totalRevenue: 142500,
          dau: 6200,
          mau: 18400,
          churnRate: 2,
        ),
        supportTickets: [
          {
            'id': 'TICK-1001',
            'subject': 'Biometric Auth setup issue on iOS 18',
            'user': 'Aditya (VIP Practitioner)',
            'status': 'HIGH',
            'time': '10 mins ago',
          },
          {
            'id': 'TICK-1002',
            'subject': 'RYT 500 Certificate verification review',
            'user': 'Acharya Vidyadhar',
            'status': 'MEDIUM',
            'time': '1 hour ago',
          },
          {
            'id': 'TICK-1003',
            'subject': 'Sattvic AI Voice Coach latency in Delhi region',
            'user': 'Priya Sharma',
            'status': 'LOW',
            'time': '3 hours ago',
          },
        ],
        crmLeads: [
          {
            'name': 'Ananda Yoga Studio Chain',
            'contact': 'contact@anandastudios.com',
            'plan': 'Enterprise White-Label',
            'value': '\$24,000/yr',
            'status': 'Negotiation',
          },
          {
            'name': 'Rishikesh Retreat Center',
            'contact': 'info@rishikeshretreat.in',
            'plan': 'Studio Pro',
            'value': '\$4,800/yr',
            'status': 'Demo Scheduled',
          },
        ],
        cmsArticles: [
          {
            'title': 'The Neuroscience of Pranayama & Breathwork',
            'author': 'Dr. Alok Verma',
            'category': 'Wellness Research',
            'views': '14.2k',
            'status': 'Published',
          },
          {
            'title': 'Ashtanga Vinyasa: Mastering Primary Series',
            'author': 'Acharya Vidyadhar',
            'category': 'Asana Guides',
            'views': '8.9k',
            'status': 'Published',
          },
        ],
      );
    }
  }
}

final adminProvider = StateNotifierProvider<AdminNotifier, AdminState>(
  (ref) => AdminNotifier(),
);
