// ==============================================================================
// Yoga24X AI Engineering OS — 2026 Luxury Sanctuary Registration Portal
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with TickerProviderStateMixin {
  late AnimationController _ambientController;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'STUDENT';
  bool _obscurePassword = true;

  final List<Map<String, String>> _roles = [
    {
      'value': 'STUDENT',
      'label': 'Yoga Student',
      'desc': 'Learn yoga, track streaks, practice breathwork & book classes'
    },
    {
      'value': 'TEACHER',
      'label': 'Certified Yoga Teacher',
      'desc': 'Host live classes, publish LMS courses, and earn revenue'
    },
    {
      'value': 'DOCTOR',
      'label': 'Ayurveda / Medical Doctor',
      'desc': 'Provide clinical consultations and holistic prescriptions'
    },
    {
      'value': 'STUDIO_OWNER',
      'label': 'Yoga Studio Owner',
      'desc': 'Manage studio schedules, teachers, and memberships'
    },
  ];

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ambientController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authStateNotifierProvider.notifier).register(
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          password: _passwordController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          role: _selectedRole,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<AuthState>(authStateNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!,
                style: const TextStyle(fontFamily: 'Outfit')),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (next.status == AuthStatus.authenticated) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1311) : const Color(0xFFF4F7F5),
      body: Stack(
        children: [
          // 1. Animated Ambient Light Spheres (Sattvic Emerald & Champagne Gold)
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
                            const Color(0xFF385E4D)
                                .withValues(alpha: isDark ? 0.35 : 0.20),
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
                            const Color(0xFFC5A059)
                                .withValues(alpha: isDark ? 0.25 : 0.15),
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

          // 2. Main Scrollable Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top Back Button & Header
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF1B5E57),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC5A059)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: const Color(0xFFC5A059)
                                        .withValues(alpha: 0.4)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.auto_awesome,
                                      size: 14, color: Color(0xFFC5A059)),
                                  SizedBox(width: 6),
                                  Text(
                                    'VIP SANCTUARY PASS',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFC5A059),
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Luxury Sanctuary Logo & Title
                        Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF1B5E57)
                                      .withValues(alpha: 0.15),
                                  border: Border.all(
                                      color: const Color(0xFF385E4D)
                                          .withValues(alpha: 0.3),
                                      width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF1B5E57)
                                          .withValues(alpha: 0.2),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.self_improvement_rounded,
                                  size: 40,
                                  color: Color(0xFFC5A059),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Create Account',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1B5E57),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Join the Yoga24X AI wellness revolution. Choose your profile role below.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color: isDark
                                      ? Colors.white60
                                      : Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Section 1: Choose Role
                        Row(
                          children: [
                            const Icon(Icons.workspace_premium_rounded,
                                size: 18, color: Color(0xFFC5A059)),
                            const SizedBox(width: 8),
                            Text(
                              'SELECT YOUR SANCTUARY ROLE',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: isDark
                                    ? const Color(0xFFC5A059)
                                    : const Color(0xFF1B5E57),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Role Selection Cards
                        ..._roles.map((role) {
                          final isSelected = _selectedRole == role['value'];
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedRole = role['value']!),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutCubic,
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isSelected
                                    ? const Color(0xFF1B5E57)
                                        .withValues(alpha: isDark ? 0.25 : 0.12)
                                    : (isDark
                                        ? const Color(0xFF161F1A)
                                        : Colors.white),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFC5A059)
                                      : (isDark
                                          ? Colors.white12
                                          : Colors.grey.shade300),
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFFC5A059)
                                              .withValues(alpha: 0.2),
                                          blurRadius: 15,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.03),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? const Color(0xFFC5A059)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFFC5A059)
                                            : Colors.grey.shade500,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(Icons.check,
                                            size: 16, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          role['label']!,
                                          style: TextStyle(
                                            fontFamily: 'Outfit',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: isSelected
                                                ? (isDark
                                                    ? Colors.white
                                                    : const Color(0xFF1B5E57))
                                                : (isDark
                                                    ? Colors.white
                                                    : Colors.black87),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          role['desc']!,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: isDark
                                                ? Colors.white60
                                                : Colors.grey.shade600,
                                            fontSize: 13,
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                        const SizedBox(height: 24),

                        // Section 2: Personal Information
                        Row(
                          children: [
                            const Icon(Icons.person_outline_rounded,
                                size: 18, color: Color(0xFFC5A059)),
                            const SizedBox(width: 8),
                            Text(
                              'PERSONAL DETAILS',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: isDark
                                    ? const Color(0xFFC5A059)
                                    : const Color(0xFF1B5E57),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Name Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildLuxuryInput(
                                controller: _firstNameController,
                                label: 'First Name',
                                icon: Icons.person_outline,
                                isDark: isDark,
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildLuxuryInput(
                                controller: _lastNameController,
                                label: 'Last Name',
                                icon: Icons.person_outline,
                                isDark: isDark,
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Email
                        _buildLuxuryInput(
                          controller: _emailController,
                          label: 'Email Address',
                          icon: Icons.email_outlined,
                          isDark: isDark,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => v == null || !v.contains('@')
                              ? 'Valid email required'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Phone
                        _buildLuxuryInput(
                          controller: _phoneController,
                          label: 'Phone Number (Optional)',
                          icon: Icons.phone_outlined,
                          isDark: isDark,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),

                        // Password
                        _buildLuxuryInput(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          isDark: isDark,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xFFC5A059),
                              size: 20,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                          validator: (v) => v == null || v.length < 8
                              ? 'Min 8 characters required'
                              : null,
                        ),
                        const SizedBox(height: 32),

                        // 🌟 Create Account Button
                        GestureDetector(
                          onTap: authState.status == AuthStatus.loading
                              ? null
                              : _handleRegister,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1B5E57), Color(0xFF385E4D)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: const Color(0xFFC5A059)
                                      .withValues(alpha: 0.6),
                                  width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1B5E57)
                                      .withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: authState.status == AuthStatus.loading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2.5),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.auto_awesome,
                                            color: Color(0xFFC5A059), size: 20),
                                        SizedBox(width: 10),
                                        Text(
                                          'Create Sanctuary Account',
                                          style: TextStyle(
                                            fontFamily: 'Outfit',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Footer Login Link
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey.shade700,
                                ),
                                children: const [
                                  TextSpan(text: 'Already have a Sanctuary account? '),
                                  TextSpan(
                                    text: 'Sign In',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFC5A059),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLuxuryInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        fontFamily: 'Inter',
        color: isDark ? Colors.white : Colors.black87,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'Inter',
          color: isDark ? Colors.white60 : Colors.grey.shade600,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFFC5A059), size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor:
            isDark ? const Color(0xFF161F1A) : Colors.white.withValues(alpha: 0.9),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFC5A059), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
      ),
    );
  }
}
