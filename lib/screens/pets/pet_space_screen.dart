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
  final List<String> _tabs = const [
    'Personality',
    'Journey',
    'Care',
    'Health',
    'Passport',
    'Memories',
    'Wallet'
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
                        if (pet.nickname.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            '“${pet.nickname}”',
                            style: const TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: PawlyColors.butterYellow,
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

          // Horizontal Space Navigation Tabs
          SliverToBoxAdapter(
            child: Container(
              height: 48,
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
                    backgroundColor: Colors.white,
                    selectedColor: PawlyColors.forest,
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? Colors.white : PawlyColors.espresso,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? PawlyColors.forest : PawlyColors.border,
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
                    // TAB 0: PERSONALITY PROFILE
                    case 0:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pet Bio & Quote
                          PawlyBubble(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.favorite_rounded, color: PawlyColors.terracotta, size: 20),
                                    SizedBox(width: 8),
                                    Text('Personality & Temperament', style: PawlyTypography.titleMedium),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  pet.notes.isNotEmpty
                                      ? pet.notes
                                      : '${pet.name} is a beloved companion with a heart of gold.',
                                  style: PawlyTypography.bodyLarge,
                                ),
                                if (pet.temperament.isNotEmpty) ...[
                                  const SizedBox(height: 14),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: pet.temperament.split(',').map((t) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: PawlyColors.forestLight,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          t.trim(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: PawlyColors.forest,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Loves & Not a Fan Of
                          PawlyBubble(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('LOVES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: PawlyColors.forest, letterSpacing: 0.8)),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: (pet.likes.isNotEmpty
                                          ? pet.likes
                                          : const ['Salmon treats', 'Belly rubs', 'Morning park runs'])
                                      .map((item) => Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: PawlyColors.sageLight,
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.thumb_up_alt_outlined, size: 14, color: PawlyColors.forest),
                                                const SizedBox(width: 6),
                                                Text(
                                                  item.trim(),
                                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PawlyColors.forest),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(height: 18),
                                const Text('NOT A FAN OF', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: PawlyColors.terracotta, letterSpacing: 0.8)),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: (pet.dislikes.isNotEmpty
                                          ? pet.dislikes
                                          : const ['Vacuum cleaner', 'Cold rain storms', 'Ear cleaning'])
                                      .map((item) => Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: PawlyColors.terracottaLight,
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.thumb_down_alt_outlined, size: 14, color: PawlyColors.terracotta),
                                                const SizedBox(width: 6),
                                                Text(
                                                  item.trim(),
                                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PawlyColors.terracotta),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Fun Fact Callout Bubble
                          if (pet.funFact.isNotEmpty)
                            PawlyBubble(
                              backgroundColor: PawlyColors.honeyLight,
                              borderColor: PawlyColors.butterYellow,
                              padding: const EdgeInsets.all(18),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: PawlyColors.butterYellow,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.lightbulb_outline_rounded, color: PawlyColors.espresso, size: 20),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Fun Fact', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: PawlyColors.espresso)),
                                        const SizedBox(height: 4),
                                        Text(pet.funFact, style: const TextStyle(fontSize: 13, color: PawlyColors.espresso, height: 1.4)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 16),

                          // Identification & Vitals
                          PawlyBubble(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Vitals & Identification', style: PawlyTypography.titleMedium),
                                const SizedBox(height: 12),
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

                          // Emergency Pass Banner
                          GestureDetector(
                            onTap: widget.onOpenEmergencyCard,
                            child: const PawlyBubble(
                              backgroundColor: PawlyColors.forestLight,
                              borderColor: PawlyColors.forestBorder,
                              padding: EdgeInsets.all(18),
                              child: Row(
                                children: [
                                  Icon(Icons.shield_outlined, color: PawlyColors.forest),
                                  SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Emergency Digital Pass', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: PawlyColors.espresso)),
                                        SizedBox(height: 2),
                                        Text('Instant vet clinic, allergies, and contact pass', style: TextStyle(fontSize: 12, color: PawlyColors.warmGrey)),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.chevron_right_rounded, color: PawlyColors.forest),
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
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PawlyColors.forest),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ...milestones.map((m) => Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: PawlyBubble(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: PawlyColors.forestLight,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          m.year,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: PawlyColors.forest,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              m.title,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: PawlyColors.espresso,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              m.subtitle,
                                              style: const TextStyle(fontSize: 13, color: PawlyColors.warmGrey),
                                            ),
                                            if (m.date.isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                m.date,
                                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PawlyColors.mutedGrey),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      if (m.isAutomated)
                                        const Tooltip(
                                          message: 'Automated milestone',
                                          child: Icon(Icons.verified_outlined, size: 18, color: PawlyColors.forest),
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
                                  child: PawlyBubble(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.all(16),
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
                                child: const Text('+ Log Event', style: TextStyle(fontWeight: FontWeight.w700, color: PawlyColors.forest)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...healthEvents.map((h) => Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: PawlyBubble(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.all(16),
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
                                child: const Text('View All', style: TextStyle(fontWeight: FontWeight.w700, color: PawlyColors.forest)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...vaccines.map((v) => Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: PawlyBubble(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.all(16),
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
                                child: const Text('+ Add Photo', style: TextStyle(fontWeight: FontWeight.w700, color: PawlyColors.forest)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...memories.map((m) => Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: PawlyColors.espresso.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
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

                    // TAB 6: WALLET
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
                                child: const Text('+ Add File', style: TextStyle(fontWeight: FontWeight.w700, color: PawlyColors.forest)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...documents.map((d) => Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: PawlyBubble(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.picture_as_pdf_outlined, color: PawlyColors.terracotta, size: 28),
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
          Text(label, style: const TextStyle(fontSize: 14, color: PawlyColors.warmGrey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isAlert ? PawlyColors.terracotta : PawlyColors.espresso,
            ),
          ),
        ],
      ),
    );
  }
}
