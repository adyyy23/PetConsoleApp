import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';
import '../../repositories/pawly_repository.dart';
import '../../models/care_routine.dart';
import '../../models/models.dart';

class HomeScreen extends StatelessWidget {
  final PawlyRepository repository;
  final VoidCallback onOpenAddPet;
  final VoidCallback onOpenAddCare;
  final VoidCallback onOpenCareTab;
  final VoidCallback onOpenHealthTab;
  final ValueChanged<String> onOpenPetSpace;
  final VoidCallback onOpenAppointments;
  final VoidCallback onOpenWeight;
  final VoidCallback? onOpenSearch;
  final VoidCallback? onOpenCalendar;

  const HomeScreen({
    super.key,
    required this.repository,
    required this.onOpenAddPet,
    required this.onOpenAddCare,
    required this.onOpenCareTab,
    required this.onOpenHealthTab,
    required this.onOpenPetSpace,
    required this.onOpenAppointments,
    required this.onOpenWeight,
    this.onOpenSearch,
    this.onOpenCalendar,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

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
    final petRoutines = repository.activePetRoutines;
    final wellness = repository.activePetWellness;

    final nextAppt = repository.activePetAppointments
        .where((a) => !a.isCompleted)
        .toList();
    final upcomingAppt = nextAppt.isNotEmpty ? nextAppt.first : null;

    final recentWeight = repository.activePetWeightHistory.isNotEmpty
        ? repository.activePetWeightHistory.first
        : null;

    final recentMemory = repository.activePetMemories.isNotEmpty
        ? repository.activePetMemories.first
        : null;

    final nextPendingCare = petRoutines.where((r) => !r.isCompleted).isNotEmpty
        ? petRoutines.firstWhere((r) => !r.isCompleted)
        : null;

    return Scaffold(
      backgroundColor: PawlyColors.creamBg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========================================================
              // TOP BAR GREETING, SEARCH, CALENDAR & PET SWITCHER
              // ========================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_getGreeting()}, ${repository.user.name}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: PawlyColors.warmGrey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text('Pawly Home', style: PawlyTypography.titleLarge),
                      ],
                    ),
                    Row(
                      children: [
                        if (repository.isLostPetModeEnabled)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: PawlyColors.roseLight,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: PawlyColors.rose),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, size: 14, color: PawlyColors.rose),
                                SizedBox(width: 4),
                                Text('Lost Mode', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: PawlyColors.rose)),
                              ],
                            ),
                          ),

                        // Search icon button
                        IconButton(
                          icon: const Icon(Icons.search_rounded, color: PawlyColors.espresso, size: 22),
                          onPressed: onOpenSearch,
                          visualDensity: VisualDensity.compact,
                        ),

                        // Calendar icon button
                        IconButton(
                          icon: const Icon(Icons.calendar_month_outlined, color: PawlyColors.forest, size: 22),
                          onPressed: onOpenCalendar,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Circular Pet Switcher: (Mochi) (Luna) (Milo) (+)
              PetSwitcher(
                pets: repository.pets,
                selectedPetId: repository.selectedPetId,
                onSelectPet: (id) => repository.selectPet(id),
                onAddPet: onOpenAddPet,
              ),

              const SizedBox(height: 16),

              // ========================================================
              // HERO VISUAL COMPOSITION: ACTIVE PET WITH TRANSLUCENT BUBBLES
              // ========================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => onOpenPetSpace(activePet.id),
                  child: Container(
                    height: 290,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: PawlyColors.espresso.withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Pet Photo
                          Image.network(
                            activePet.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: PawlyColors.surfaceWarm,
                              child: const Icon(Icons.pets, size: 60, color: PawlyColors.forest),
                            ),
                          ),

                          // Subtle darkening gradient for layered bubble contrast
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.2),
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.65),
                                  ],
                                  stops: const [0.0, 0.4, 1.0],
                                ),
                              ),
                            ),
                          ),

                          // Top-Left: Species / Category Badge
                          Positioned(
                            top: 16,
                            left: 16,
                            child: PhotoOverlayBubble(
                              child: Text(
                                activePet.category.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          // Top-Right: Pet Space Link Action
                          const Positioned(
                            top: 16,
                            right: 16,
                            child: PhotoOverlayBubble(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.arrow_outward_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Center-Right: Metric Bubbles (Weight & Age)
                          Positioned(
                            top: 60,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                PhotoOverlayBubble(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${activePet.weightKg} KG',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Text(
                                        'Healthy range',
                                        style: TextStyle(fontSize: 10, color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                PhotoOverlayBubble(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${activePet.ageYears.toStringAsFixed(activePet.ageYears.truncateToDouble() == activePet.ageYears ? 0 : 1)} YEARS',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        activePet.temperament.isNotEmpty
                                            ? activePet.temperament.split(',').first
                                            : 'Companion',
                                        style: const TextStyle(fontSize: 10, color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Bottom: Pet Name, Breed, and Next Care Overlaid Frosted Pill
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  activePet.name.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  activePet.breed,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                if (nextPendingCare != null) ...[
                                  const SizedBox(height: 10),
                                  PhotoOverlayBubble(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: PawlyColors.butterYellow,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            'Next care: ${nextPendingCare.time} · ${nextPendingCare.title}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
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
                ),
              ),

              const SizedBox(height: 20),

              // ========================================================
              // DAILY WELLNESS SNAPSHOT ROW
              // ========================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: MetricBubble(
                        label: 'WATER',
                        value: '${wellness.waterCupsDrank}/${wellness.waterCupsTarget}',
                        unit: 'cups',
                        color: PawlyColors.powderBlue,
                        icon: Icons.water_drop_outlined,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: MetricBubble(
                        label: 'MEALS',
                        value: '${wellness.mealsCompleted}/${wellness.mealsTarget}',
                        unit: 'fed',
                        color: PawlyColors.sageLight,
                        icon: Icons.restaurant_outlined,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: MetricBubble(
                        label: 'WALK',
                        value: '${wellness.walkMinutes}',
                        unit: 'min',
                        color: PawlyColors.butterYellow,
                        icon: Icons.directions_walk_rounded,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: MetricBubble(
                        label: 'MED',
                        value: '${wellness.medicationCompleted}/${wellness.medicationTarget}',
                        unit: 'doses',
                        color: PawlyColors.terracottaLight,
                        icon: Icons.medication_outlined,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ========================================================
              // CONTEXTUAL QUICK ACTION BUBBLES
              // ========================================================
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _QuickActionPill(
                      icon: Icons.add_circle_outline_rounded,
                      label: '+ Care',
                      onTap: onOpenAddCare,
                      isPrimary: true,
                    ),
                    const SizedBox(width: 8),
                    _QuickActionPill(
                      icon: Icons.monitor_weight_outlined,
                      label: '+ Weight',
                      onTap: onOpenWeight,
                    ),
                    const SizedBox(width: 8),
                    _QuickActionPill(
                      icon: Icons.edit_note_rounded,
                      label: '+ Note',
                      onTap: () => _showAddObservationSheet(context),
                    ),
                    const SizedBox(width: 8),
                    _QuickActionPill(
                      icon: Icons.calendar_today_outlined,
                      label: '+ Appointment',
                      onTap: onOpenAppointments,
                    ),
                    const SizedBox(width: 8),
                    _QuickActionPill(
                      icon: Icons.photo_library_outlined,
                      label: 'Memories',
                      onTap: () => onOpenPetSpace(activePet.id),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ========================================================
              // TODAY'S CARE TIMELINE
              // ========================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  title: 'Today’s Care Routine',
                  subtitle: 'Daily agenda for ${activePet.name}',
                  actionText: 'View All',
                  onAction: onOpenCareTab,
                ),
              ),

              const SizedBox(height: 12),

              if (petRoutines.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: PawlyBubble(
                    backgroundColor: PawlyColors.surfaceWarm,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: PawlyColors.forestLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: PawlyColors.forest, size: 20),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Text(
                            'No scheduled routines for today.',
                            style: PawlyTypography.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: List.generate(petRoutines.length, (idx) {
                      final routine = petRoutines[idx];
                      final isLast = idx == petRoutines.length - 1;

                      return CareTimelineItem(
                        time: routine.time,
                        title: routine.title,
                        subtitle: routine.notes.isNotEmpty
                            ? routine.notes
                            : '${routine.category.displayName} • ${routine.recurrence}',
                        isCompleted: routine.isCompleted,
                        isLast: isLast,
                        assignedTo: routine.assignedTo,
                        onToggle: () => repository.toggleRoutine(routine.id),
                      );
                    }),
                  ),
                ),

              const SizedBox(height: 24),

              // ========================================================
              // UPCOMING VET VISIT (Circular Date Block & Vet Prep)
              // ========================================================
              if (upcomingAppt != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'Upcoming Vet Visit',
                    subtitle: 'Preparation & notes ready',
                    actionText: 'Manage',
                    onAction: onOpenAppointments,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: onOpenAppointments,
                    child: PawlyBubble(
                      backgroundColor: PawlyColors.terracottaLight,
                      borderColor: PawlyColors.terracotta.withOpacity(0.3),
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          DateBubble(
                            month: 'OCT',
                            day: upcomingAppt.date.split('-').last,
                            color: PawlyColors.terracotta,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  upcomingAppt.purpose,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: PawlyColors.espresso,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${upcomingAppt.time} • ${upcomingAppt.clinic}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: PawlyColors.terracotta,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'With ${upcomingAppt.vetName} • Tap to view Vet Prep brief',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: PawlyColors.warmGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: PawlyColors.terracotta),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ========================================================
              // RECENT MOMENTS & GROWTH
              // ========================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  title: '${activePet.name}’s Highlights',
                  subtitle: 'Latest moments and tracking',
                  actionText: 'Pet Space',
                  onAction: () => onOpenPetSpace(activePet.id),
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    if (recentWeight != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: PawlyBubble(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: PawlyColors.butterYellow,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.monitor_weight_outlined, color: PawlyColors.espresso, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Current Weight: ${recentWeight.weightKg} kg',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: PawlyColors.espresso,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${recentWeight.date} • ${recentWeight.note}',
                                      style: const TextStyle(fontSize: 12, color: PawlyColors.warmGrey),
                                    ),
                                  ],
                                ),
                              ),
                              const PawlyBadge(label: 'Growth', variant: PawlyBadgeVariant.honey),
                            ],
                          ),
                        ),
                      ),

                    if (recentMemory != null)
                      PawlyBubble(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: PawlyColors.powderBlue,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.photo_library_outlined, color: PawlyColors.espresso, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recentMemory.title,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: PawlyColors.espresso,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${recentMemory.date} • ${recentMemory.caption}',
                                    style: const TextStyle(fontSize: 12, color: PawlyColors.warmGrey),
                                  ),
                                ],
                              ),
                            ),
                            PawlyBadge(label: recentMemory.milestoneType, variant: PawlyBadgeVariant.slate),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _QuickActionPill({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isPrimary ? PawlyColors.forest : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPrimary ? PawlyColors.forest : PawlyColors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isPrimary ? Colors.white : PawlyColors.espresso,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isPrimary ? Colors.white : PawlyColors.espresso,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
