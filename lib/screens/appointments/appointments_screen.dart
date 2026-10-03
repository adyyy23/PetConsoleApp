import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/care_schedule.dart';
import '../../models/models.dart';
import '../../repositories/pawly_repository.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
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
        final appointments =
            repository.appointmentsForPet(repository.selectedPetId);
        final upcoming = appointments.where((a) => !a.isCompleted).toList()
          ..sort((a, b) => (CareSchedule.parseDate(a.date) ?? DateTime(1900))
              .compareTo(CareSchedule.parseDate(b.date) ?? DateTime(1900)));
        final past = appointments.where((a) => a.isCompleted).toList();

        return Scaffold(
          backgroundColor: PawlyColors.resolve(context, PawlyColors.background),
          appBar: PawlyAppBar(
            title: 'Veterinary Visits',
            trailing: IconButton(
              icon: Icon(Icons.add,
                  color: PawlyColors.resolve(context, PawlyColors.black),
                  size: 20),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddAppointmentScreen(repository: repository),
                  ),
                );
              },
            ),
          ),
          body: CustomScrollView(
            slivers: [
              // Pet Switcher (Editorial Tab Style)
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
                    title: 'No Appointments Logged',
                    subtitle:
                        'Schedule routine exams, vaccinations, or dental checkups for ${pet?.name ?? 'your pet'}.',
                    actionLabel: 'Schedule Visit',
                    onAction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddAppointmentScreen(repository: repository),
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
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text('NEXT UPCOMING VISIT',
                          style: PawlyTypography.resolve(
                              context, PawlyTypography.eyebrow)),
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
                          repository
                              .toggleAppointmentCompleted(upcoming.first.id);
                        },
                      ),
                    ),
                  ),
                  if (upcoming.length > 1) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                        child: Text('OTHER SCHEDULED VISITS',
                            style: PawlyTypography.resolve(
                                context, PawlyTypography.eyebrow)),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = upcoming[index + 1];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 4),
                            child: _AppointmentCard(
                              appointment: item,
                              onToggleComplete: () => repository
                                  .toggleAppointmentCompleted(item.id),
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
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
                      child: Text('PAST CONSULTATIONS',
                          style: PawlyTypography.resolve(
                              context, PawlyTypography.eyebrow)),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = past[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          child: _AppointmentCard(
                            appointment: item,
                            onToggleComplete: () =>
                                repository.toggleAppointmentCompleted(item.id),
                          ),
                        );
                      },
                      childCount: past.length,
                    ),
                  ),
                ],
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
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
    // Parse date parts for editorial date block
    final date = CareSchedule.parseDate(appointment.date);
    final month = date == null ? 'VISIT' : DateFormat('MMM').format(date);
    final day = date == null ? '' : date.day.toString();

    return PawlyCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Clean Date Block (8px)
              Container(
                width: 52,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: PawlyColors.black,
                  borderRadius: AppTokens.rSm,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      month.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      day.isNotEmpty ? day : '•',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        Text(
                          appointment.time,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color:
                                PawlyColors.resolve(context, PawlyColors.black),
                          ),
                        ),
                        const StatusBadge(label: 'Confirmed'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment.purpose,
                      style: PawlyTypography.resolve(
                          context, PawlyTypography.titleMedium),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${appointment.clinic} • ${appointment.vetName}',
                      style: PawlyTypography.resolve(
                          context, PawlyTypography.bodyMedium),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (appointment.notes.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: PawlyColors.resolve(context, PawlyColors.surfaceWarm),
                borderRadius: AppTokens.rSm,
                border: Border.all(
                    color: PawlyColors.resolve(context, PawlyColors.border),
                    width: 0.8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: PawlyColors.resolve(context, PawlyColors.black),
                      size: 15),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      appointment.notes,
                      style: PawlyTypography.resolve(
                          context, PawlyTypography.bodyMedium),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PawlyButton(
                  text: 'Visit Prep Checklist',
                  isSecondary: true,
                  onPressed: onPrepTap,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor:
                      PawlyColors.resolve(context, PawlyColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTokens.rSm,
                    side: BorderSide(
                        color:
                            PawlyColors.resolve(context, PawlyColors.border)),
                  ),
                  padding: const EdgeInsets.all(12),
                ),
                tooltip: 'Mark Completed',
                icon: Icon(Icons.check_rounded,
                    color: PawlyColors.resolve(context, PawlyColors.black),
                    size: 18),
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
    return PawlyCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: appointment.isCompleted
                  ? PawlyColors.resolve(context, PawlyColors.border)
                  : PawlyColors.resolve(context, PawlyColors.black),
              borderRadius: AppTokens.rSm,
            ),
            child: Icon(
              appointment.isCompleted
                  ? Icons.check
                  : Icons.calendar_today_outlined,
              color: appointment.isCompleted
                  ? PawlyColors.resolve(context, PawlyColors.tertiary)
                  : Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
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
                        style: PawlyTypography.resolve(
                                context, PawlyTypography.titleSmall)
                            .copyWith(
                          color: appointment.isCompleted
                              ? PawlyColors.resolve(
                                  context, PawlyColors.tertiary)
                              : PawlyColors.resolve(context, PawlyColors.black),
                          decoration: appointment.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    Text(
                      appointment.date,
                      style: PawlyTypography.resolve(
                          context, PawlyTypography.caption),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${appointment.clinic} • ${appointment.vetName}',
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.bodyMedium),
                ),
                if (!appointment.isCompleted && onPrepTap != null) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onPrepTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.playlist_add_check_rounded,
                            color:
                                PawlyColors.resolve(context, PawlyColors.black),
                            size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Pre-Visit Prep',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color:
                                PawlyColors.resolve(context, PawlyColors.black),
                            decoration: TextDecoration.underline,
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
