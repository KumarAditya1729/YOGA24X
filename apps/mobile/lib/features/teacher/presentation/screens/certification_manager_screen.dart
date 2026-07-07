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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open add certification dialog (stubbed)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add Certification Dialog Coming Soon')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
