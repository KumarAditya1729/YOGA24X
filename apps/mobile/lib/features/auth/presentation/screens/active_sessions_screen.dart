// ==============================================================================
// Yoga24X AI Engineering OS — Active Sessions & Device Management Dashboard
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/session_provider.dart';

class ActiveSessionsScreen extends ConsumerStatefulWidget {
  const ActiveSessionsScreen({super.key});

  @override
  ConsumerState<ActiveSessionsScreen> createState() => _ActiveSessionsScreenState();
}

class _ActiveSessionsScreenState extends ConsumerState<ActiveSessionsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(sessionNotifierProvider.notifier).loadSessionsAndDevices());
  }

  void _confirmRevokeAll() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Revoke All Other Sessions?'),
        content: const Text('You will be logged out from all other devices immediately. Your current session will remain active.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              ref.read(sessionNotifierProvider.notifier).revokeAllOtherSessions();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All other sessions revoked.')),
              );
            },
            child: const Text('Revoke All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(sessionNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Sessions & Devices'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(sessionNotifierProvider.notifier).loadSessionsAndDevices(),
          ),
        ],
      ),
      body: sessionState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : sessionState.errorMessage != null
              ? Center(child: Text('Error: ${sessionState.errorMessage}', style: const TextStyle(color: Colors.red)))
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ACTIVE SESSIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                        if (sessionState.sessions.length > 1)
                          TextButton.icon(
                            icon: const Icon(Icons.logout, size: 16, color: Colors.red),
                            label: const Text('Revoke All Other', style: TextStyle(color: Colors.red, fontSize: 13)),
                            onPressed: _confirmRevokeAll,
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...sessionState.sessions.map((session) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                        color: Colors.grey.shade50,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: session.isCurrentSession ? Colors.green.shade100 : Colors.blue.shade100,
                            child: Icon(
                              session.deviceType.contains('IOS') ? Icons.phone_iphone : Icons.phone_android,
                              color: session.isCurrentSession ? Colors.green : Colors.blue,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(session.deviceType, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              if (session.isCurrentSession)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                                  child: const Text('THIS DEVICE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('OS: ${session.osVersion} • App v${session.appVersion}'),
                              if (session.ipAddress != null) Text('IP: ${session.ipAddress}'),
                              Text('Last active: ${_formatDate(session.lastActiveAt)}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          trailing: session.isCurrentSession
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                                  onPressed: () => ref.read(sessionNotifierProvider.notifier).revokeSession(session.sessionId),
                                ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    const Text('TRUSTED DEVICES (2FA BYPASS)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 12),
                    if (sessionState.trustedDevices.isEmpty)
                      const Text('No trusted devices enrolled yet.', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                    ...sessionState.trustedDevices.map((device) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                        color: Colors.amber.shade50,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const CircleAvatar(
                            backgroundColor: Colors.amber,
                            child: Icon(Icons.security, color: Colors.white),
                          ),
                          title: Text(device.deviceName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Added on ${_formatDate(device.createdAt)}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => ref.read(sessionNotifierProvider.notifier).revokeTrustedDevice(device.deviceFingerprint),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
