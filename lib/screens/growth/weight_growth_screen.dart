import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
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
  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.repository.removeListener(_refresh);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.repository.addListener(_refresh);
  }

  void _openAddWeightDialog() {
    final weightController = TextEditingController(
      text: widget.repository.activePet.weightKg.toString(),
    );
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SingleChildScrollView(
          child: Container(
        decoration: BoxDecoration(
          color: PawlyColors.resolve(context, PawlyColors.surface),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: PawlyColors.resolve(context, PawlyColors.border),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Log New Weight',
                style: PawlyTypography.resolve(
                    context, PawlyTypography.titleLarge)),
            const SizedBox(height: 4),
            Text(
              'Record ${widget.repository.activePet.name}’s current weigh-in.',
              style:
                  PawlyTypography.resolve(context, PawlyTypography.bodyMedium),
            ),
            const SizedBox(height: 16),
            Text('WEIGHT (KG)',
                style:
                    PawlyTypography.resolve(context, PawlyTypography.eyebrow)),
            const SizedBox(height: 6),
            TextField(
              controller: weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              style:
                  PawlyTypography.resolve(context, PawlyTypography.bodyLarge),
              decoration: InputDecoration(
                hintText: '28.5',
                filled: true,
                fillColor:
                    PawlyColors.resolve(context, PawlyColors.surfaceWarm),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                    borderRadius: AppTokens.rMd,
                    borderSide: BorderSide(
                        color:
                            PawlyColors.resolve(context, PawlyColors.border))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: AppTokens.rMd,
                    borderSide: BorderSide(
                        color:
                            PawlyColors.resolve(context, PawlyColors.border))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: AppTokens.rMd,
                    borderSide: BorderSide(
                        color: PawlyColors.resolve(context, PawlyColors.black),
                        width: 1.5)),
              ),
            ),
            const SizedBox(height: 14),
            Text('NOTE (OPTIONAL)',
                style:
                    PawlyTypography.resolve(context, PawlyTypography.eyebrow)),
            const SizedBox(height: 6),
            TextField(
              controller: noteController,
              style:
                  PawlyTypography.resolve(context, PawlyTypography.bodyLarge),
              decoration: InputDecoration(
                hintText: 'e.g. Monthly vet weigh-in, post-grooming',
                filled: true,
                fillColor:
                    PawlyColors.resolve(context, PawlyColors.surfaceWarm),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                    borderRadius: AppTokens.rMd,
                    borderSide: BorderSide(
                        color:
                            PawlyColors.resolve(context, PawlyColors.border))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: AppTokens.rMd,
                    borderSide: BorderSide(
                        color:
                            PawlyColors.resolve(context, PawlyColors.border))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: AppTokens.rMd,
                    borderSide: BorderSide(
                        color: PawlyColors.resolve(context, PawlyColors.black),
                        width: 1.5)),
              ),
            ),
            const SizedBox(height: 20),
            PawlyButton(
              text: 'Save Weigh-in',
              onPressed: () async {
                final w = double.tryParse(weightController.text.trim());
                if (w == null || !w.isFinite || w <= 0) {
                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                      content:
                          Text('Enter a valid weight greater than zero.')));
                  return;
                }
                if (w > 0) {
                  final now = DateTime.now();
                  const months = [
                    'Jan',
                    'Feb',
                    'Mar',
                    'Apr',
                    'May',
                    'Jun',
                    'Jul',
                    'Aug',
                    'Sep',
                    'Oct',
                    'Nov',
                    'Dec'
                  ];
                  final dateStr =
                      '${months[now.month - 1]} ${now.day.toString().padLeft(2, '0')}, ${now.year}';
                  await widget.repository.addWeightEntry(
                    WeightEntry(
                      id: 'w_${DateTime.now().millisecondsSinceEpoch}',
                      petId: widget.repository.activePet.id,
                      date: dateStr,
                      weightKg: w,
                      note: noteController.text.trim().isEmpty
                          ? 'Regular check'
                          : noteController.text.trim(),
                    ),
                  );
                  if (ctx.mounted) Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        ),
      )),
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
      backgroundColor: PawlyColors.resolve(context, PawlyColors.background),
      appBar: PawlyAppBar(
        title: '${pet.name}’s Growth',
        trailing: IconButton(
          icon: Icon(Icons.add,
              color: PawlyColors.resolve(context, PawlyColors.black), size: 20),
          onPressed: _openAddWeightDialog,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Weight Card (8px Card)
              PawlyCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CURRENT WEIGHT',
                        style: PawlyTypography.resolve(
                            context, PawlyTypography.eyebrow)),
                    const SizedBox(height: 8),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${pet.weightKg}',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.0,
                                color: PawlyColors.resolve(
                                    context, PawlyColors.black),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'KG',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: PawlyColors.resolve(
                                    context, PawlyColors.tertiary),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: PawlyColors.resolve(
                                context, PawlyColors.border),
                            borderRadius: AppTokens.rSm,
                            border: Border.all(
                                color: PawlyColors.resolve(
                                    context, PawlyColors.border),
                                width: 0.8),
                          ),
                          child: Text(
                            '${diff >= 0 ? "+" : ""}${diff.toStringAsFixed(1)} kg from previous',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: PawlyColors.resolve(
                                  context, PawlyColors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Maintaining a healthy, steady weight for an adult ${pet.breed}.',
                      style: PawlyTypography.resolve(
                          context, PawlyTypography.bodyMedium),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Restrained Custom Chart (8px Card)
              PawlyCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weight Progression',
                        style: PawlyTypography.resolve(
                            context, PawlyTypography.titleMedium)),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 110,
                      child: history.isNotEmpty
                          ? CustomPaint(
                              size: const Size(double.infinity, 110),
                              painter: _WeightChartPainter(
                                  entries: history.reversed.toList(),
                                  color: Theme.of(context).colorScheme.primary),
                            )
                          : Center(
                              child: Text(
                                'Add weigh-ins to see growth curve',
                                style: PawlyTypography.resolve(
                                    context, PawlyTypography.caption),
                              ),
                            ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Historical Weigh-in List
              Text('WEIGH-IN LOGS',
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.eyebrow)),
              const SizedBox(height: 8),

              ...history.map((entry) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: PawlyCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entry.date,
                                  style: PawlyTypography.resolve(
                                      context, PawlyTypography.caption)),
                              const SizedBox(height: 2),
                              Text(entry.note,
                                  style: PawlyTypography.resolve(
                                      context, PawlyTypography.titleSmall)),
                            ],
                          )),
                          Flexible(
                              child: Text(
                            '${entry.weightKg} kg',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: PawlyColors.resolve(
                                  context, PawlyColors.black),
                            ),
                          )),
                        ],
                      ),
                    ),
                  )),

              const SizedBox(height: 16),

              PawlyButton(
                text: 'Record New Weight',
                onPressed: _openAddWeightDialog,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  final List<WeightEntry> entries;

  final Color color;
  _WeightChartPainter({required this.entries, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) return;

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final minW =
        entries.map((e) => e.weightKg).reduce((a, b) => a < b ? a : b) - 0.5;
    final maxW =
        entries.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b) + 0.5;
    final range = (maxW - minW) == 0 ? 1.0 : (maxW - minW);

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < entries.length; i++) {
      final x = entries.length == 1
          ? size.width / 2
          : (i / (entries.length - 1)) * size.width;
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
      canvas.drawCircle(p, 4.0, pointPaint);
      canvas.drawCircle(p, 2.0, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
