import 'package:flutter/material.dart';
import '../../repositories/pawly_repository.dart';
import '../../widgets/widgets.dart';

class SignupScreen extends StatefulWidget {
  final PawlyRepository repository;
  final VoidCallback onSignupSuccess, onNavigateToLogin;
  const SignupScreen(
      {super.key,
      required this.repository,
      required this.onSignupSuccess,
      required this.onNavigateToLogin});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  String? _error;
  bool _saving = false;
  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          title: const Text('Your local profile'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onNavigateToLogin)),
      body: SafeArea(
          child: ListView(padding: const EdgeInsets.all(24), children: [
        const Text('Let’s make this yours.',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        const Text(
            'Pawly saves your pet care on this device. Start with your name.'),
        const SizedBox(height: 24),
        TextField(
            controller: _name,
            decoration:
                InputDecoration(labelText: 'Your name', errorText: _error)),
        const SizedBox(height: 24),
        PawlyButton(
            text: _saving ? 'Saving…' : 'Create my local profile',
            onPressed: () async {
              if (_saving) return;
              if (_name.text.trim().isEmpty) {
                setState(() => _error = 'Enter your name.');
                return;
              }
              setState(() => _saving = true);
              try {
                await widget.repository.updateUser(_name.text);
                if (mounted) widget.onSignupSuccess();
              } catch (_) {
                if (mounted) {
                  setState(() => _error = 'Couldn’t save. Please try again.');
                }
              } finally {
                if (mounted) setState(() => _saving = false);
              }
            }),
      ])));
}
