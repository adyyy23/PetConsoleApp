import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const SplashScreen({super.key, required this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) widget.onFinish();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PawlyColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: PawlyColors.black,
                borderRadius: AppRadius.rMd,
              ),
              child: const Center(
                child: Icon(Icons.pets, size: 30, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Pawly', style: PawlyTypography.displayMedium),
            const SizedBox(height: 6),
            const Text(
              'Fetching today’s care...',
              style: PawlyTypography.caption,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: const LinearProgressIndicator(
                  minHeight: 2,
                  backgroundColor: PawlyColors.softGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(PawlyColors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
