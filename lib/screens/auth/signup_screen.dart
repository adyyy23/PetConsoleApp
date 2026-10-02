import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/widgets.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback onSignupSuccess;
  final VoidCallback onNavigateToLogin;

  const SignupScreen({
    super.key,
    required this.onSignupSuccess,
    required this.onNavigateToLogin,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PawlyColors.background,
      appBar: PawlyAppBar(
        title: '',
        onBack: widget.onNavigateToLogin,
        showBottomBorder: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create your\nPawly account.', style: PawlyTypography.displayMedium),
              const SizedBox(height: 8),
              const Text(
                'Join pet parents organizing daily routines, health records, and memories in one place.',
                style: PawlyTypography.bodyLarge,
              ),

              const SizedBox(height: 28),

              const Text('YOUR NAME', style: PawlyTypography.eyebrow),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                style: PawlyTypography.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'e.g. Lady Liberty',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: AppRadius.rMd, borderSide: const BorderSide(color: PawlyColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: AppRadius.rMd, borderSide: const BorderSide(color: PawlyColors.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: AppRadius.rMd, borderSide: const BorderSide(color: PawlyColors.black, width: 1.5)),
                ),
              ),

              const SizedBox(height: 18),

              const Text('EMAIL ADDRESS', style: PawlyTypography.eyebrow),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: PawlyTypography.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: AppRadius.rMd, borderSide: const BorderSide(color: PawlyColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: AppRadius.rMd, borderSide: const BorderSide(color: PawlyColors.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: AppRadius.rMd, borderSide: const BorderSide(color: PawlyColors.black, width: 1.5)),
                ),
              ),

              const SizedBox(height: 18),

              const Text('PASSWORD', style: PawlyTypography.eyebrow),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: PawlyTypography.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Create a password',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: AppRadius.rMd, borderSide: const BorderSide(color: PawlyColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: AppRadius.rMd, borderSide: const BorderSide(color: PawlyColors.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: AppRadius.rMd, borderSide: const BorderSide(color: PawlyColors.black, width: 1.5)),
                ),
              ),

              const SizedBox(height: 28),

              PawlyButton(
                label: 'Create Account',
                isFullWidth: true,
                onPressed: widget.onSignupSuccess,
                variant: PawlyButtonVariant.primary,
              ),

              const SizedBox(height: 24),

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text('Already have an account? ', style: PawlyTypography.bodyMedium),
                    GestureDetector(
                      onTap: widget.onNavigateToLogin,
                      child: const Text(
                        'Sign in',
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
