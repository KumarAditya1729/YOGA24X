// ==============================================================================
// Yoga24X AI Engineering OS — 2026 Luxury Sanctuary Login Portal
// ==============================================================================

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import '../widgets/biometric_prompt_dialog.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _ambientController;
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _ambientController.dispose();
    _emailPhoneController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _handlePasswordLogin() {
    final identifier = _emailPhoneController.text.trim();
    final password = _passwordController.text;
    if (identifier.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email/phone and password')),
      );
      return;
    }
    ref.read(authStateNotifierProvider.notifier).loginWithPassword(
          emailOrPhone: identifier,
          password: password,
        );
  }

  void _handleOtpRequest() {
    final identifier = _emailPhoneController.text.trim();
    if (identifier.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number or email')),
      );
      return;
    }
    ref.read(authStateNotifierProvider.notifier).requestOtp(identifier, 'LOGIN_OTP');
  }

  void _showBiometricPrompt() {
    showDialog(
      context: context,
      builder: (_) => BiometricPromptDialog(
        onAuthenticate: () {
          Navigator.pop(context);
          ref.read(authStateNotifierProvider.notifier).loginWithBiometric(
                '00000000-0000-0000-0000-000000000001',
                'device_fp_101',
                'mock_signature_valid',
              );
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<AuthState>(authStateNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: Colors.redAccent),
        );
      } else if (next.status == AuthStatus.mfaRequired) {
        Navigator.pushNamed(context, '/auth/otp-verify', arguments: {
          'identifier': next.mfaIdentifier,
          'purpose': next.mfaPurpose,
        });
      } else if (next.status == AuthStatus.authenticated) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1311) : const Color(0xFFF4F7F5),
      body: Stack(
        children: [
          // 1. Animated Ambient Background Light Spheres
          AnimatedBuilder(
            animation: _ambientController,
            builder: (context, child) {
              final val = _ambientController.value;
              return Stack(
                children: [
                  Positioned(
                    top: -100 + (val * 40),
                    left: -50 - (val * 30),
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF385E4D).withValues(alpha: isDark ? 0.35 : 0.20),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50 - (val * 40),
                    right: -100 + (val * 30),
                    child: Container(
                      width: 450,
                      height: 450,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFC5A059).withValues(alpha: isDark ? 0.25 : 0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // 2. Main Login Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Luxury Sanctuary Header
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF1B5E57).withValues(alpha: 0.15),
                                border: Border.all(color: const Color(0xFF385E4D).withValues(alpha: 0.3), width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1B5E57).withValues(alpha: 0.2),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.self_improvement_rounded,
                                size: 44,
                                color: Color(0xFFC5A059),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'YOGA24X',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 4.0,
                                color: isDark ? Colors.white : const Color(0xFF1B5E57),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'SATTVIC SANCTUARY • 2026 AI COACHING',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0,
                                color: Color(0xFFC5A059),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),

                      // 🌟 INSTANT VIP SANCTUARY ACCESS (PRIMARY 2026 DEMO BUTTON)
                      GestureDetector(
                        onTap: () => ref.read(authStateNotifierProvider.notifier).loginAsDemoVipUser(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1B5E57), Color(0xFF385E4D)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFC5A059).withValues(alpha: 0.6), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1B5E57).withValues(alpha: 0.4),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC5A059).withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.auto_awesome, color: Color(0xFFC5A059), size: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '✨ Enter Sattvic Sanctuary',
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Instant VIP Guest Access • No credentials needed',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        color: Colors.white.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFC5A059), size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Frosted Glass Login Form Container
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.8),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                TabBar(
                                  controller: _tabController,
                                  labelColor: const Color(0xFFC5A059),
                                  unselectedLabelColor: Colors.grey,
                                  indicatorColor: const Color(0xFFC5A059),
                                  indicatorWeight: 3,
                                  labelStyle: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w700, fontSize: 15),
                                  tabs: const [
                                    Tab(text: 'Password'),
                                    Tab(text: 'OTP Login'),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  height: 210,
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      // Password Tab
                                      Column(
                                        children: [
                                          TextField(
                                            controller: _emailPhoneController,
                                            decoration: InputDecoration(
                                              labelText: 'Email or Phone Number',
                                              prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFFC5A059)),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                              filled: true,
                                              fillColor: isDark ? Colors.black26 : Colors.white54,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          TextField(
                                            controller: _passwordController,
                                            obscureText: _obscurePassword,
                                            decoration: InputDecoration(
                                              labelText: 'Password',
                                              prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFFC5A059)),
                                              suffixIcon: IconButton(
                                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                              ),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                              filled: true,
                                              fillColor: isDark ? Colors.black26 : Colors.white54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // OTP Tab
                                      Column(
                                        children: [
                                          TextField(
                                            controller: _emailPhoneController,
                                            decoration: InputDecoration(
                                              labelText: 'Phone Number (with country code)',
                                              prefixIcon: const Icon(Icons.phone_android_rounded, color: Color(0xFFC5A059)),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                              filled: true,
                                              fillColor: isDark ? Colors.black26 : Colors.white54,
                                            ),
                                            keyboardType: TextInputType.phone,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'We will send a secure 6-digit Prana verification code to your phone or WhatsApp.',
                                            style: TextStyle(color: Colors.grey[500], fontSize: 13, height: 1.4),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF385E4D),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                    ),
                                    onPressed: authState.status == AuthStatus.loading
                                        ? null
                                        : () {
                                            if (_tabController.index == 0) {
                                              _handlePasswordLogin();
                                            } else {
                                              _handleOtpRequest();
                                            }
                                          },
                                    child: authState.status == AuthStatus.loading
                                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                        : Text(
                                            _tabController.index == 0 ? 'Sign In' : 'Send Verification OTP',
                                            style: const TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.w700),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Biometric Passkey Button
                      Center(
                        child: TextButton.icon(
                          onPressed: _showBiometricPrompt,
                          icon: const Icon(Icons.fingerprint_rounded, size: 26, color: Color(0xFFC5A059)),
                          label: const Text(
                            'Sign in with Biometric Passkey',
                            style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFFC5A059)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey.withValues(alpha: 0.3))),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('OR CONTINUE WITH', style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                          ),
                          Expanded(child: Divider(color: Colors.grey.withValues(alpha: 0.3))),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Social Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildSocialPill(
                              icon: Icons.g_mobiledata_rounded,
                              label: 'Google',
                              color: isDark ? Colors.white10 : Colors.white,
                              textColor: isDark ? Colors.white : Colors.black87,
                              onTap: () => ref.read(authStateNotifierProvider.notifier).loginWithGoogle('mock_google_token'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSocialPill(
                              icon: Icons.apple,
                              label: 'Apple',
                              color: isDark ? Colors.white10 : Colors.black,
                              textColor: Colors.white,
                              onTap: () => ref.read(authStateNotifierProvider.notifier).loginWithApple('mock_apple_token', 'mock_code'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? ", style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/auth/register'),
                            child: const Text(
                              'Register Now',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Color(0xFFC5A059),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialPill({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: textColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w600, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
