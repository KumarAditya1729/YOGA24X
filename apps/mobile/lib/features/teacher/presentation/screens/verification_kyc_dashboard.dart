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
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                    onPressed: () => _showKycSubmissionSheet(context),
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Submit KYC Documents', style: TextStyle(fontWeight: FontWeight.bold)),
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

  void _showKycSubmissionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF161B22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Submit KYC Verification',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Select a government-issued identity document and enter your credential details for instant AI verification.',
              style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              dropdownColor: const Color(0xFF1F242D),
              initialValue: 'Aadhaar Card / VID',
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Document Type',
                labelStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF0D1117),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: ['Aadhaar Card / VID', 'Passport (International)', 'Permanent Account Number (PAN)', 'Driver License']
                  .map((doc) => DropdownMenuItem(value: doc, child: Text(doc)))
                  .toList(),
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Document ID Number',
                labelStyle: const TextStyle(color: Colors.white54),
                hintText: 'e.g. 8492-1049-5820',
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: const Color(0xFF0D1117),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF6C63FF).withValues(alpha: 0.4), style: BorderStyle.solid),
              ),
              child: const Column(
                children: [
                  Icon(Icons.cloud_upload_outlined, color: Color(0xFF6C63FF), size: 36),
                  SizedBox(height: 8),
                  Text('Upload Front & Back Photos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Supported formats: JPG, PNG, PDF (Max 10MB)', style: TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('KYC Documents submitted successfully! Undergoing instant AI biometric review.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Submit for AI Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
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
