// ==============================================================================
// Yoga24X Admin Platform — Admin Dashboard Screen
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_provider.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminProvider.notifier).loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminState = ref.watch(adminProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        title: const Text(
          'Yoga24X Admin',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.read(adminProvider.notifier).loadDashboard(),
          ),
        ],
      ),
      body: adminState.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
          : _buildBody(adminState),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF1A1A2E),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        indicatorColor: const Color(0xFF6C63FF).withValues(alpha: 0.3),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.dashboard, color: Color(0xFF6C63FF)),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.people, color: Color(0xFF6C63FF)),
            label: 'Users',
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.article, color: Color(0xFF6C63FF)),
            label: 'CMS',
          ),
          NavigationDestination(
            icon: Icon(Icons.support_agent_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.support_agent, color: Color(0xFF6C63FF)),
            label: 'Support',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.analytics, color: Color(0xFF6C63FF)),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(AdminState state) {
    switch (_selectedIndex) {
      case 0:
        return _buildOverview(state);
      case 1:
        return _buildUsersPanel();
      case 2:
        return _buildCmsPanel(state);
      case 3:
        return _buildSupportPanel(state);
      case 4:
        return _buildAnalyticsPanel(state);
      default:
        return _buildOverview(state);
    }
  }

  Widget _buildOverview(AdminState state) {
    final metrics = state.metrics;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Executive Dashboard',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _metricsGrid(metrics),
          const SizedBox(height: 24),
          const Text(
            'Quick Actions',
            style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _quickActionsRow(),
        ],
      ),
    );
  }

  Widget _metricsGrid(PlatformMetrics metrics) {
    final cards = [
      _MetricCard(label: 'Total Users', value: metrics.totalUsers.toString(), icon: Icons.people, color: const Color(0xFF6C63FF)),
      _MetricCard(label: 'Active Subs', value: metrics.activeSubscriptions.toString(), icon: Icons.subscriptions, color: const Color(0xFF00C9A7)),
      _MetricCard(label: 'DAU', value: metrics.dau.toString(), icon: Icons.today, color: const Color(0xFFFF6B6B)),
      _MetricCard(label: 'MAU', value: metrics.mau.toString(), icon: Icons.calendar_month, color: const Color(0xFFFFA94D)),
      _MetricCard(label: 'Churn Rate', value: '${metrics.churnRate}%', icon: Icons.trending_down, color: const Color(0xFFFF6B6B)),
      _MetricCard(label: 'Revenue', value: '₹${metrics.totalRevenue}', icon: Icons.currency_rupee, color: const Color(0xFF00C9A7)),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: cards.map((c) => _buildMetricCard(c)).toList(),
    );
  }

  Widget _buildMetricCard(_MetricCard card) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [card.color.withValues(alpha: 0.2), card.color.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: card.color.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(card.icon, color: card.color, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(card.value, style: TextStyle(color: card.color, fontSize: 22, fontWeight: FontWeight.bold)),
              Text(card.label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickActionsRow() {
    return Row(
      children: [
        _actionButton(Icons.add, 'New User', const Color(0xFF6C63FF)),
        const SizedBox(width: 12),
        _actionButton(Icons.article_outlined, 'New Article', const Color(0xFF00C9A7)),
        const SizedBox(width: 12),
        _actionButton(Icons.campaign_outlined, 'Campaign', const Color(0xFFFFA94D)),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsersPanel() {
    return const Center(
      child: Text('User Management Panel', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildCmsPanel(AdminState state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Content Management System', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...state.cmsArticles.map((a) => _cmsArticleTile(a)),
        if (state.cmsArticles.isEmpty)
          const Center(child: Text('No articles yet', style: TextStyle(color: Colors.white38))),
      ],
    );
  }

  Widget _cmsArticleTile(Map<String, dynamic> article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(article['title'] ?? '', style: const TextStyle(color: Colors.white)),
        subtitle: Text(article['type'] ?? '', style: const TextStyle(color: Colors.white54)),
        trailing: Chip(
          label: Text(article['status'] ?? 'DRAFT', style: const TextStyle(fontSize: 10, color: Colors.white)),
          backgroundColor: const Color(0xFF6C63FF).withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Widget _buildSupportPanel(AdminState state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Support Tickets', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...state.supportTickets.map((t) => _ticketTile(t)),
        if (state.supportTickets.isEmpty)
          const Center(child: Text('No tickets', style: TextStyle(color: Colors.white38))),
      ],
    );
  }

  Widget _ticketTile(Map<String, dynamic> ticket) {
    final color = ticket['priority'] == 'URGENT'
        ? const Color(0xFFFF6B6B)
        : const Color(0xFF6C63FF);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        title: Text(ticket['subject'] ?? '', style: const TextStyle(color: Colors.white)),
        subtitle: Text(ticket['status'] ?? '', style: TextStyle(color: color)),
        trailing: Icon(Icons.chevron_right, color: color),
      ),
    );
  }

  Widget _buildAnalyticsPanel(AdminState state) {
    return const Center(
      child: Text('Analytics Dashboard', style: TextStyle(color: Colors.white)),
    );
  }
}

class _MetricCard {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _MetricCard({required this.label, required this.value, required this.icon, required this.color});
}
