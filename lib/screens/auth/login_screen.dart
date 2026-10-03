import 'package:flutter/material.dart';
import '../../repositories/pawly_repository.dart';
import '../../widgets/widgets.dart';

/// Pawly currently has local persistence, not a remote authentication service.
class LoginScreen extends StatefulWidget {
  final PawlyRepository repository;
  final VoidCallback onLoginSuccess,
      onNavigateToSignup,
      onNavigateToForgotPassword;
  final VoidCallback? onExploreDemo;
  const LoginScreen(
      {super.key,
      required this.repository,
      required this.onLoginSuccess,
      required this.onNavigateToSignup,
      required this.onNavigateToForgotPassword,
      this.onExploreDemo});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _name = TextEditingController(
      text: widget.repository.user.name == 'Pet parent'
          ? ''
          : widget.repository.user.name);
  bool _busy = false;
  String? _error;
  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_busy) return;
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'Tell us what to call you.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.repository.updateUser(_name.text);
      if (mounted) widget.onLoginSuccess();
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Couldn’t save your name. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    CircleAvatar(
                        radius: 30,
                        backgroundColor: scheme.primaryContainer,
                        child: Icon(Icons.pets,
                            size: 30, color: scheme.onPrimaryContainer)),
                    const SizedBox(height: 28),
                    const Text('Welcome\nback to Pawly.',
                        style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            height: 1.12)),
                    const SizedBox(height: 14),
                    const Text(
                        'A little home for your pet’s routines, health and favourite moments.',
                        style: TextStyle(fontSize: 17, height: 1.5)),
                    const SizedBox(height: 32),
                    TextField(
                        controller: _name,
                        textCapitalization: TextCapitalization.words,
                        autofillHints: const [AutofillHints.givenName],
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _continue(),
                        decoration: InputDecoration(
                            labelText: 'What should we call you?',
                            hintText: 'Your name',
                            errorText: _error)),
                    const SizedBox(height: 20),
                    PawlyButton(
                        text: _busy ? 'Saving…' : 'Open my Pawly',
                        onPressed: _continue),
                    const SizedBox(height: 16),
                    Text(
                        'Saved privately on this device. No password or online account is required.',
                        style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontSize: 13,
                            height: 1.5)),
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 24),
                    const Text('A peek before you begin',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(
                        widget.repository.pets.isEmpty
                            ? 'Explore an example pet family and their care routines.'
                            : 'Your pets are already here. Continue to see their care.',
                        style: TextStyle(
                            color: scheme.onSurfaceVariant, height: 1.5)),
                    const SizedBox(height: 16),
                    PawlyButton(
                        text: widget.repository.pets.isEmpty
                            ? 'Demo Enter'
                            : 'Continue with my pets',
                        isSecondary: true,
                        onPressed: () async {
                          if (_busy) return;
                          setState(() => _busy = true);
                          try {
                            await widget.repository.seedDemoData();
                            if (mounted) widget.onLoginSuccess();
                          } catch (_) {
                            if (mounted) {
                              setState(() => _error =
                                  'Couldn’t open the preview. Please try again.');
                            }
                          } finally {
                            if (mounted) setState(() => _busy = false);
                          }
                        }),
                  ],
                ))));
  }
}
