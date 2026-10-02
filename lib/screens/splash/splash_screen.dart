import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';

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
      backgroundColor: PawlyColors.creamBg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: PawlyColors.forest,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: PawlyColors.forest.withOpacity(0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.pets, size: 36, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Pawly', style: PawlyTypography.displayMedium),
            const SizedBox(height: 6),
            const Text(
              'Everything your pet needs',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: PawlyColors.warmGrey,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
