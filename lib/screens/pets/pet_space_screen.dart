import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';
import '../../repositories/pawly_repository.dart';
import '../../models/care_routine.dart';
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
  final List<String> _tabs = const ['About', 'Care', 'Health', 'Passport', 'Memories', 'Wallet'];

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

    return Scaffold(
      backgroundColor: PawlyColors.creamBg,
      body: CustomScrollView(
        slivers: [
          // Hero Collapsible Pet Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
              ),
              onPressed: widget.onBack,
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emergency_outlined, color: Colors.white, size: 20),
                ),
                onPressed: widget.onOpenEmergencyCard,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    pet.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: PawlyColors.surfaceWarm),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
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
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.6,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${pet.breed} • ${pet.ageYears.toStringAsFixed(1)} years old • ${pet.weightKg} kg',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Horizontal Space Navigation Tabs
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              margin: const EdgeInsets.only(top: 14, bottom: 8),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedTabIndex;
                  return ChoiceChip(
                    label: Text(_tabs[index]),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedTabIndex = index),
                    backgroundColor: PawlyColors.surface,
                    selectedColor: PawlyColors.espresso,
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : PawlyColors.charcoal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: isSelected ? PawlyColors.espresso : PawlyColors.border,
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
                    // TAB 0: ABOUT
                    case 0:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SpaceCard(
                            title: 'About ${pet.name}',
                            child: Text(
                              pet.notes.isNotEmpty
                                  ? pet.notes
                                  : '${pet.name} is a cherished family member.',
                              style: PawlyTypography.bodyLarge,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SpaceCard(
                            title: 'Vitals & Identification',
                            child: Column(
                              children: [
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
                          const SizedBox(height: 16),
                          // Emergency Quick Action
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: PawlyColors.forestLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: PawlyColors.forestBorder),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.shield_outlined, color: PawlyColors.forest),
                                const SizedBox(width: 14),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Emergency Pet Card', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: PawlyColors.espresso)),
                                      SizedBox(height: 2),
                                      Text('Quick-show screen with clinic and allergy info', style: TextStyle(fontSize: 12, color: PawlyColors.charcoal)),
                                    ],
                                  ),
                                ),
                                PawlyButton(
                                  label: 'View',
                                  isSmall: true,
                                  variant: PawlyButtonVariant.primary,
                                  onPressed: widget.onOpenEmergencyCard,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );

                    // TAB 1: CARE
                    case 1:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${pet.name}’s Care Routines', style: PawlyTypography.titleMedium),
                              TextButton(
                                onPressed: widget.onOpenAddCare,
                                child: const Text('+ Add Care', style: TextStyle(fontWeight: FontWeight.w700, color: PawlyColors.forest)),
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
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: PawlyColors.surface,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: PawlyColors.border),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        r.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                                        color: r.isCompleted ? PawlyColors.forest : PawlyColors.mutedGrey,
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              r.title,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                decoration: r.isCompleted ? TextDecoration.lineThrough : null,
                                                color: r.isCompleted ? PawlyColors.mutedGrey : PawlyColors.espresso,
                                              ),
                                            ),
                                            Text(
                                              '${r.time} • ${r.category.displayName} • ${r.recurrence}',
                                              style: const TextStyle(fontSize: 12, color: PawlyColors.warmGrey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                        ],
                      );

                    // TAB 2: HEALTH
                    case 2:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Health Story', style: PawlyTypography.titleMedium),
                              TextButton(
                                onPressed: widget.onOpenAddHealth,
                                child: const Text('+ Log Event', style: TextStyle(fontWeight: FontWeight.w700, color: PawlyColors.forest)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...healthEvents.map((h) => Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: PawlyColors.surface,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: PawlyColors.border),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        PawlyBadge(label: h.type, variant: PawlyBadgeVariant.clay),
                                        Text(h.date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PawlyColors.mutedGrey)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(h.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: PawlyColors.espresso)),
                                    const SizedBox(height: 4),
                                    Text(h.notes, style: PawlyTypography.bodyMedium),
                                    const SizedBox(height: 8),
                                    Text('Vet: ${h.veterinarian}', style: const TextStyle(fontSize: 11, color: PawlyColors.mutedGrey)),
                                  ],
                                ),
                              )),
                        ],
                      );

                    // TAB 3: PASSPORT
                    case 3:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Vaccination Passport', style: PawlyTypography.titleMedium),
                              TextButton(
                                onPressed: widget.onOpenVaccination,
                                child: const Text('View All', style: TextStyle(fontWeight: FontWeight.w700, color: PawlyColors.forest)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...vaccines.map((v) => Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: PawlyColors.surface,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: PawlyColors.border),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(v.vaccineName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: PawlyColors.espresso)),
                                          const SizedBox(height: 2),
                                          Text('Next Due: ${v.nextDueDate} • ${v.clinic}', style: const TextStyle(fontSize: 12, color: PawlyColors.warmGrey)),
                                        ],
                                      ),
                                    ),
                                    PawlyBadge(
                                      label: v.status == VaccineStatus.current ? 'Current' : 'Due Soon',
                                      variant: v.status == VaccineStatus.current ? PawlyBadgeVariant.sage : PawlyBadgeVariant.honey,
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      );

                    // TAB 4: MEMORIES
                    case 4:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Memories & Milestones', style: PawlyTypography.titleMedium),
                              TextButton(
                                onPressed: widget.onOpenMemories,
                                child: const Text('+ Add Photo', style: TextStyle(fontWeight: FontWeight.w700, color: PawlyColors.forest)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...memories.map((m) => Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: PawlyColors.surface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: PawlyColors.border),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 180,
                                      width: double.infinity,
                                      child: Image.network(m.imageUrl, fit: BoxFit.cover),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(m.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: PawlyColors.espresso)),
                                              PawlyBadge(label: m.milestoneType, variant: PawlyBadgeVariant.slate),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(m.caption, style: PawlyTypography.bodyMedium),
                                          const SizedBox(height: 6),
                                          Text(m.date, style: const TextStyle(fontSize: 11, color: PawlyColors.mutedGrey)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      );

                    // TAB 5: WALLET
                    case 5:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Document Wallet', style: PawlyTypography.titleMedium),
                              TextButton(
                                onPressed: widget.onOpenDocuments,
                                child: const Text('+ Add File', style: TextStyle(fontWeight: FontWeight.w700, color: PawlyColors.forest)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...documents.map((d) => Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: PawlyColors.surface,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: PawlyColors.border),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.picture_as_pdf_outlined, color: PawlyColors.clay, size: 28),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(d.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: PawlyColors.espresso)),
                                          Text('${d.category} • ${d.fileType}', style: const TextStyle(fontSize: 12, color: PawlyColors.warmGrey)),
                                        ],
                                      ),
                                    ),
                                  ],
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

class _SpaceCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SpaceCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: PawlyColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: PawlyColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: PawlyTypography.titleMedium),
          const SizedBox(height: 12),
          child,
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
          Text(label, style: const TextStyle(fontSize: 14, color: PawlyColors.warmGrey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isAlert ? PawlyColors.clay : PawlyColors.espresso,
            ),
          ),
        ],
      ),
    );
  }
}
