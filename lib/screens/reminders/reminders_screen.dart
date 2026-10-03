import '../../models/care_schedule.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../repositories/pawly_repository.dart';
import '../../widgets/widgets.dart';
import '../appointments/appointments_screen.dart';
import '../vaccination/vaccination_passport_screen.dart';

/// In-app reminders drawn from persisted care; no fabricated scheduled alerts.
class RemindersScreen extends StatelessWidget {
  final PawlyRepository repository;
  const RemindersScreen({super.key, required this.repository});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        final now = DateTime.now();
        final today = repository.routinesForDate(now);
        final pending = today.where((r) => !r.isCompleted).toList();
        final done = today.where((r) => r.isCompleted).toList();
        final later = <Widget>[];
        for (final pet in repository.pets) {
          final visits = repository
              .appointmentsForPet(pet.id)
              .where((a) => !a.isCompleted)
              .toList()
            ..sort((a, b) => (CareSchedule.parseDate(a.date) ?? DateTime(1900))
                .compareTo(CareSchedule.parseDate(b.date) ?? DateTime(1900)));
          for (final visit in visits) {
            later.add(ListTile(
                leading: PetAvatar(imageUrl: pet.imageUrl, radius: 22),
                title: Text('${pet.name} · ${visit.purpose}'),
                subtitle: Text('${visit.date} · ${visit.time}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  repository.selectPet(pet.id);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              AppointmentsScreen(repository: repository)));
                }));
          }
          for (final vaccine in repository
              .vaccinationsForPet(pet.id)
              .where((v) => v.effectiveStatus != VaccineStatus.current)) {
            later.add(ListTile(
                leading: PetAvatar(imageUrl: pet.imageUrl, radius: 22),
                title: Text('${pet.name} · ${vaccine.vaccineName}'),
                subtitle: Text(
                    '${vaccine.effectiveStatus == VaccineStatus.overdue ? 'Overdue' : 'Booster due'} · ${vaccine.nextDueDate}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  repository.selectPet(pet.id);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => VaccinationPassportScreen(
                              repository: repository)));
                }));
          }
        }
        for (var offset = 1; offset <= 7; offset++) {
          final date = now.add(Duration(days: offset));
          final care = repository.routinesForDate(date);
          if (care.isEmpty) continue;
          later.add(Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
              child: Text(DateFormat('EEEE, MMM d').format(date),
                  style: const TextStyle(fontWeight: FontWeight.w700))));
          later.addAll(care.map((r) => ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(
                  '${repository.pets.firstWhere((p) => p.id == r.petId).name} · ${r.title}'),
              subtitle: Text(r.time))));
        }
        Widget careList(List<CareRoutine> routines, bool completed) => routines
                .isEmpty
            ? EmptyStateView(
                title: completed
                    ? 'Little wins will appear here'
                    : 'Nothing waiting today',
                subtitle: completed
                    ? 'Complete care from Today to keep a record of this day.'
                    : 'Your pet family has no unfinished care scheduled today.')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: routines.length,
                itemBuilder: (context, index) {
                  final routine = routines[index];
                  final pet =
                      repository.pets.firstWhere((p) => p.id == routine.petId);
                  return CheckboxListTile(
                      secondary: PetAvatar(imageUrl: pet.imageUrl, radius: 22),
                      value: routine.isCompleted,
                      title: Text('${pet.name} · ${routine.title}'),
                      subtitle: Text(completed
                          ? 'Completed at ${routine.completedAt}'
                          : routine.time),
                      onChanged: (_) => repository.toggleRoutine(routine.id));
                });
        return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                  title: const Text('Care reminders'),
                  bottom: const TabBar(tabs: [
                    Tab(text: 'Today'),
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Completed')
                  ])),
              body: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                        'Care for your whole family. Upcoming shows visits, boosters and the next seven days. Reminders appear inside Pawly.',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant))),
                Expanded(
                    child: TabBarView(children: [
                  careList(pending, false),
                  later.isEmpty
                      ? const EmptyStateView(
                          title: 'Room for the days ahead',
                          subtitle:
                              'Add a routine, visit or booster date to see upcoming care.')
                      : ListView(
                          padding: const EdgeInsets.only(bottom: 24),
                          children: later),
                  careList(done, true)
                ])),
              ]),
            ));
      });
}
