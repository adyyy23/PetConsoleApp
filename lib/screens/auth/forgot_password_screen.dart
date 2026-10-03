import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final VoidCallback onBackToLogin;
  const ForgotPasswordScreen({super.key, required this.onBackToLogin});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          title: const Text('Your saved Pawly'),
          leading: IconButton(
              tooltip: 'Back',
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackToLogin)),
      body: SafeArea(
          child: ListView(padding: const EdgeInsets.all(24), children: [
        const Icon(Icons.lock_outline, size: 40),
        const SizedBox(height: 24),
        const Text('Your care stays here.',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        const Text(
            'Pawly currently stores records on this device and does not use passwords or send recovery emails. Open your local profile to continue.',
            style: TextStyle(fontSize: 16, height: 1.6)),
        const SizedBox(height: 24),
        PawlyButton(text: 'Back to Pawly', onPressed: onBackToLogin),
      ])));
}
