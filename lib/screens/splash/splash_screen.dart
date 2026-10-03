import 'dart:async';
import 'package:flutter/material.dart';

/// A short pawprint arrival, with a static equivalent for reduced motion.
class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const SplashScreen({super.key, required this.onFinish});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _arrival = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1000));
  Timer? _finishTimer;
  @override
  void initState() {
    super.initState();
    _arrival.forward();
    _finishTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) widget.onFinish();
    });
  }

  @override
  void dispose() {
    _finishTimer?.cancel();
    _arrival.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
      AnimatedBuilder(
          animation: _arrival,
          builder: (context, _) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (index) {
                  final progress = MediaQuery.of(context).disableAnimations
                      ? 1.0
                      : ((_arrival.value - index * .2) * 2).clamp(0.0, 1.0);
                  return Padding(
                      padding: EdgeInsets.only(
                          left: 12, right: 12, bottom: index.isOdd ? 24 : 0),
                      child: Opacity(
                          opacity: progress,
                          child: Transform.scale(
                              scale: .7 + progress * .3,
                              child: Icon(Icons.pets,
                                  size: index == 1 ? 52 : 30,
                                  color: scheme.primary))));
                }),
              )),
      const SizedBox(height: 24),
      Text('Pawly',
          style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              color: scheme.onSurface)),
      const SizedBox(height: 8),
      Text('A little care. Every day.',
          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 16)),
      const SizedBox(height: 32),
      Text('Making room for their day',
          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
    ]))));
  }
}
