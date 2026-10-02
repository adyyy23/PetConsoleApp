import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';
import '../../repositories/pawly_repository.dart';
import '../../models/care_routine.dart';

class HomeScreen extends StatelessWidget {
  final PawlyRepository repository;
  final VoidCallback onOpenAddPet;
  final VoidCallback onOpenAddCare;
  final VoidCallback onOpenCareTab;
  final VoidCallback onOpenHealthTab;
  final ValueChanged<String> onOpenPetSpace;
  final VoidCallback onOpenAppointments;
  final VoidCallback onOpenWeight;

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
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final activePet = repository.activePet;
    final petRoutines = repository.activePetRoutines;
    final pendingRoutines = petRoutines.where((r) => !r.isCompleted).toList();
    final completedRoutines = petRoutines.where((r) => r.isCompleted).toList();

    final nextAppt = repository.activePetAppointments
        .where((a) => !a.isCompleted)
        .toList();
    final upcomingAppt = nextAppt.isNotEmpty ? nextAppt.first : null;

    final recentHealth = repository.activePetHealthEvents.isNotEmpty
        ? repository.activePetHealthEvents.first
        : null;

    final recentWeight = repository.activePetWeightHistory.isNotEmpty
        ? repository.activePetWeightHistory.first
        : null;

    final recentMemory = repository.activePetMemories.isNotEmpty
        ? repository.activePetMemories.first
        : null;

    return Scaffold(
      backgroundColor: PawlyColors.creamBg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar Greeting & Switcher
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
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
                    if (repository.isLostPetModeEnabled)
                      Container(
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
                            Text('Lost Mode Active', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: PawlyColors.rose)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Multiple Pets Switcher Row
              PetSwitcher(
                pets: repository.pets,
                selectedPetId: repository.selectedPetId,
                onSelectPet: (id) => repository.selectPet(id),
                onAddPet: onOpenAddPet,
              ),

              const SizedBox(height: 18),

              // ========================================================
              // HERO VISUAL COMPOSITION: THE ACTIVE PET
              // ========================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => onOpenPetSpace(activePet.id),
                  child: Container(
                    height: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: PawlyColors.espresso.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
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

                          // Subtle Dark Gradient Overlay for text readability
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.1),
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.75),
                                  ],
                                  stops: const [0.0, 0.4, 1.0],
                                ),
                              ),
                            ),
                          ),

                          // Top Badges
                          Positioned(
                            top: 16,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Text(
                                activePet.category,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_outward_rounded,
                                size: 16,
                                color: PawlyColors.espresso,
                              ),
                            ),
                          ),

                          // Bottom Pet Info
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  activePet.name.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${activePet.breed} • ${activePet.ageYears.toStringAsFixed(activePet.ageYears.truncateToDouble() == activePet.ageYears ? 0 : 1)} years old • ${activePet.weightKg} kg',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.92),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ========================================================
              // TODAY'S CARE AGENDA (Timeline, not a table)
              // ========================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TODAY', style: PawlyTypography.labelSmall),
                        const SizedBox(height: 2),
                        Text(
                          '${activePet.name}’s Care Routine',
                          style: PawlyTypography.titleLarge,
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: onOpenAddCare,
                      icon: const Icon(Icons.add, size: 16, color: PawlyColors.forest),
                      label: const Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: PawlyColors.forest,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              if (pendingRoutines.isEmpty && completedRoutines.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: PawlyColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: PawlyColors.border),
                    ),
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
                            'No care routines scheduled for today.',
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
                    children: [
                      // Pending items
                      ...pendingRoutines.map((routine) => _CareAgendaCard(
                            routine: routine,
                            onToggle: () => repository.toggleRoutine(routine.id),
                          )),

                      // Completed items
                      ...completedRoutines.map((routine) => _CareAgendaCard(
                            routine: routine,
                            onToggle: () => repository.toggleRoutine(routine.id),
                          )),
                    ],
                  ),
                ),

              const SizedBox(height: 28),

              // ========================================================
              // NEXT UP: UPCOMING VET VISIT
              // ========================================================
              if (upcomingAppt != null) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('NEXT UP', style: PawlyTypography.labelSmall),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: onOpenAppointments,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: PawlyColors.forestLight,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: PawlyColors.forestBorder, width: 1.2),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: PawlyColors.forest,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 20),
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
                                const SizedBox(height: 2),
                                Text(
                                  '${upcomingAppt.date} · ${upcomingAppt.time}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: PawlyColors.forest,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${upcomingAppt.clinic} • ${upcomingAppt.vetName}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: PawlyColors.warmGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: PawlyColors.forest),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ],

              // ========================================================
              // MOCHI LATELY: RECENT UPDATES & MEMORIES
              // ========================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${activePet.name.toUpperCase()} LATELY',
                      style: PawlyTypography.labelSmall,
                    ),
                    GestureDetector(
                      onTap: () => onOpenPetSpace(activePet.id),
                      child: const Text(
                        'View Space',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: PawlyColors.forest,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Weight check card
                    if (recentWeight != null)
                      _LatelyTile(
                        icon: Icons.monitor_weight_outlined,
                        iconColor: PawlyColors.honey,
                        title: 'Current Weight: ${recentWeight.weightKg} kg',
                        subtitle: '${recentWeight.date} • ${recentWeight.note}',
                        badge: 'Growth',
                        badgeVariant: PawlyBadgeVariant.honey,
                        onTap: onOpenWeight,
                      ),

                    // Health event
                    if (recentHealth != null)
                      _LatelyTile(
                        icon: Icons.favorite_border_rounded,
                        iconColor: PawlyColors.clay,
                        title: recentHealth.title,
                        subtitle: '${recentHealth.date} • ${recentHealth.notes}',
                        badge: recentHealth.type,
                        badgeVariant: PawlyBadgeVariant.clay,
                        onTap: onOpenHealthTab,
                      ),

                    // Memory snapshot
                    if (recentMemory != null)
                      _LatelyTile(
                        icon: Icons.photo_library_outlined,
                        iconColor: PawlyColors.slate,
                        title: recentMemory.title,
                        subtitle: '${recentMemory.date} • ${recentMemory.caption}',
                        badge: recentMemory.milestoneType,
                        badgeVariant: PawlyBadgeVariant.slate,
                        onTap: () => onOpenPetSpace(activePet.id),
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

class _CareAgendaCard extends StatelessWidget {
  final CareRoutine routine;
  final VoidCallback onToggle;

  const _CareAgendaCard({required this.routine, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: routine.isCompleted ? PawlyColors.creamBg : PawlyColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: routine.isCompleted ? PawlyColors.borderLight : PawlyColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Native circular checkmark
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: routine.isCompleted ? PawlyColors.forest : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: routine.isCompleted ? PawlyColors.forest : PawlyColors.border,
                  width: 2,
                ),
              ),
              child: routine.isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 14),

          // Routine Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      routine.time,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: routine.isCompleted ? PawlyColors.mutedGrey : PawlyColors.forest,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•  ${routine.category.displayName}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: PawlyColors.mutedGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  routine.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    decoration: routine.isCompleted ? TextDecoration.lineThrough : null,
                    color: routine.isCompleted ? PawlyColors.mutedGrey : PawlyColors.espresso,
                  ),
                ),
                if (routine.notes.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    routine.notes,
                    style: TextStyle(
                      fontSize: 12,
                      color: routine.isCompleted ? PawlyColors.mutedGrey : PawlyColors.warmGrey,
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (routine.priority == 'High')
            const PawlyBadge(label: 'High', variant: PawlyBadgeVariant.alert),
        ],
      ),
    );
  }
}

class _LatelyTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String badge;
  final PawlyBadgeVariant badgeVariant;
  final VoidCallback onTap;

  const _LatelyTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeVariant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: PawlyColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: PawlyColors.border, width: 1),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: PawlyColors.espresso,
                              ),
                            ),
                          ),
                          PawlyBadge(label: badge, variant: badgeVariant),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: PawlyColors.warmGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
