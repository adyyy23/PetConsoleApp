import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onNavigateToSignup;
  final VoidCallback onNavigateToForgotPassword;

  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
    required this.onNavigateToSignup,
    required this.onNavigateToForgotPassword,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: 'lady@pawly.app');
  final TextEditingController _passwordController =
      TextEditingController(text: 'pawly2026');
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PawlyColors.creamBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // App Brand Mark
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: PawlyColors.forest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.pets, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 24),
              const Text('Welcome\nback to Pawly.', style: PawlyTypography.displayMedium),
              const SizedBox(height: 8),
              const Text(
                'Sign in to check today’s care agenda, medical history, and appointments.',
                style: PawlyTypography.bodyLarge,
              ),

              const SizedBox(height: 32),

              // 1-Click Demo Login Box (for fast portfolio test)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: PawlyColors.forestLight,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: PawlyColors.forestBorder),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Portfolio Demo',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: PawlyColors.forest,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Jump straight into Lady’s household with preloaded pets & routines.',
                            style: TextStyle(
                              fontSize: 12,
                              color: PawlyColors.charcoal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    PawlyButton(
                      label: 'Demo Enter',
                      onPressed: widget.onLoginSuccess,
                      isSmall: true,
                      variant: PawlyButtonVariant.primary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Email Input
              const Text('Email address', style: PawlyTypography.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  filled: true,
                  fillColor: PawlyColors.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: PawlyColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: PawlyColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: PawlyColors.forest, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password Input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Password', style: PawlyTypography.labelLarge),
                  GestureDetector(
                    onTap: widget.onNavigateToForgotPassword,
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: PawlyColors.forest,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  filled: true,
                  fillColor: PawlyColors.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: PawlyColors.mutedGrey,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: PawlyColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: PawlyColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: PawlyColors.forest, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              PawlyButton(
                label: 'Sign in to Pawly',
                isFullWidth: true,
                onPressed: widget.onLoginSuccess,
                variant: PawlyButtonVariant.primary,
              ),

              const SizedBox(height: 28),

              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'New to Pawly? ',
                      style: TextStyle(color: PawlyColors.warmGrey, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: widget.onNavigateToSignup,
                      child: const Text(
                        'Create an account',
                        style: TextStyle(
                          color: PawlyColors.forest,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
