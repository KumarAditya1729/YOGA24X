// ==============================================================================
// Yoga24X AI Engineering OS — Enterprise Login Screen
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_header.dart';
import '../widgets/oauth_button.dart';
import '../widgets/biometric_prompt_dialog.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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

    ref.listen<AuthState>(authStateNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: Colors.red),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeader(
                title: 'Welcome Back',
                subtitle: 'Sign in to access your AI Yoga Coach, live classes, and wellness community.',
              ),
              TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: const [
                  Tab(text: 'Password Login'),
                  Tab(text: 'OTP Login'),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 220,
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
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                            prefixIcon: const Icon(Icons.phone_android),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'We will send a 6-digit verification code to your phone or WhatsApp.',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_tabController.index == 0 ? 'Sign In' : 'Send Verification OTP'),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: _showBiometricPrompt,
                  icon: const Icon(Icons.fingerprint, size: 24),
                  label: const Text('Sign in with Biometric Passkey'),
                ),
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR CONTINUE WITH', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),
              OAuthButton(
                label: 'Continue with Google',
                icon: Icons.g_mobiledata,
                backgroundColor: Colors.white,
                textColor: Colors.black87,
                onPressed: () => ref.read(authStateNotifierProvider.notifier).loginWithGoogle('mock_google_token'),
              ),
              const SizedBox(height: 12),
              OAuthButton(
                label: 'Continue with Apple',
                icon: Icons.apple,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                onPressed: () => ref.read(authStateNotifierProvider.notifier).loginWithApple('mock_apple_token', 'mock_code'),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/auth/register'),
                    child: Text(
                      'Register Now',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
