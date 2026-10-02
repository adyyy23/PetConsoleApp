import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/widgets.dart';
import '../../repositories/pawly_repository.dart';
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
    if (hour < 12) return 'GOOD MORNING';
    if (hour < 18) return 'GOOD AFTERNOON';
    return 'GOOD EVENING';
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
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppTokens.xl)),
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
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
                    borderRadius: AppTokens.rXs,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Log Observation for ${repository.activePet.name}',
                style: PawlyTypography.titleMedium,
              ),
              const SizedBox(height: 16),
              const Text('Appetite', style: PawlyTypography.eyebrow),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: ['Good', 'Fair', 'Reduced', 'None'].map((val) {
                  final isSelected = appetite == val;
                  return ChoiceChip(
                    label: Text(val),
                    selected: isSelected,
                    selectedColor: PawlyColors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTokens.rSm,
                      side: BorderSide(color: isSelected ? PawlyColors.black : PawlyColors.border),
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : PawlyColors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    onSelected: (_) => setModalState(() => appetite = val),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              const Text('Energy Level', style: PawlyTypography.eyebrow),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: ['High', 'Normal', 'Lethargic'].map((val) {
                  final isSelected = energy == val;
                  return ChoiceChip(
                    label: Text(val),
                    selected: isSelected,
                    selectedColor: PawlyColors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTokens.rSm,
                      side: BorderSide(color: isSelected ? PawlyColors.black : PawlyColors.border),
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : PawlyColors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    onSelected: (_) => setModalState(() => energy = val),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  hintText: 'Any symptom notes or observations...',
                ),
              ),
              const SizedBox(height: 18),
              PawlyButton(
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
    final completedCount = petRoutines.where((r) => r.isCompleted).length;
    final totalCount = petRoutines.length;

    final nextPendingCare = petRoutines.where((r) => !r.isCompleted).isNotEmpty
        ? petRoutines.firstWhere((r) => !r.isCompleted)
        : null;

    final nextAppt = repository.activePetAppointments.where((a) => !a.isCompleted).toList();
    final upcomingAppt = nextAppt.isNotEmpty ? nextAppt.first : null;

    final recentWeight = repository.activePetWeightHistory.isNotEmpty
        ? repository.activePetWeightHistory.first
        : null;

    final recentMemory = repository.activePetMemories.isNotEmpty
        ? repository.activePetMemories.first
        : null;

    return Scaffold(
      backgroundColor: PawlyColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========================================================
              // TOP BAR: GREETING & APP TITLE + ACTIONS
              // ========================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_getGreeting()}, ${repository.user.name.toUpperCase()}',
                            style: PawlyTypography.eyebrow,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 2),
                          const Text('Pawly', style: PawlyTypography.displayMedium),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (repository.isLostPetModeEnabled)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: PawlyColors.border,
                              borderRadius: AppTokens.rXs,
                              border: Border.all(color: PawlyColors.error),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, size: 12, color: PawlyColors.error),
                                SizedBox(width: 4),
                                Text(
                                  'LOST MODE',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: PawlyColors.error),
                                ),
                              ],
                            ),
                          ),
                        IconButton(
                          icon:  const Icon(Icons.search_rounded, size: 22, color: PawlyColors.black),
                          onPressed: onOpenSearch,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon:  const Icon(Icons.calendar_month_outlined, size: 22, color: PawlyColors.black),
                          onPressed: onOpenCalendar,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ========================================================
              // PET SWITCHER (Clean Editorial Row)
              // ========================================================
              PetSwitcher(
                pets: repository.pets,
                selectedPetId: repository.selectedPetId,
                onSelectPet: (id) => repository.selectPet(id),
                onAddPet: onOpenAddPet,
              ),

              const SizedBox(height: 16),

              // ========================================================
              // LARGE FEATURED PET HERO (8-10px Radius, Editorial Dark Scrim)
              // ========================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => onOpenPetSpace(activePet.id),
                  child: Container(
                    height: 260,
                    decoration: BoxDecoration(
                      color: PawlyColors.black,
                      borderRadius: AppTokens.rLg,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Pet Photograph
                        Image.network(
                          activePet.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: PawlyColors.border,
                            child: const Center(
                              child: Icon(Icons.pets, size: 48, color: PawlyColors.black),
                            ),
                          ),
                        ),

                        // Controlled Dark Scrim for 100% WCAG Contrast
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.85),
                                ],
                                stops: const [0.3, 0.6, 1.0],
                              ),
                            ),
                          ),
                        ),

                        // Species Badge (Top-Left)
                        Positioned(
                          top: 14,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.65),
                              borderRadius: AppTokens.rXs,
                            ),
                            child: Text(
                              activePet.category.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // View Space Arrow (Top-Right)
                        Positioned(
                          top: 14,
                          right: 14,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.65),
                              borderRadius: AppTokens.rXs,
                            ),
                            child: const Icon(
                              Icons.arrow_outward_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Pet Editorial Details (Bottom)
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
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                  color: Colors.white,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${activePet.breed}  ·  ${activePet.ageYears.toStringAsFixed(activePet.ageYears.truncateToDouble() == activePet.ageYears ? 0 : 1)} years  ·  ${activePet.weightKg} kg',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              if (nextPendingCare != null) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.18),
                                    borderRadius: AppTokens.rXs,
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          'Next care: ${nextPendingCare.time} · ${nextPendingCare.title}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 11,
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

              const SizedBox(height: 24),

              // ========================================================
              // TODAY CARE SECTION (Editorial Hierarchy, Progress & Next Task)
              // ========================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('TODAY', style: PawlyTypography.eyebrow),
                          const SizedBox(height: 2),
                          Text(
                            '${activePet.name}’s Care',
                            style: PawlyTypography.titleMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onOpenCareTab,
                      child: Text(
                        '$completedCount of $totalCount completed',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: PawlyColors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              if (petRoutines.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppTokens.rMd,
                      border: Border.all(color: PawlyColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, size: 20, color: PawlyColors.black),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'No care routines scheduled for today.',
                            style: PawlyTypography.bodyMedium,
                          ),
                        ),
                        PawlyButton(
                          text: '+ Add',
                          isSmall: true,
                          onPressed: onOpenAddCare,
                        ),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: List.generate(
                      petRoutines.length > 3 ? 3 : petRoutines.length,
                      (idx) {
                        final routine = petRoutines[idx];
                        return CareTimelineItem(
                          time: routine.time,
                          title: routine.title,
                          subtitle: routine.notes.isNotEmpty
                              ? routine.notes
                              : '${routine.category.displayName} · ${routine.recurrence}',
                          isCompleted: routine.isCompleted,
                          assignedTo: routine.assignedTo,
                          onToggle: () => repository.toggleRoutine(routine.id),
                        );
                      },
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // ========================================================
              // QUICK ACTIONS (Clean 6-8px Buttons)
              // ========================================================
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('QUICK ACTIONS', style: PawlyTypography.eyebrow),
              ),
              const SizedBox(height: 8),

              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _ActionChip(
                      icon: Icons.add_circle_outline_rounded,
                      label: 'Add Care',
                      isPrimary: true,
                      onTap: onOpenAddCare,
                    ),
                    const SizedBox(width: 8),
                    _ActionChip(
                      icon: Icons.monitor_weight_outlined,
                      label: 'Log Weight',
                      onTap: onOpenWeight,
                    ),
                    const SizedBox(width: 8),
                    _ActionChip(
                      icon: Icons.edit_note_rounded,
                      label: 'Add Note',
                      onTap: () => _showAddObservationSheet(context),
                    ),
                    const SizedBox(width: 8),
                    _ActionChip(
                      icon: Icons.calendar_today_outlined,
                      label: 'Appointment',
                      onTap: onOpenAppointments,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ========================================================
              // UPCOMING: VET VISIT & CARE
              // ========================================================
              if (upcomingAppt != null) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('UPCOMING', style: PawlyTypography.eyebrow),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: onOpenAppointments,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppTokens.rMd,
                        border: Border.all(color: PawlyColors.border, width: 1.0),
                      ),
                      child: Row(
                        children: [
                          DateBubble(
                            month: () {
                              final parts = upcomingAppt.date.split('-');
                              if (parts.length >= 2) {
                                final m = int.tryParse(parts[1]) ?? 1;
                                const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
                                return months[(m - 1).clamp(0, 11)];
                              }
                              return 'APPT';
                            }(),
                            day: upcomingAppt.date.split('-').last,
                            color: PawlyColors.black,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  upcomingAppt.purpose,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: PawlyColors.black,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${upcomingAppt.time} · ${upcomingAppt.clinic}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: PawlyColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: PawlyColors.black),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ========================================================
              // RECENT MOMENTS / ACTIVITY (Dividers & Compact Rows)
              // ========================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text('RECENT ACTIVITY', style: PawlyTypography.eyebrow),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => onOpenPetSpace(activePet.id),
                      child: const Text(
                        'Pet Space',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: PawlyColors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppTokens.rMd,
                    border: Border.all(color: PawlyColors.border),
                  ),
                  child: Column(
                    children: [
                      if (recentWeight != null)
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: PawlyColors.border,
                              borderRadius: AppTokens.rSm,
                            ),
                            child: const Icon(Icons.monitor_weight_outlined, size: 18, color: PawlyColors.black),
                          ),
                          title: Text('Weight Check: ${recentWeight.weightKg} kg', style: PawlyTypography.titleSmall),
                          subtitle: Text('${recentWeight.date} · ${recentWeight.note}', style: PawlyTypography.caption),
                          trailing: const Icon(Icons.chevron_right, size: 18, color: PawlyColors.tertiary),
                          onTap: onOpenWeight,
                        ),

                      if (recentWeight != null && recentMemory != null)
                        const Divider(height: 1, indent: 56),

                      if (recentMemory != null)
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                          leading: ClipRRect(
                            borderRadius: AppTokens.rSm,
                            child: Image.network(
                              recentMemory.imageUrl,
                              width: 34,
                              height: 34,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 34,
                                height: 34,
                                color: PawlyColors.border,
                                child: const Icon(Icons.photo_outlined, size: 16),
                              ),
                            ),
                          ),
                          title: Text(recentMemory.title, style: PawlyTypography.titleSmall),
                          subtitle: Text('${recentMemory.date} · ${recentMemory.caption}', style: PawlyTypography.caption),
                          trailing: const Icon(Icons.chevron_right, size: 18, color: PawlyColors.tertiary),
                          onTap: () => onOpenPetSpace(activePet.id),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isPrimary ? PawlyColors.black : Colors.white,
          borderRadius: AppTokens.rSm,
          border: Border.all(
            color: isPrimary ? PawlyColors.black : PawlyColors.border,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isPrimary ? Colors.white : PawlyColors.black,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isPrimary ? Colors.white : PawlyColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
