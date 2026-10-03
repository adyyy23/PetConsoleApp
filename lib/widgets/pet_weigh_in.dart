import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'widgets.dart';

/// A rendered 3D-style buddy with finite motion and the pet's saved measurement.
class PetWeighIn extends StatefulWidget {
  final Pet pet;
  final VoidCallback onLogWeight;
  const PetWeighIn({super.key, required this.pet, required this.onLogWeight});
  @override
  State<PetWeighIn> createState() => _PetWeighInState();
}

class _PetWeighInState extends State<PetWeighIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 420));
  Future<void> _play() async {
    if (MediaQuery.of(context).disableAnimations || _motion.isAnimating) return;
    await _motion.forward(from: 0);
    if (mounted) await _motion.reverse();
  }

  @override
  void didUpdateWidget(covariant PetWeighIn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pet.weightKg != widget.pet.weightKg ||
        oldWidget.pet.id != widget.pet.id) _play();
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  Widget _scaleImage(String illustration, bool cat, bool dog) => Semantics(
        button: true,
        label: 'Log ${widget.pet.name}’s weight',
        child: InkWell(
          onTap: () {
            _play();
            widget.onLogWeight();
          },
          borderRadius: BorderRadius.circular(20),
          child: LayoutBuilder(
              builder: (context, constraints) => Stack(children: [
                    Positioned.fill(
                        child: Image(
                            image: pawlyImageProvider(illustration),
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.pets_outlined, size: 60))),
                    if (cat || dog)
                      Positioned(
                        left: constraints.maxWidth * (cat ? .35 : .29),
                        top: constraints.maxHeight * (cat ? .825 : .80),
                        width: constraints.maxWidth * .185,
                        height: constraints.maxHeight * .065,
                        child: ExcludeSemantics(
                            child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color(0xFF202524),
                              borderRadius: BorderRadius.circular(3)),
                          child: FittedBox(
                              child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Text(
                                      widget.pet.weightKg.toStringAsFixed(1),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'monospace',
                                          fontWeight: FontWeight.w700)))),
                        )),
                      ),
                  ])),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cat = widget.pet.animalType.toLowerCase() == 'cat';
    final dog = widget.pet.animalType.toLowerCase() == 'dog';
    final illustration = cat
        ? 'assets/pets/weigh-cat.png'
        : dog
            ? 'assets/pets/weigh-dog.png'
            : widget.pet.imageUrl;
    return PawlyCard(
        padding: const EdgeInsets.all(18),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            PetAvatar(imageUrl: widget.pet.imageUrl, radius: 20),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('${widget.pet.name}’s weigh-in',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text('A little check on their growth',
                      style: TextStyle(
                          color: scheme.onSurfaceVariant, fontSize: 12)),
                ])),
          ]),
          const SizedBox(height: 8),
          Center(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: AnimatedBuilder(
                        animation: _motion,
                        child: _scaleImage(illustration, cat, dog),
                        builder: (context, child) {
                          final bounce = math.sin(_motion.value * math.pi);
                          return Transform(
                              alignment: Alignment.bottomCenter,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, .001)
                                ..rotateY(bounce * .08)
                                ..translate(0.0, -bounce * 7),
                              child: child);
                        }),
                  ))),
          const SizedBox(height: 8),
          Text('Tap the scale to record a weigh-in',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: scheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Shows the weight you have saved',
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 11)),
        ]));
  }
}
