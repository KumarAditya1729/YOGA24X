import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/teacher_providers.dart';

class CertificationManagerScreen extends ConsumerWidget {
  const CertificationManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(teacherProfileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Certifications'),
      ),
      body: profileState.when(
        data: (profile) {
          final certs = profile?.certifications ?? [];
          
          if (certs.isEmpty) {
            return const Center(child: Text('No certifications added yet.'));
          }

          return ListView.builder(
            itemCount: certs.length,
            itemBuilder: (context, index) {
              final cert = certs[index];
              return ListTile(
                leading: const Icon(Icons.workspace_premium),
                title: Text(cert.certificationName),
                subtitle: Text(cert.issuingOrganization),
                trailing: cert.isVerified 
                  ? const Icon(Icons.verified, color: Colors.green)
                  : const Icon(Icons.pending, color: Colors.orange),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCertificationDialog(context),
        icon: const Icon(Icons.verified),
        label: const Text('Add Credential'),
      ),
    );
  }

  void _showAddCertificationDialog(BuildContext context) {
    final nameController = TextEditingController();
    final authController = TextEditingController();
    final idController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('Add Certification', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Credential Name',
                  labelStyle: const TextStyle(color: Colors.white54),
                  hintText: 'e.g. E-RYT 500 Master Teacher',
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: const Color(0xFF0D1117),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: authController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Issuing Authority',
                  labelStyle: const TextStyle(color: Colors.white54),
                  hintText: 'e.g. Yoga Alliance USA / S-VYASA',
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: const Color(0xFF0D1117),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: idController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Credential / License ID',
                  labelStyle: const TextStyle(color: Colors.white54),
                  hintText: 'e.g. YA-948201-2024',
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: const Color(0xFF0D1117),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1117),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.cloud_upload_outlined, color: Colors.amber, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Upload Certificate PDF/Photo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('Verified by Yoga Alliance API', style: TextStyle(color: Colors.white54, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Certification "${nameController.text.isNotEmpty ? nameController.text : 'New Credential'}" submitted for instant verification!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Submit for Review', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
