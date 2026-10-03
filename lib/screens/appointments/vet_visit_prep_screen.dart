import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../repositories/pawly_repository.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';

class VetVisitPrepScreen extends StatefulWidget {
  final PawlyRepository repository;
  final Appointment appointment;

  const VetVisitPrepScreen({
    super.key,
    required this.repository,
    required this.appointment,
  });

  @override
  State<VetVisitPrepScreen> createState() => _VetVisitPrepScreenState();
}

class _VetVisitPrepScreenState extends State<VetVisitPrepScreen> {
  final _addItemController = TextEditingController();

  @override
  void dispose() {
    _addItemController.dispose();
    super.dispose();
  }

  void _addNewItem() {
    final text = _addItemController.text.trim();
    if (text.isEmpty) return;

    widget.repository.addVetPrepItem(
      VetPrepItem(
        id: 'prep_${DateTime.now().millisecondsSinceEpoch}',
        appointmentId: widget.appointment.id,
        text: text,
      ),
    );
    _addItemController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.repository,
      builder: (context, _) {
        final items =
            widget.repository.prepItemsForAppointment(widget.appointment.id);
        final completedCount = items.where((i) => i.isChecked).length;
        final progress = items.isEmpty ? 0.0 : (completedCount / items.length);

        return Scaffold(
          backgroundColor: PawlyColors.resolve(context, PawlyColors.background),
          appBar: AppBar(
            backgroundColor: PawlyColors.resolve(context, PawlyColors.surface),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: PawlyColors.resolve(context, PawlyColors.textPrimary),
                  size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Vet Visit Prep',
              style:
                  PawlyTypography.resolve(context, PawlyTypography.titleMedium)
                      .copyWith(
                fontWeight: FontWeight.w700,
                color: PawlyColors.resolve(context, PawlyColors.textPrimary),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: PawlyColors.black,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          StatusBadge(
                            label:
                                '${widget.appointment.date} • ${widget.appointment.time}',
                            backgroundColor: PawlyColors.resolve(
                                    context, PawlyColors.warmHoney)
                                .withOpacity(0.25),
                            textColor: PawlyColors.resolve(
                                context, PawlyColors.warmHoney),
                          ),
                          Text(
                            '$completedCount of ${items.length} Ready',
                            style: PawlyTypography.resolve(
                                    context, PawlyTypography.eyebrow)
                                .copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.appointment.purpose,
                        style: PawlyTypography.resolve(
                                context, PawlyTypography.titleMedium)
                            .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${widget.appointment.clinic} • ${widget.appointment.vetName}',
                        style: PawlyTypography.resolve(
                                context, PawlyTypography.bodyMedium)
                            .copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor:
                              PawlyColors.resolve(context, PawlyColors.surface)
                                  .withOpacity(0.15),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              PawlyColors.resolve(
                                  context, PawlyColors.surfaceWarm)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Checklist Title
                Text(
                  'PRE-CONSULTATION CHECKLIST',
                  style: PawlyTypography.resolve(
                          context, PawlyTypography.labelMedium)
                      .copyWith(
                    color: PawlyColors.resolve(context, PawlyColors.secondary),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 12),

                // Items list
                ...items.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: PawlyColors.resolve(context, PawlyColors.surface),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: item.isChecked
                            ? PawlyColors.resolve(context, PawlyColors.black)
                                .withOpacity(0.2)
                            : PawlyColors.resolve(context, PawlyColors.border),
                      ),
                    ),
                    child: CheckboxListTile(
                      value: item.isChecked,
                      onChanged: (_) =>
                          widget.repository.toggleVetPrepItem(item.id),
                      activeColor:
                          PawlyColors.resolve(context, PawlyColors.black),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 4),
                      title: Text(
                        item.text,
                        style: PawlyTypography.resolve(
                                context, PawlyTypography.bodyMedium)
                            .copyWith(
                          decoration: item.isChecked
                              ? TextDecoration.lineThrough
                              : null,
                          color: item.isChecked
                              ? PawlyColors.resolve(
                                  context, PawlyColors.tertiary)
                              : PawlyColors.resolve(
                                  context, PawlyColors.textPrimary),
                          fontWeight: item.isChecked
                              ? FontWeight.normal
                              : FontWeight.w500,
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  );
                }),

                const SizedBox(height: 14),

                // Add item input
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _addItemController,
                        onSubmitted: (_) => _addNewItem(),
                        decoration: const InputDecoration(
                          hintText: 'Add question or reminder...',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor:
                            PawlyColors.resolve(context, PawlyColors.black),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.add_rounded),
                      onPressed: _addNewItem,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Vet visit pro-tips
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: PawlyColors.resolve(context, PawlyColors.warmHoney)
                        .withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color:
                            PawlyColors.resolve(context, PawlyColors.warmHoney)
                                .withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_rounded,
                              color: PawlyColors.resolve(
                                  context, PawlyColors.warmHoney),
                              size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Vet Visit Tip',
                            style: PawlyTypography.resolve(
                                    context, PawlyTypography.titleSmall)
                                .copyWith(
                              color: PawlyColors.resolve(
                                  context, PawlyColors.deepEspresso),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Take short video clips of any unusual behavior, cough, or gait at home. Pets often act adrenaline-energized at the clinic and mask subtle symptoms.',
                        style: PawlyTypography.resolve(
                                context, PawlyTypography.bodyMedium)
                            .copyWith(
                          color: PawlyColors.resolve(
                                  context, PawlyColors.deepEspresso)
                              .withOpacity(0.8),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
