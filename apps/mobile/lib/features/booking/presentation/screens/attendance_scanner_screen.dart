import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/booking_providers.dart';

class AttendanceScannerScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const AttendanceScannerScreen({super.key, required this.bookingId});
  @override
  ConsumerState<AttendanceScannerScreen> createState() =>
      _AttendanceScannerScreenState();
}

class _AttendanceScannerScreenState
    extends ConsumerState<AttendanceScannerScreen> {
  bool _scanned = false;
  String _method = 'QR';
  final _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _doCheckIn({String? token}) async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(bookingRepositoryProvider)
          .checkIn(bookingId: widget.bookingId, method: _method, token: token);
      if (mounted) setState(() { _scanned = true; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Check-in failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('Check In', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _scanned
            ? const Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Icon(Icons.check_circle, color: Color(0xFF10B981), size: 80),
                  SizedBox(height: 16),
                  Text('Checked In Successfully!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ]))
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Select check-in method',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'QR', icon: Icon(Icons.qr_code_scanner), label: Text('QR')),
                    ButtonSegment(value: 'OTP', icon: Icon(Icons.pin), label: Text('OTP')),
                    ButtonSegment(value: 'MANUAL', icon: Icon(Icons.touch_app), label: Text('Manual')),
                  ],
                  selected: {_method},
                  onSelectionChanged: (v) => setState(() => _method = v.first),
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xFF1E2732))),
                ),
                const SizedBox(height: 32),
                if (_method == 'QR')
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2732),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: const Color(0xFF7C3AED), width: 2),
                        ),
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code_scanner,
                                  color: Color(0xFF7C3AED), size: 80),
                              SizedBox(height: 8),
                              Text('Tap to scan QR Code',
                                  style: TextStyle(color: Colors.grey)),
                            ]),
                      ),
                    ),
                  ),
                if (_method == 'OTP') ...[
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 24, letterSpacing: 8),
                    decoration: InputDecoration(
                      hintText: '000000',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: const Color(0xFF1E2732),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () => _doCheckIn(token: _otpController.text),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Verify OTP',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
                if (_method == 'MANUAL') ...[
                  const Text(
                      'Request manual attendance confirmation from your teacher.',
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _doCheckIn(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Mark Manual Attendance',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ]),
      ),
    );
  }
}
