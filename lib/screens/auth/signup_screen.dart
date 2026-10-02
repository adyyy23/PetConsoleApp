import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
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
      backgroundColor: PawlyColors.creamBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: widget.onNavigateToLogin,
        ),
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

              const SizedBox(height: 32),

              const Text('Your name', style: PawlyTypography.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g. Lady Liberty',
                  filled: true,
                  fillColor: PawlyColors.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                ),
              ),

              const SizedBox(height: 20),

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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                ),
              ),

              const SizedBox(height: 20),

              const Text('Password', style: PawlyTypography.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Create a password',
                  filled: true,
                  fillColor: PawlyColors.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                ),
              ),

              const SizedBox(height: 32),

              PawlyButton(
                label: 'Continue to Pet Setup',
                isFullWidth: true,
                variant: PawlyButtonVariant.primary,
                onPressed: widget.onSignupSuccess,
              ),

              const SizedBox(height: 24),

              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Already have an account? ', style: TextStyle(color: PawlyColors.warmGrey, fontSize: 14)),
                    GestureDetector(
                      onTap: widget.onNavigateToLogin,
                      child: const Text('Sign in', style: TextStyle(color: PawlyColors.forest, fontWeight: FontWeight.w700, fontSize: 14)),
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
