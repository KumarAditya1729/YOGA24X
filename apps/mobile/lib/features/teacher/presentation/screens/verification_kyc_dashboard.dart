import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/teacher_providers.dart';

class VerificationKycDashboard extends ConsumerWidget {
  const VerificationKycDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verificationState = ref.watch(teacherVerificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Verification'),
      ),
      body: verificationState.when(
        data: (verif) {
          final status = verif?.status ?? 'NOT_SUBMITTED';
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        _buildStatusIcon(status),
                        const SizedBox(height: 16),
                        Text(
                          'Verification Status: $status',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getStatusMessage(status),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (status == 'NOT_SUBMITTED' || status == 'REJECTED')
                  FilledButton(
                    onPressed: () {
                      // Navigate to submit form (stubbed)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Verification Submission Form Coming Soon')),
                      );
                    },
                    child: const Text('Submit KYC Documents'),
                  ),
                  
                if (status == 'REJECTED' && verif?.rejectionReason != null)
                  Card(
                    color: Colors.red.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Reason: ${verif?.rejectionReason}', style: const TextStyle(color: Colors.red)),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    switch (status) {
      case 'APPROVED':
        return const Icon(Icons.verified, size: 64, color: Colors.green);
      case 'PENDING':
      case 'UNDER_REVIEW':
        return const Icon(Icons.hourglass_bottom, size: 64, color: Colors.orange);
      case 'REJECTED':
        return const Icon(Icons.error, size: 64, color: Colors.red);
      default:
        return const Icon(Icons.shield_outlined, size: 64, color: Colors.grey);
    }
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'APPROVED':
        return 'Your identity and certifications have been verified. You can now teach classes on Yoga24X!';
      case 'PENDING':
        return 'Your documents are currently in the queue. We will review them shortly.';
      case 'UNDER_REVIEW':
        return 'Our team is actively reviewing your documents.';
      case 'REJECTED':
        return 'Your verification was rejected. Please review the reason below and submit again.';
      default:
        return 'Submit your Government ID and Yoga Certifications to get verified.';
    }
  }
}
