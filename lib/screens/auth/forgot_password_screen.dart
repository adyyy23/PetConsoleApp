import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
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
      backgroundColor: PawlyColors.background,
      appBar: PawlyAppBar(
        title: '',
        onBack: widget.onBackToLogin,
        showBottomBorder: false,
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

              const SizedBox(height: 28),

              if (_sent) ...[
                PawlyCard(
                  backgroundColor: PawlyColors.surfaceWarm,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: PawlyColors.black, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Reset Link Sent',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: PawlyColors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'We sent recovery instructions to ${_emailController.text.trim()}. Check your inbox or spam folder.',
                        style: PawlyTypography.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                PawlyButton(text: 'Back to Sign In',
                  
                  
                  onPressed: widget.onBackToLogin,
                ),
              ] else ...[
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
                    border: OutlineInputBorder(borderRadius: AppTokens.rMd, borderSide: const BorderSide(color: PawlyColors.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: AppTokens.rMd, borderSide: const BorderSide(color: PawlyColors.border)),
                    focusedBorder: OutlineInputBorder(borderRadius: AppTokens.rMd, borderSide: const BorderSide(color: PawlyColors.black, width: 1.5)),
                  ),
                ),
                const SizedBox(height: 24),
                PawlyButton(text: 'Send Recovery Email',
                  
                  
                  onPressed: () {
                    if (_emailController.text.trim().isNotEmpty) {
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
