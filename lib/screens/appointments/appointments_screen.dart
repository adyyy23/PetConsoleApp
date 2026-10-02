import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../models/pet.dart';
import '../../repositories/pawly_repository.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';
import 'add_appointment_screen.dart';
import 'vet_visit_prep_screen.dart';

class AppointmentsScreen extends StatelessWidget {
  final PawlyRepository repository;

  const AppointmentsScreen({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        final pet = repository.selectedPet;
        final appointments = repository.appointmentsForPet(repository.selectedPetId);
        final upcoming = appointments.where((a) => !a.isCompleted).toList();
        final past = appointments.where((a) => a.isCompleted).toList();

        return Scaffold(
          backgroundColor: PawlyColors.background,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Custom Sliver App Bar
              SliverAppBar(
                backgroundColor: PawlyColors.surface,
                elevation: 0,
                pinned: true,
                expandedHeight: 120,
                leading: Navigator.canPop(context)
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: PawlyColors.textPrimary, size: 20),
                        onPressed: () => Navigator.pop(context),
                      )
                    : null,
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: PawlyColors.forest.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add_rounded, color: PawlyColors.forest, size: 20),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddAppointmentScreen(repository: repository),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  title: Text(
                    'Veterinary Visits',
                    style: PawlyTypography.titleMedium.copyWith(
                      color: PawlyColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              // Pet Switcher
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: PetSwitcher(
                    pets: repository.pets,
                    selectedPetId: repository.selectedPetId,
                    onPetSelected: repository.selectPet,
                  ),
                ),
              ),

              // Content
              if (appointments.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyStateView(
                    icon: Icons.calendar_today_rounded,
                    title: 'No Appointments Logged',
                    subtitle: 'Schedule routine exams, vaccinations, or dental checkups for ${pet?.name ?? 'your pet'}.',
                    actionLabel: 'Schedule Visit',
                    onAction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddAppointmentScreen(repository: repository),
                        ),
                      );
                    },
                  ),
                )
              else ...[
                // Upcoming Hero Section
                if (upcoming.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: PawlyColors.warmHoney, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'NEXT UPCOMING VISIT',
                            style: PawlyTypography.labelMedium.copyWith(
                              color: PawlyColors.textSecondary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _UpcomingVisitHeroCard(
                        appointment: upcoming.first,
                        pet: pet,
                        onPrepTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VetVisitPrepScreen(
                                repository: repository,
                                appointment: upcoming.first,
                              ),
                            ),
                          );
                        },
                        onMarkCompleted: () {
                          repository.toggleAppointmentCompleted(upcoming.first.id);
                        },
                      ),
                    ),
                  ),
                  if (upcoming.length > 1) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                        child: Text(
                          'OTHER SCHEDULED VISITS',
                          style: PawlyTypography.labelMedium.copyWith(
                            color: PawlyColors.textSecondary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = upcoming[index + 1];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            child: _AppointmentCard(
                              appointment: item,
                              onToggleComplete: () => repository.toggleAppointmentCompleted(item.id),
                              onPrepTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VetVisitPrepScreen(
                                      repository: repository,
                                      appointment: item,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        childCount: upcoming.length - 1,
                      ),
                    ),
                  ],
                ],

                // Past History Section
                if (past.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                      child: Text(
                        'PAST CONSULTATIONS',
                        style: PawlyTypography.labelMedium.copyWith(
                          color: PawlyColors.textSecondary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = past[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          child: _AppointmentCard(
                            appointment: item,
                            onToggleComplete: () => repository.toggleAppointmentCompleted(item.id),
                          ),
                        );
                      },
                      childCount: past.length,
                    ),
                  ),
                ],
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _UpcomingVisitHeroCard extends StatelessWidget {
  final Appointment appointment;
  final Pet? pet;
  final VoidCallback onPrepTap;
  final VoidCallback onMarkCompleted;

  const _UpcomingVisitHeroCard({
    required this.appointment,
    required this.pet,
    required this.onPrepTap,
    required this.onMarkCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PawlyColors.deepEspresso,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: PawlyColors.deepEspresso.withOpacity(0.16),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: PawlyColors.warmHoney.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time_rounded, color: PawlyColors.warmHoney, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '${appointment.date} • ${appointment.time}',
                      style: PawlyTypography.labelSmall.copyWith(
                        color: PawlyColors.warmHoney,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              PawlyBadge(
                label: 'Confirmed',
                backgroundColor: PawlyColors.forest.withOpacity(0.3),
                textColor: PawlyColors.forestLight,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            appointment.purpose,
            style: PawlyTypography.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${appointment.clinic} • ${appointment.vetName}',
            style: PawlyTypography.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          if (appointment.notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      appointment.notes,
                      style: PawlyTypography.bodySmall.copyWith(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: PawlyButton(
                  text: 'Visit Prep Checklist',
                  icon: Icons.checklist_rounded,
                  isSecondary: true,
                  onPressed: onPrepTap,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.all(14),
                ),
                tooltip: 'Mark Completed',
                icon: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                onPressed: onMarkCompleted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onToggleComplete;
  final VoidCallback? onPrepTap;

  const _AppointmentCard({
    required this.appointment,
    required this.onToggleComplete,
    this.onPrepTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PawlyColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PawlyColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: appointment.isCompleted
                  ? PawlyColors.border
                  : PawlyColors.forest.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              appointment.isCompleted ? Icons.check_circle_outline_rounded : Icons.local_hospital_rounded,
              color: appointment.isCompleted ? PawlyColors.textMuted : PawlyColors.forest,
              size: 24,
            ),
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
                        appointment.purpose,
                        style: PawlyTypography.titleSmall.copyWith(
                          color: appointment.isCompleted ? PawlyColors.textMuted : PawlyColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          decoration: appointment.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    Text(
                      appointment.date,
                      style: PawlyTypography.labelSmall.copyWith(
                        color: PawlyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${appointment.clinic} • ${appointment.vetName}',
                  style: PawlyTypography.bodySmall.copyWith(
                    color: PawlyColors.textSecondary,
                  ),
                ),
                if (!appointment.isCompleted && onPrepTap != null) ...[
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: onPrepTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.playlist_add_check_rounded, color: PawlyColors.forest, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Open Pre-Visit Prep',
                          style: PawlyTypography.labelSmall.copyWith(
                            color: PawlyColors.forest,
                            fontWeight: FontWeight.w600,
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
    );
  }
}
