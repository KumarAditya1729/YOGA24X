import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/teacher_providers.dart';

class TeacherProfileHubScreen extends ConsumerWidget {
  const TeacherProfileHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(teacherProfileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.visibility),
            tooltip: 'View Public Profile',
            onPressed: () {
              final profile = profileState.valueOrNull;
              if (profile != null) {
                context.push('/teacher/public/${profile.userId}');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please create your profile first')),
                );
              }
            },
          )
        ],
      ),
      body: profileState.when(
        data: (profile) {
          if (profile == null) {
            return _buildNoProfileView(context);
          }
          return _buildHubView(context, profile);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildNoProfileView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            Text(
              'Become a Teacher',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              'Share your knowledge and guide others on their wellness journey. Create your teacher profile to get started.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Create Profile'),
              onPressed: () => context.push('/teacher/editor'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHubView(BuildContext context, dynamic profile) {
    final theme = Theme.of(context);
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Profile Completion Card
        Card(
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Profile Completion', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: profile.profileCompletion / 100,
                  backgroundColor: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 8),
                Text('${profile.profileCompletion}% Complete', style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        Text('Manage Profile', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        
        _buildMenuTile(
          context,
          icon: Icons.person,
          title: 'Basic Info & Bio',
          subtitle: 'Update your headline, bio, and languages',
          route: '/teacher/editor',
        ),
        _buildMenuTile(
          context,
          icon: Icons.verified,
          title: 'Verification (KYC)',
          subtitle: 'Status: ${profile.verificationStatus}',
          route: '/teacher/verification',
          trailing: _buildStatusBadge(profile.verificationStatus),
        ),
        _buildMenuTile(
          context,
          icon: Icons.workspace_premium,
          title: 'Certifications',
          subtitle: 'Manage your yoga alliance and other certs',
          route: '/teacher/certifications',
        ),
        _buildMenuTile(
          context,
          icon: Icons.photo_library,
          title: 'Portfolio',
          subtitle: 'Upload class videos, photos, and awards',
          route: '/teacher/portfolio',
        ),
        _buildMenuTile(
          context,
          icon: Icons.settings,
          title: 'Teaching Preferences',
          subtitle: 'Class types, age groups, and locations',
          route: '/teacher/preferences',
        ),
        
        const SizedBox(height: 24),
        Text('Analytics', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(child: _buildStatCard(context, 'Total Students', profile.stats?.totalStudents.toString() ?? '0')),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard(context, 'Classes Taught', profile.stats?.totalClasses.toString() ?? '0')),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildStatCard(context, 'Average Rating', profile.stats?.averageRating.toStringAsFixed(1) ?? '0.0', icon: Icons.star)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard(context, 'Profile Views', profile.stats?.profileViewsTotal.toString() ?? '0')),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
    Widget? trailing,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: () => context.push(route),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, {IconData? icon}) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.amber),
              const SizedBox(height: 8),
            ],
            Text(value, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'APPROVED': color = Colors.green; break;
      case 'PENDING':
      case 'UNDER_REVIEW': color = Colors.orange; break;
      case 'REJECTED': color = Colors.red; break;
      default: color = Colors.grey; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
