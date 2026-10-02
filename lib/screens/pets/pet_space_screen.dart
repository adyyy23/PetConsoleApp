import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/widgets.dart';
import '../../repositories/pawly_repository.dart';
import '../../models/models.dart';

class PetSpaceScreen extends StatefulWidget {
  final String petId;
  final PawlyRepository repository;
  final VoidCallback onBack;
  final VoidCallback onOpenAddCare;
  final VoidCallback onOpenAddHealth;
  final VoidCallback onOpenWeight;
  final VoidCallback onOpenVaccination;
  final VoidCallback onOpenMedication;
  final VoidCallback onOpenAppointments;
  final VoidCallback onOpenMemories;
  final VoidCallback onOpenDocuments;
  final VoidCallback onOpenEmergencyCard;

  const PetSpaceScreen({
    super.key,
    required this.petId,
    required this.repository,
    required this.onBack,
    required this.onOpenAddCare,
    required this.onOpenAddHealth,
    required this.onOpenWeight,
    required this.onOpenVaccination,
    required this.onOpenMedication,
    required this.onOpenAppointments,
    required this.onOpenMemories,
    required this.onOpenDocuments,
    required this.onOpenEmergencyCard,
  });

  @override
  State<PetSpaceScreen> createState() => _PetSpaceScreenState();
}

class _PetSpaceScreenState extends State<PetSpaceScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = const [
    'Overview',
    'Journey',
    'Care',
    'Health',
    'Passport',
    'Memories',
    'Documents'
  ];

  @override
  Widget build(BuildContext context) {
    final pet = widget.repository.pets.firstWhere(
      (p) => p.id == widget.petId,
      orElse: () => widget.repository.activePet,
    );

    final routines = widget.repository.allRoutines.where((r) => r.petId == pet.id).toList();
    final healthEvents = widget.repository.activePetHealthEvents;
    final memories = widget.repository.activePetMemories;
    final documents = widget.repository.activePetDocuments;
    final vaccines = widget.repository.activePetVaccinations;
    final milestones = widget.repository.activePetMilestones;

    return Scaffold(
      backgroundColor: PawlyColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero Collapsible Pet Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: PawlyColors.black,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: AppRadius.rSm,
                  border: Border.all(color: Colors.white24, width: 0.8),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
              ),
              onPressed: widget.onBack,
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: AppRadius.rSm,
                    border: Border.all(color: Colors.white24, width: 0.8),
                  ),
                  child: const Icon(Icons.shield_outlined, color: Colors.white, size: 18),
                ),
                onPressed: widget.onOpenEmergencyCard,
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    pet.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: PawlyColors.charcoal),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          Colors.black.withOpacity(0.85),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          pet.name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.6,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${pet.breed} • ${pet.ageYears.toStringAsFixed(1)} yrs • ${pet.weightKg} kg',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 0.2,
                          ),
                        ),
                        if (pet.nickname.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            '“${pet.nickname}”',
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Horizontal Space Navigation Tabs (Clean 6px editorial segments)
          SliverToBoxAdapter(
            child: Container(
              height: 42,
              margin: const EdgeInsets.only(top: 14, bottom: 8),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedTabIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTabIndex = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? PawlyColors.black : Colors.white,
                        borderRadius: AppRadius.rSm,
                        border: Border.all(
                          color: isSelected ? PawlyColors.black : PawlyColors.border,
                          width: 1.0,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _tabs[index],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? Colors.white : PawlyColors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ========================================================
          // TAB CONTENTS
          // ========================================================
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
            sliver: SliverToBoxAdapter(
              child: Builder(
                builder: (context) {
                  switch (_selectedTabIndex) {
                    // TAB 0: OVERVIEW & PERSONALITY
                    case 0:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pet Bio & Temperament
                          PawlyCard(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.info_outline_rounded, color: PawlyColors.black, size: 18),
                                    SizedBox(width: 8),
                                    Text('Personality & Temperament', style: PawlyTypography.titleMedium),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  pet.notes.isNotEmpty
                                      ? pet.notes
                                      : '${pet.name} is a beloved companion with a calm, loyal demeanor.',
                                  style: PawlyTypography.bodyLarge,
                                ),
                                if (pet.temperament.isNotEmpty) ...[
                                  const SizedBox(height: 14),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: pet.temperament.split(',').map((t) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: PawlyColors.softGrey,
                                          borderRadius: AppRadius.rSm,
                                          border: Border.all(color: PawlyColors.border, width: 0.8),
                                        ),
                                        child: Text(
                                          t.trim(),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: PawlyColors.black,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Loves & Not a Fan Of
                          PawlyCard(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('LOVES', style: PawlyTypography.eyebrow),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: (pet.likes.isNotEmpty
                                          ? pet.likes
                                          : const ['Salmon treats', 'Belly rubs', 'Morning park runs'])
                                      .map((item) => Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: PawlyColors.surfaceWarm,
                                              borderRadius: AppRadius.rSm,
                                              border: Border.all(color: PawlyColors.border, width: 0.8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.thumb_up_alt_outlined, size: 13, color: PawlyColors.black),
                                                const SizedBox(width: 6),
                                                Text(
                                                  item.trim(),
                                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: PawlyColors.black),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(height: 16),
                                const Text('THINGS TO AVOID', style: PawlyTypography.eyebrow),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: (pet.dislikes.isNotEmpty
                                          ? pet.dislikes
                                          : const ['Vacuum cleaner', 'Cold rain storms', 'Ear cleaning'])
                                      .map((item) => Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: PawlyColors.alertLight,
                                              borderRadius: AppRadius.rSm,
                                              border: Border.all(color: PawlyColors.alert.withOpacity(0.3), width: 0.8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.thumb_down_alt_outlined, size: 13, color: PawlyColors.alert),
                                                const SizedBox(width: 6),
                                                Text(
                                                  item.trim(),
                                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: PawlyColors.alert),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Fun Fact Callout Card
                          if (pet.funFact.isNotEmpty)
                            PawlyCard(
                              padding: const EdgeInsets.all(16),
                              backgroundColor: PawlyColors.surfaceWarm,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: PawlyColors.black,
                                      borderRadius: AppRadius.rSm,
                                    ),
                                    child: const Icon(Icons.lightbulb_outline_rounded, color: Colors.white, size: 16),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('FUN FACT', style: PawlyTypography.eyebrow),
                                        const SizedBox(height: 3),
                                        Text(pet.funFact, style: PawlyTypography.bodyMedium),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 14),

                          // Identification & Vitals
                          PawlyCard(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Vitals & Identification', style: PawlyTypography.titleMedium),
                                const SizedBox(height: 10),
                                _InfoRow(label: 'Species', value: pet.animalType),
                                _InfoRow(label: 'Breed', value: pet.breed),
                                _InfoRow(label: 'Sex', value: pet.gender),
                                _InfoRow(label: 'Weight', value: '${pet.weightKg} kg'),
                                _InfoRow(label: 'Allergies', value: pet.allergies, isAlert: pet.allergies != 'None reported'),
                                if (pet.microchipNumber.isNotEmpty)
                                  _InfoRow(label: 'Microchip', value: pet.microchipNumber),
                                if (pet.birthday.isNotEmpty)
                                  _InfoRow(label: 'Birthday', value: pet.birthday),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Emergency Pass Banner
                          GestureDetector(
                            onTap: widget.onOpenEmergencyCard,
                            child: const PawlyCard(
                              backgroundColor: PawlyColors.black,
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(Icons.shield_outlined, color: Colors.white, size: 22),
                                  SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Emergency Digital Pass',
                                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.white),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Instant clinic contacts, microchip, and allergy info',
                                          style: TextStyle(fontSize: 11, color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.chevron_right_rounded, color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );

                    // TAB 1: JOURNEY / MILESTONES
                    case 1:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${pet.name}’s Journey', style: PawlyTypography.titleMedium),
                              Text(
                                '${milestones.length} milestones',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PawlyColors.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...milestones.map((m) => Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: PawlyCard(
                                  padding: const EdgeInsets.all(14),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: PawlyColors.softGrey,
                                          borderRadius: AppRadius.rSm,
                                          border: Border.all(color: PawlyColors.border, width: 0.8),
                                        ),
                                        child: Text(
                                          m.year,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: PawlyColors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              m.title,
                                              style: PawlyTypography.titleSmall,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              m.subtitle,
                                              style: PawlyTypography.bodySmall,
                                            ),
                                            if (m.date.isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                m.date,
                                                style: PawlyTypography.caption,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      if (m.isAutomated)
                                        const Tooltip(
                                          message: 'Automated milestone',
                                          child: Icon(Icons.verified_outlined, size: 16, color: PawlyColors.black),
                                        ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      );

                    // TAB 2: CARE
                    case 2:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${pet.name}’s Care Routines', style: PawlyTypography.titleMedium),
                              TextButton(
                                onPressed: widget.onOpenAddCare,
                                child: const Text('+ Add Care', style: TextStyle(fontWeight: FontWeight.w700, color: PawlyColors.black)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (routines.isEmpty)
                            EmptyStateView(
                              icon: Icons.check_circle_outline,
                              title: 'No routines scheduled',
                              subtitle: 'Set up daily meals, walks, and medications.',
                              buttonLabel: 'Add Routine',
                              onButtonPressed: widget.onOpenAddCare,
                            )
                          else
                            ...routines.map((r) => Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: CareTimelineItem(
                                    time: r.time,
                                    title: r.title,
                                    subtitle: '${r.category.displayName} · ${r.recurrence}',
                                    isCompleted: r.isCompleted,
                                    assignedTo: r.assignedTo,
                                    onToggle: () => widget.repository.toggleRoutine(r.id),
                                  ),
                                )),
                        ],
                      );

                    // TAB 3: HEALTH
                    case 3:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Health Story', style: PawlyTypography.titleMedium),
                              TextButton(
                                onPressed: widget.onOpenAddHealth,
                                child: const Text('+ Log Event', style: TextStyle(fontWeight: FontWeight.w700, color: PawlyColors.black)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...healthEvents.map((h) => Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: PawlyCard(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          PawlyBadge(label: h.type),
                                          Text(h.date, style: PawlyTypography.caption),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(h.title, style: PawlyTypography.titleSmall),
                                      const SizedBox(height: 4),
                                      Text(h.notes, style: PawlyTypography.bodyMedium),
                                      const SizedBox(height: 8),
                                      Text('Vet: ${h.veterinarian}', style: PawlyTypography.caption),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      );

                    // TAB 4: PASSPORT
                    case 4:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Vaccination Passport', style: PawlyTypography.titleMedium),
                              TextButton(
                                onPressed: widget.onOpenVaccination,
                                child: const Text('View All', style: TextStyle(fontWeight: FontWeight.w700, color: PawlyColors.black)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...vaccines.map((v) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: PawlyCard(
                                  padding: const EdgeInsets.all(14),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(v.vaccineName, style: PawlyTypography.titleSmall),
                                            const SizedBox(height: 2),
                                            Text('Next Due: ${v.nextDueDate} • ${v.clinic}', style: PawlyTypography.bodySmall),
                                          ],
                                        ),
                                      ),
                                      PawlyBadge(
                                        label: v.status == VaccineStatus.current ? 'Current' : 'Due Soon',
                                        variant: v.status == VaccineStatus.current ? PawlyBadgeVariant.slate : PawlyBadgeVariant.alert,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      );

                    // TAB 5: MEMORIES
                    case 5:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Memories & Moments', style: PawlyTypography.titleMedium),
                              TextButton(
                                onPressed: widget.onOpenMemories,
                                child: const Text('+ Add Photo', style: TextStyle(fontWeight: FontWeight.w700, color: PawlyColors.black)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...memories.map((m) => Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                child: PawlyCard(
                                  padding: EdgeInsets.zero,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
                                        child: SizedBox(
                                          height: 180,
                                          width: double.infinity,
                                          child: Image.network(m.imageUrl, fit: BoxFit.cover),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(m.title, style: PawlyTypography.titleSmall),
                                                PawlyBadge(label: m.milestoneType),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(m.caption, style: PawlyTypography.bodyMedium),
                                            const SizedBox(height: 6),
                                            Text(m.date, style: PawlyTypography.caption),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      );

                    // TAB 6: DOCUMENTS
                    case 6:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Document Wallet', style: PawlyTypography.titleMedium),
                              TextButton(
                                onPressed: widget.onOpenDocuments,
                                child: const Text('+ Add File', style: TextStyle(fontWeight: FontWeight.w700, color: PawlyColors.black)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...documents.map((d) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: PawlyCard(
                                  padding: const EdgeInsets.all(14),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: PawlyColors.softGrey,
                                          borderRadius: AppRadius.rSm,
                                        ),
                                        child: const Icon(Icons.picture_as_pdf_outlined, color: PawlyColors.black, size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(d.title, style: PawlyTypography.titleSmall),
                                            Text('${d.category} • ${d.fileType}', style: PawlyTypography.bodySmall),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      );

                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isAlert;

  const _InfoRow({required this.label, required this.value, this.isAlert = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: PawlyTypography.bodyMedium),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isAlert ? PawlyColors.alert : PawlyColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
