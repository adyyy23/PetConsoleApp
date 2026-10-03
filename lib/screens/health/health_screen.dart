import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/widgets.dart';
import '../../repositories/pawly_repository.dart';
import '../../models/models.dart';

class HealthScreen extends StatelessWidget {
  final PawlyRepository repository;
  final VoidCallback onOpenAddHealthEvent;
  final VoidCallback onOpenWeight;
  final VoidCallback onOpenVaccination;
  final VoidCallback onOpenMedication;

  const HealthScreen({
    super.key,
    required this.repository,
    required this.onOpenAddHealthEvent,
    required this.onOpenWeight,
    required this.onOpenVaccination,
    required this.onOpenMedication,
  });

  void _showAddObservationSheet(BuildContext context) {
    String appetite = 'Good';
    String energy = 'Normal';
    String stool = 'Normal';
    String skin = 'Clear';
    final notesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => SingleChildScrollView(
            child: Container(
          decoration: BoxDecoration(
            color: PawlyColors.resolve(context, PawlyColors.surface),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(
              20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
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
              Text(
                'Log Observation for ${repository.activePet.name}',
                style: PawlyTypography.resolve(
                    context, PawlyTypography.titleMedium),
              ),
              const SizedBox(height: 14),
              Text('APPETITE',
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.eyebrow)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: ['Good', 'Fair', 'Reduced', 'None'].map((val) {
                  final isSelected = appetite == val;
                  return GestureDetector(
                    onTap: () => setModalState(() => appetite = val),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? PawlyColors.black : Colors.white,
                        borderRadius: AppTokens.rSm,
                        border: Border.all(
                          color: isSelected
                              ? PawlyColors.black
                              : PawlyColors.resolve(
                                  context, PawlyColors.border),
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        val,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : PawlyColors.resolve(context, PawlyColors.black),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Text('ENERGY LEVEL',
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.eyebrow)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: ['High', 'Normal', 'Lethargic'].map((val) {
                  final isSelected = energy == val;
                  return GestureDetector(
                    onTap: () => setModalState(() => energy = val),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? PawlyColors.black : Colors.white,
                        borderRadius: AppTokens.rSm,
                        border: Border.all(
                          color: isSelected
                              ? PawlyColors.black
                              : PawlyColors.resolve(
                                  context, PawlyColors.border),
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        val,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : PawlyColors.resolve(context, PawlyColors.black),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: notesController,
                style:
                    PawlyTypography.resolve(context, PawlyTypography.bodyLarge),
                decoration: InputDecoration(
                  hintText: 'Any symptom notes or observations...',
                  hintStyle: PawlyTypography.resolve(
                      context, PawlyTypography.bodyMedium),
                  filled: true,
                  fillColor:
                      PawlyColors.resolve(context, PawlyColors.surfaceWarm),
                  border: OutlineInputBorder(
                    borderRadius: AppTokens.rMd,
                    borderSide: BorderSide(
                        color:
                            PawlyColors.resolve(context, PawlyColors.border)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppTokens.rMd,
                    borderSide: BorderSide(
                        color:
                            PawlyColors.resolve(context, PawlyColors.border)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppTokens.rMd,
                    borderSide: BorderSide(
                        color: PawlyColors.resolve(context, PawlyColors.black),
                        width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: PawlyButton(
                  text: 'Save Observation Note',
                  onPressed: () async {
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
                    await repository.addSymptomNote(SymptomNote(
                      id: 'sym_${DateTime.now().millisecondsSinceEpoch}',
                      petId: repository.activePet.id,
                      date: dateStr,
                      appetite: appetite,
                      energy: energy,
                      stool: stool,
                      skin: skin,
                      notes: notesController.text.trim().isEmpty
                          ? ''
                          : notesController.text.trim(),
                    ));
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: repository, builder: (context, _) => _buildRecords(context));

  Widget _buildRecords(BuildContext context) {
    final activePet = repository.activePet;
    final events = repository.activePetHealthEvents;
    final symptomNotes = repository.activePetSymptomNotes;

    return Scaffold(
      backgroundColor: PawlyColors.resolve(context, PawlyColors.background),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'MEDICAL & WELLNESS • ${activePet.name.toUpperCase()}',
                              style: PawlyTypography.resolve(
                                  context, PawlyTypography.eyebrow),
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text('Health Records',
                              style: PawlyTypography.resolve(
                                  context, PawlyTypography.displayMedium),
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    PawlyButton(
                      text: '+ Log Event',
                      isSmall: true,
                      onPressed: onOpenAddHealthEvent,
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PetSwitcher(
                  pets: repository.pets,
                  selectedPetId: repository.selectedPetId,
                  onPetSelected: repository.selectPet,
                ),
              ),
            ),

            // Top Metric Cards (Weight, Passport, Medications - 8px cards)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickHealthShortcut(
                        icon: Icons.monitor_weight_outlined,
                        label: 'Weight',
                        value: '${activePet.weightKg} kg',
                        onTap: onOpenWeight,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _QuickHealthShortcut(
                        icon: Icons.shield_outlined,
                        label: 'Passport',
                        value:
                            '${repository.activePetVaccinations.length} Vaccines',
                        onTap: onOpenVaccination,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _QuickHealthShortcut(
                        icon: Icons.medication_outlined,
                        label: 'Meds',
                        value:
                            '${repository.activePetMedications.where((med) => med.isActive).length} Active',
                        onTap: onOpenMedication,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Daily Notes
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: SectionHeader(
                  eyebrow: 'WELLNESS JOURNAL',
                  title: 'Daily Notes',
                  action: TextButton(
                    onPressed: () => _showAddObservationSheet(context),
                    child: Text('+ Log Note',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: PawlyColors.resolve(
                                context, PawlyColors.black))),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: symptomNotes.map((note) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: PawlyCard(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    child: Row(
                                  children: [
                                    Icon(Icons.note_alt_outlined,
                                        size: 15,
                                        color: PawlyColors.resolve(
                                            context, PawlyColors.black)),
                                    const SizedBox(width: 6),
                                    Flexible(
                                        child: Text(
                                      note.date,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: PawlyColors.resolve(
                                            context, PawlyColors.black),
                                      ),
                                    )),
                                  ],
                                )),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
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
                                    'Energy: ${note.energy}',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: PawlyColors.resolve(
                                            context, PawlyColors.black)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(note.notes,
                                style: PawlyTypography.resolve(
                                    context, PawlyTypography.bodyLarge)),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              children: [
                                _SymptomPill(
                                    label: 'Appetite: ${note.appetite}'),
                                _SymptomPill(label: 'Stool: ${note.stool}'),
                                if (note.skin != 'Clear')
                                  _SymptomPill(
                                      label: 'Skin: ${note.skin}',
                                      isAlert: true),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Timeline Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text('CLINICAL & HEALTH STORY',
                    style: PawlyTypography.resolve(
                        context, PawlyTypography.eyebrow)),
              ),
            ),

            // Health Timeline
            if (events.isEmpty)
              SliverFillRemaining(
                child: EmptyStateView(
                  title: 'No health records yet',
                  subtitle:
                      'Keep a clean medical history of checkups, vaccines, and dosages.',
                  buttonLabel: 'Record First Event',
                  onButtonPressed: onOpenAddHealthEvent,
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = events[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: PawlyCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  StatusBadge(label: item.type),
                                  Flexible(
                                      child: Text(
                                    item.date,
                                    style: PawlyTypography.resolve(
                                        context, PawlyTypography.caption),
                                  )),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(item.title,
                                  style: PawlyTypography.resolve(
                                      context, PawlyTypography.titleSmall)),
                              const SizedBox(height: 4),
                              Text(item.notes,
                                  style: PawlyTypography.resolve(
                                      context, PawlyTypography.bodyMedium)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.verified_user_outlined,
                                      size: 13,
                                      color: PawlyColors.resolve(
                                          context, PawlyColors.black)),
                                  const SizedBox(width: 6),
                                  Flexible(
                                      child: Text(
                                    '${item.veterinarian}${item.clinic.isNotEmpty ? ' • ${item.clinic}' : ''}',
                                    style: PawlyTypography.resolve(
                                        context, PawlyTypography.caption),
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: events.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SymptomPill extends StatelessWidget {
  final String label;
  final bool isAlert;

  const _SymptomPill({required this.label, this.isAlert = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isAlert
            ? PawlyColors.resolve(context, PawlyColors.border)
            : PawlyColors.resolve(context, PawlyColors.border),
        borderRadius: AppTokens.rXs,
        border: Border.all(
          color: isAlert
              ? PawlyColors.resolve(context, PawlyColors.error).withOpacity(0.3)
              : PawlyColors.resolve(context, PawlyColors.border),
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isAlert
              ? PawlyColors.resolve(context, PawlyColors.error)
              : PawlyColors.resolve(context, PawlyColors.black),
        ),
      ),
    );
  }
}

class _QuickHealthShortcut extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _QuickHealthShortcut({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PawlyCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: PawlyColors.resolve(context, PawlyColors.border),
                borderRadius: AppTokens.rSm,
              ),
              child: Icon(icon,
                  size: 16,
                  color: PawlyColors.resolve(context, PawlyColors.black)),
            ),
            const SizedBox(height: 8),
            Text(
              label.toUpperCase(),
              style: PawlyTypography.resolve(context, PawlyTypography.eyebrow)
                  .copyWith(fontSize: 9),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: PawlyColors.resolve(context, PawlyColors.black),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
