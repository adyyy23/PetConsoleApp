import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../repositories/pawly_repository.dart';
import '../../models/care_schedule.dart';
import '../../widgets/widgets.dart';
import '../memories/memories_screen.dart';

class PetTimelineScreen extends StatelessWidget {
  final PawlyRepository repository;
  const PetTimelineScreen({super.key, required this.repository});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        final pet = repository.activePet;
        final events = <_StoryEvent>[
          ...repository.activePetHealthEvents.map((e) => _StoryEvent(
              e.date, e.title, e.notes, Icons.favorite_border, 'Health')),
          ...repository.activePetVaccinations.map((e) => _StoryEvent(
              e.dateAdministered,
              e.vaccineName,
              e.clinic,
              Icons.verified_outlined,
              'Vaccination')),
          ...repository.activePetWeightHistory.map((e) => _StoryEvent(
              e.date, '${e.weightKg} kg', e.note, Icons.auto_graph, 'Weight')),
          ...repository.activePetMemories.map((e) => _StoryEvent(e.date,
              e.title, e.caption, Icons.photo_library_outlined, 'Memory')),
        ]..sort((a, b) => (CareSchedule.parseDate(b.date) ?? DateTime(1900))
            .compareTo(CareSchedule.parseDate(a.date) ?? DateTime(1900)));
        return Scaffold(
          appBar: AppBar(title: Text('${pet.name}’s story'), actions: [
            IconButton(
                tooltip: 'Add a memory',
                icon: const Icon(Icons.add),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            MemoriesScreen(repository: repository)))),
          ]),
          body: events.isEmpty
              ? EmptyStateView(
                  title: 'Every story starts somewhere',
                  subtitle:
                      'Add ${pet.name}’s first memory, health record or weigh-in. They’ll appear together here.',
                  buttonLabel: 'Add a memory',
                  onButtonPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              MemoriesScreen(repository: repository))))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  itemCount: events.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final date = CareSchedule.parseDate(event.date);
                    final previous = index == 0
                        ? null
                        : CareSchedule.parseDate(events[index - 1].date);
                    final newDay = index == 0 || date != previous;
                    final scheme = Theme.of(context).colorScheme;
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (newDay)
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 12),
                                child: Text(
                                    date == null
                                        ? event.date
                                        : DateFormat('MMMM d, yyyy')
                                            .format(date),
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: scheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w600))),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                    backgroundColor: scheme.primaryContainer,
                                    child: Icon(event.icon,
                                        color: scheme.onPrimaryContainer,
                                        size: 20)),
                                const SizedBox(width: 14),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text(event.category.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 10,
                                              letterSpacing: 1,
                                              color: scheme.primary)),
                                      const SizedBox(height: 3),
                                      Text(event.title,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700)),
                                      if (event.detail.isNotEmpty)
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(event.detail,
                                                style: TextStyle(
                                                    color:
                                                        scheme.onSurfaceVariant,
                                                    height: 1.5))),
                                    ])),
                              ]),
                        ]);
                  }),
        );
      });
}

class _StoryEvent {
  final String date, title, detail, category;
  final IconData icon;
  const _StoryEvent(
      this.date, this.title, this.detail, this.icon, this.category);
}
