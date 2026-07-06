// ==============================================================================
// Yoga24X — Role Switch Sheet & Organization Selector
// Material 3 premium UI for role context switching and org/tenant navigation
// ==============================================================================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/security_providers.dart';

// ── Role Icons mapping ─────────────────────────────────────────────────────────
final Map<String, IconData> _roleIcons = {
  'SUPER_ADMIN': Icons.admin_panel_settings,
  'PLATFORM_ADMIN': Icons.manage_accounts,
  'STUDIO_OWNER': Icons.store,
  'STUDIO_MANAGER': Icons.business_center,
  'TEACHER': Icons.school,
  'DOCTOR': Icons.local_hospital,
  'NUTRITIONIST': Icons.eco,
  'MEDITATION_COACH': Icons.self_improvement,
  'CORPORATE_HR': Icons.people,
  'CORPORATE_MANAGER': Icons.corporate_fare,
  'STUDENT': Icons.fitness_center,
  'MODERATOR': Icons.shield,
  'SUPPORT_AGENT': Icons.support_agent,
  'FINANCE': Icons.account_balance_wallet,
  'CONTENT_MANAGER': Icons.edit_note,
  'GUEST': Icons.person_outline,
};

final Map<String, Color> _roleColors = {
  'SUPER_ADMIN': Colors.red.shade700,
  'PLATFORM_ADMIN': Colors.deepPurple,
  'STUDIO_OWNER': Colors.indigo,
  'STUDIO_MANAGER': Colors.blue,
  'TEACHER': Colors.teal,
  'DOCTOR': Colors.green.shade700,
  'NUTRITIONIST': Colors.green,
  'MEDITATION_COACH': Colors.purple,
  'CORPORATE_HR': Colors.orange,
  'CORPORATE_MANAGER': Colors.deepOrange,
  'STUDENT': Colors.cyan.shade700,
  'MODERATOR': Colors.blueGrey,
  'SUPPORT_AGENT': Colors.lime.shade700,
  'FINANCE': Colors.amber.shade700,
  'CONTENT_MANAGER': Colors.pink,
  'GUEST': Colors.grey,
};

// ─────────────────────────────────────────────────────────────────────────────
// ROLE SWITCH BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────

class RoleSwitchSheet extends ConsumerWidget {
  const RoleSwitchSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const RoleSwitchSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleState = ref.watch(roleProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Switch Role Context',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'Active: ${roleState.activeRole ?? "None"}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              const Divider(height: 24),

              // Role list
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: roleState.roles.length,
                  itemBuilder: (context, index) {
                    final role = roleState.roles[index];
                    final isActive = role.name == roleState.activeRole;
                    final icon = _roleIcons[role.name] ?? Icons.person;
                    final color = _roleColors[role.name] ?? colorScheme.primary;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: isActive
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            ref.read(roleProvider.notifier).switchActiveRole(role.name);
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(icon, color: color, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        role.name.replaceAll('_', ' '),
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: isActive
                                                  ? colorScheme.onPrimaryContainer
                                                  : colorScheme.onSurface,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isActive)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Active',
                                      style: TextStyle(
                                        color: colorScheme.onPrimary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TENANT SWITCHER SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class TenantSwitcherScreen extends ConsumerWidget {
  final List<Map<String, dynamic>> availableTenants;

  const TenantSwitcherScreen({super.key, required this.availableTenants});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantState = ref.watch(tenantProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Switch Studio / Organization'),
        centerTitle: true,
      ),
      body: availableTenants.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.domain_disabled, size: 64, color: colorScheme.outlineVariant),
                  const SizedBox(height: 16),
                  Text(
                    'No organizations available',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: availableTenants.length,
              itemBuilder: (context, i) {
                final t = availableTenants[i];
                final isActive = tenantState.tenant?.id == t['id'];
                final branding = t['brandingJson'] as Map<String, dynamic>? ?? {};
                final logoUrl = branding['logoUrl'] as String?;
                final primaryColorHex = branding['primaryColor'] as String?;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    elevation: isActive ? 3 : 0,
                    borderRadius: BorderRadius.circular(20),
                    color: isActive
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerLow,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        ref.read(tenantProvider.notifier).setTenant(t);
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            // Logo
                            Container(
                              width: 56,
                              height: 56,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: colorScheme.surfaceContainerHighest,
                              ),
                              child: logoUrl != null
                                  ? Image.network(logoUrl, fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(Icons.store))
                                  : Icon(Icons.store, color: colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t['name'] as String? ?? 'Studio',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${t['plan'] ?? 'FREE'} Plan • ${t['status'] ?? 'ACTIVE'}',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            if (isActive)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check, size: 12, color: colorScheme.onPrimary),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Active',
                                      style: TextStyle(
                                        color: colorScheme.onPrimary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ORGANIZATION SELECTOR MODAL
// ─────────────────────────────────────────────────────────────────────────────

class OrganizationSelectorModal extends StatelessWidget {
  final List<Map<String, dynamic>> organizations;
  final String? selectedOrgId;
  final ValueChanged<Map<String, dynamic>> onSelected;

  const OrganizationSelectorModal({
    super.key,
    required this.organizations,
    this.selectedOrgId,
    required this.onSelected,
  });

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required List<Map<String, dynamic>> organizations,
    String? selectedOrgId,
  }) async {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => OrganizationSelectorModal(
        organizations: organizations,
        selectedOrgId: selectedOrgId,
        onSelected: (org) => Navigator.of(ctx).pop(org),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, controller) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.business),
                  const SizedBox(width: 12),
                  Text(
                    'Select Organization',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: organizations.length,
                itemBuilder: (context, i) {
                  final org = organizations[i];
                  final isSelected = org['id'] == selectedOrgId;
                  final type = org['type'] as String? ?? 'STUDIO';
                  final icon = type == 'CORPORATE' ? Icons.corporate_fare : Icons.store;

                  return ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    tileColor: isSelected ? colorScheme.primaryContainer : null,
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: colorScheme.secondary),
                    ),
                    title: Text(
                      org['name'] as String? ?? 'Organization',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${org['memberRole'] ?? org['type'] ?? 'Member'} • ${org['status'] ?? 'ACTIVE'}',
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: colorScheme.primary)
                        : const Icon(Icons.chevron_right),
                    onTap: () => onSelected(org),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
