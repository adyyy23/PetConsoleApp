import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
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
      backgroundColor: PawlyColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // App Brand Mark (8px)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: PawlyColors.black,
                  borderRadius: AppRadius.rMd,
                ),
                child: const Icon(Icons.pets, color: Colors.white, size: 22),
              ),
              const SizedBox(height: 24),
              const Text('Welcome\nback to Pawly.', style: PawlyTypography.displayMedium),
              const SizedBox(height: 8),
              const Text(
                'Sign in to check today’s care agenda, medical history, and appointments.',
                style: PawlyTypography.bodyLarge,
              ),

              const SizedBox(height: 28),

              // 1-Click Demo Login Box (8px Card)
              PawlyCard(
                backgroundColor: PawlyColors.surfaceWarm,
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Portfolio Demo',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: PawlyColors.black,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Jump straight into Lady’s household with preloaded pets & routines.',
                            style: PawlyTypography.caption,
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

              const SizedBox(height: 24),

              // Email Input
              const Text('EMAIL ADDRESS', style: PawlyTypography.eyebrow),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: PawlyTypography.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  hintStyle: PawlyTypography.bodyMedium,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.rMd,
                    borderSide: const BorderSide(color: PawlyColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.rMd,
                    borderSide: const BorderSide(color: PawlyColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadius.rMd,
                    borderSide: const BorderSide(color: PawlyColors.black, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Password Input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('PASSWORD', style: PawlyTypography.eyebrow),
                  Flexible(
                    child: GestureDetector(
                      onTap: widget.onNavigateToForgotPassword,
                      child: const Text(
                        'Forgot password?',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: PawlyColors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: PawlyTypography.bodyLarge,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: PawlyTypography.bodyMedium,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: PawlyColors.textMuted,
                      size: 18,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.rMd,
                    borderSide: const BorderSide(color: PawlyColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.rMd,
                    borderSide: const BorderSide(color: PawlyColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadius.rMd,
                    borderSide: const BorderSide(color: PawlyColors.black, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              PawlyButton(
                label: 'Sign in to Pawly',
                isFullWidth: true,
                onPressed: widget.onLoginSuccess,
                variant: PawlyButtonVariant.primary,
              ),

              const SizedBox(height: 24),

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'New to Pawly? ',
                      style: PawlyTypography.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: widget.onNavigateToSignup,
                      child: const Text(
                        'Create an account',
                        style: TextStyle(
                          color: PawlyColors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          decoration: TextDecoration.underline,
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
