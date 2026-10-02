import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';
import '../../models/models.dart';
import '../../repositories/pawly_repository.dart';

class WeightGrowthScreen extends StatefulWidget {
  final PawlyRepository repository;

  const WeightGrowthScreen({super.key, required this.repository});

  @override
  State<WeightGrowthScreen> createState() => _WeightGrowthScreenState();
}

class _WeightGrowthScreenState extends State<WeightGrowthScreen> {
  void _openAddWeightDialog() {
    final weightController = TextEditingController(
      text: widget.repository.activePet.weightKg.toString(),
    );
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Log New Weight', style: PawlyTypography.titleLarge),
            const SizedBox(height: 6),
            Text(
              'Record ${widget.repository.activePet.name}’s current weigh-in.',
              style: PawlyTypography.bodyMedium,
            ),
            const SizedBox(height: 20),
            const Text('Weight (kg) *', style: PawlyTypography.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              decoration: InputDecoration(
                hintText: '28.5',
                filled: true,
                fillColor: PawlyColors.surfaceWarm,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Note (optional)', style: PawlyTypography.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                hintText: 'e.g. Monthly vet weigh-in, post-grooming',
                filled: true,
                fillColor: PawlyColors.surfaceWarm,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
              ),
            ),
            const SizedBox(height: 24),
            PawlyButton(
              label: 'Save Weigh-in',
              isFullWidth: true,
              variant: PawlyButtonVariant.primary,
              onPressed: () {
                final w = double.tryParse(weightController.text.trim());
                if (w != null && w > 0) {
                  widget.repository.addWeightEntry(
                    WeightEntry(
                      id: 'w_${DateTime.now().millisecondsSinceEpoch}',
                      petId: widget.repository.activePet.id,
                      date: 'Today',
                      weightKg: w,
                      note: noteController.text.trim().isEmpty ? 'Regular check' : noteController.text.trim(),
                    ),
                  );
                  Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.repository.activePet;
    final history = widget.repository.activePetWeightHistory;

    double diff = 0.0;
    if (history.length >= 2) {
      diff = history[0].weightKg - history[1].weightKg;
    }

    return Scaffold(
      backgroundColor: PawlyColors.creamBg,
      appBar: AppBar(
        title: Text('${pet.name}’s Growth'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: _openAddWeightDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Weight Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: PawlyColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: PawlyColors.border, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CURRENT WEIGHT', style: PawlyTypography.labelSmall),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${pet.weightKg}',
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.2,
                            color: PawlyColors.espresso,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'KG',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: PawlyColors.mutedGrey,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: diff >= 0 ? PawlyColors.forestLight : PawlyColors.clayLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${diff >= 0 ? "+" : ""}${diff.toStringAsFixed(1)} kg from previous',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: diff >= 0 ? PawlyColors.forest : PawlyColors.clay,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Maintaining a healthy, steady weight for an adult ${pet.breed}.',
                      style: PawlyTypography.bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Restrained Custom Chart
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: PawlyColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: PawlyColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Weight Progression', style: PawlyTypography.titleMedium),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 110,
                      child: history.isNotEmpty
                          ? CustomPaint(
                              size: const Size(double.infinity, 110),
                              painter: _WeightChartPainter(entries: history.reversed.toList()),
                            )
                          : const Center(child: Text('Add weigh-ins to see growth curve')),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Historical Weigh-in List
              const Text('WEIGH-IN LOGS', style: PawlyTypography.labelSmall),
              const SizedBox(height: 10),

              ...history.map((entry) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: PawlyColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: PawlyColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PawlyColors.mutedGrey)),
                            const SizedBox(height: 2),
                            Text(entry.note, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: PawlyColors.espresso)),
                          ],
                        ),
                        Text(
                          '${entry.weightKg} kg',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: PawlyColors.forest,
                          ),
                        ),
                      ],
                    ),
                  )),

              const SizedBox(height: 24),

              PawlyButton(
                label: 'Record New Weight',
                icon: Icons.add,
                isFullWidth: true,
                variant: PawlyButtonVariant.primary,
                onPressed: _openAddWeightDialog,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  final List<WeightEntry> entries;

  _WeightChartPainter({required this.entries});

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) return;

    final linePaint = Paint()
      ..color = PawlyColors.forest
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()
      ..color = PawlyColors.forest
      ..style = PaintingStyle.fill;

    final minW = entries.map((e) => e.weightKg).reduce((a, b) => a < b ? a : b) - 0.5;
    final maxW = entries.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b) + 0.5;
    final range = (maxW - minW) == 0 ? 1.0 : (maxW - minW);

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < entries.length; i++) {
      final x = entries.length == 1 ? size.width / 2 : (i / (entries.length - 1)) * size.width;
      final normalizedY = (entries[i].weightKg - minW) / range;
      final y = size.height - (normalizedY * (size.height - 20)) - 10;
      final offset = Offset(x, y);
      points.add(offset);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);

    for (final p in points) {
      canvas.drawCircle(p, 5.0, pointPaint);
      canvas.drawCircle(p, 2.5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
