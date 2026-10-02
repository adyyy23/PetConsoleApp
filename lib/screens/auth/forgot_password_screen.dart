import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final VoidCallback onBackToLogin;

  const ForgotPasswordScreen({super.key, required this.onBackToLogin});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PawlyColors.creamBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: widget.onBackToLogin,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Reset your\npassword.', style: PawlyTypography.displayMedium),
              const SizedBox(height: 8),
              const Text(
                'Enter the email address associated with your account, and we’ll send you password recovery instructions.',
                style: PawlyTypography.bodyLarge,
              ),

              const SizedBox(height: 32),

              if (_sent) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: PawlyColors.forestLight,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: PawlyColors.forestBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: PawlyColors.forest, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Reset Link Sent',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: PawlyColors.forest,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We sent recovery instructions to ${_emailController.text.trim()}. Check your inbox or spam folder.',
                        style: PawlyTypography.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                PawlyButton(
                  label: 'Back to Sign In',
                  isFullWidth: true,
                  variant: PawlyButtonVariant.primary,
                  onPressed: widget.onBackToLogin,
                ),
              ] else ...[
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
                  ),
                ),
                const SizedBox(height: 28),
                PawlyButton(
                  label: 'Send Recovery Email',
                  isFullWidth: true,
                  variant: PawlyButtonVariant.primary,
                  onPressed: () {
                    if (_emailController.text.isNotEmpty) {
                      setState(() => _sent = true);
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
