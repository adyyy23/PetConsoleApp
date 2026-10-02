import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
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
        builder: (ctx, setModalState) => Container(
          decoration: const BoxDecoration(
            color: PawlyColors.surfaceWarm,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: PawlyColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Log Observation for ${repository.activePet.name}',
                style: PawlyTypography.titleMedium,
              ),
              const SizedBox(height: 16),
              const Text('Appetite', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PawlyColors.warmGrey)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: ['Good', 'Fair', 'Reduced', 'None'].map((val) {
                  final isSelected = appetite == val;
                  return ChoiceChip(
                    label: Text(val),
                    selected: isSelected,
                    selectedColor: PawlyColors.forest,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : PawlyColors.espresso,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    onSelected: (_) => setModalState(() => appetite = val),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              const Text('Energy Level', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PawlyColors.warmGrey)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: ['High', 'Normal', 'Lethargic'].map((val) {
                  final isSelected = energy == val;
                  return ChoiceChip(
                    label: Text(val),
                    selected: isSelected,
                    selectedColor: PawlyColors.forest,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : PawlyColors.espresso,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    onSelected: (_) => setModalState(() => energy = val),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                decoration: InputDecoration(
                  hintText: 'Any symptom notes or observations...',
                  hintStyle: const TextStyle(fontSize: 13, color: PawlyColors.mutedGrey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: PawlyColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: PawlyButton(
                  text: 'Save Observation Note',
                  onPressed: () {
                    repository.addSymptomNote(SymptomNote(
                      id: 'sym_${DateTime.now().millisecondsSinceEpoch}',
                      petId: repository.activePet.id,
                      date: 'Oct 02, 2026',
                      appetite: appetite,
                      energy: energy,
                      stool: stool,
                      skin: skin,
                      notes: notesController.text.trim().isEmpty
                          ? 'Observed normal behavior and good health.'
                          : notesController.text.trim(),
                    ));
                    Navigator.pop(ctx);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activePet = repository.activePet;
    final events = repository.activePetHealthEvents;
    final symptomNotes = repository.activePetSymptomNotes;

    return Scaffold(
      backgroundColor: PawlyColors.creamBg,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MEDICAL & WELLNESS • ${activePet.name.toUpperCase()}', style: PawlyTypography.labelSmall),
                        const SizedBox(height: 2),
                        Text('${activePet.name}’s Health Story', style: PawlyTypography.displayMedium),
                      ],
                    ),
                    PawlyButton(
                      text: '+ Log Event',
                      isSmall: true,
                      variant: PawlyButtonVariant.primary,
                      onPressed: onOpenAddHealthEvent,
                    ),
                  ],
                ),
              ),
            ),

            // Top Soft Metric Bubbles (Weight, Vaccines, Medications)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickHealthShortcut(
                        icon: Icons.monitor_weight_outlined,
                        color: PawlyColors.butterYellow,
                        label: 'Weight',
                        value: '${activePet.weightKg} kg',
                        onTap: onOpenWeight,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _QuickHealthShortcut(
                        icon: Icons.shield_outlined,
                        color: PawlyColors.softSage,
                        label: 'Passport',
                        value: '${repository.activePetVaccinations.length} Vaccines',
                        onTap: onOpenVaccination,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _QuickHealthShortcut(
                        icon: Icons.medication_outlined,
                        color: PawlyColors.powderBlue,
                        label: 'Medications',
                        value: '${repository.activePetMedications.length} Active',
                        onTap: onOpenMedication,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Daily Observations & Symptoms Journal
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: SectionHeader(
                  title: 'Daily Observations & Symptoms',
                  subtitle: 'Owner wellness notes & logs',
                  actionText: '+ Log Note',
                  onAction: () => _showAddObservationSheet(context),
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
                      child: PawlyBubble(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.note_alt_outlined, size: 16, color: PawlyColors.forest),
                                    const SizedBox(width: 6),
                                    Text(
                                      note.date,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: PawlyColors.forest,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: PawlyColors.forestLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Energy: ${note.energy}',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: PawlyColors.forest),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(note.notes, style: PawlyTypography.bodyLarge),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                _SymptomPill(label: 'Appetite: ${note.appetite}'),
                                _SymptomPill(label: 'Stool: ${note.stool}'),
                                if (note.skin != 'Clear')
                                  _SymptomPill(label: 'Skin: ${note.skin}', isAlert: true),
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
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text('CLINICAL & HEALTH STORY', style: PawlyTypography.labelSmall),
              ),
            ),

            // Health Timeline
            if (events.isEmpty)
              SliverFillRemaining(
                child: EmptyStateView(
                  icon: Icons.favorite_border,
                  title: 'No health records yet',
                  subtitle: 'Keep a clean medical history of checkups, vaccines, and dosages.',
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
                        margin: const EdgeInsets.only(bottom: 12),
                        child: PawlyBubble(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  PawlyBadge(label: item.type, variant: PawlyBadgeVariant.clay),
                                  Text(
                                    item.date,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: PawlyColors.mutedGrey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(item.title, style: PawlyTypography.titleMedium),
                              const SizedBox(height: 6),
                              Text(item.notes, style: PawlyTypography.bodyLarge),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.verified_user_outlined, size: 14, color: PawlyColors.forest),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${item.veterinarian}${item.clinic.isNotEmpty ? ' • ${item.clinic}' : ''}',
                                    style: const TextStyle(fontSize: 12, color: PawlyColors.warmGrey),
                                  ),
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
        color: isAlert ? PawlyColors.terracottaLight : PawlyColors.surfaceWarm,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isAlert ? PawlyColors.terracotta : PawlyColors.warmGrey,
        ),
      ),
    );
  }
}

class _QuickHealthShortcut extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _QuickHealthShortcut({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PawlyBubble(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: PawlyColors.espresso),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PawlyColors.warmGrey),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: PawlyColors.espresso),
            ),
          ],
        ),
      ),
    );
  }
}
