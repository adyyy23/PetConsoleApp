import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/widgets.dart';
import '../../repositories/pawly_repository.dart';
import '../../models/models.dart';
import '../../models/care_schedule.dart';
import '../timeline/pet_timeline_screen.dart';
import '../reminders/reminders_screen.dart';

class HomeScreen extends StatelessWidget {
  final PawlyRepository repository;
  final VoidCallback onOpenAddPet,
      onOpenAddCare,
      onOpenCareTab,
      onOpenHealthTab;
  final ValueChanged<String> onOpenPetSpace;
  final VoidCallback onOpenAppointments, onOpenWeight;
  final VoidCallback? onOpenSearch, onOpenCalendar;
  const HomeScreen(
      {super.key,
      required this.repository,
      required this.onOpenAddPet,
      required this.onOpenAddCare,
      required this.onOpenCareTab,
      required this.onOpenHealthTab,
      required this.onOpenPetSpace,
      required this.onOpenAppointments,
      required this.onOpenWeight,
      this.onOpenSearch,
      this.onOpenCalendar});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final pet = repository.selectedPet;
    final routines = repository.activePetRoutines;
    final done = routines.where((r) => r.isCompleted).length;
    final upcoming = repository.activePetAppointments
        .where((a) =>
            !a.isCompleted &&
            !(CareSchedule.parseDate(a.date) ?? DateTime(1900))
                .isBefore(CareSchedule.day(now)))
        .toList()
      ..sort((a, b) => CareSchedule.parseDate(a.date)!
          .compareTo(CareSchedule.parseDate(b.date)!));
    final greeting = now.hour < 12
        ? 'Good morning'
        : now.hour < 18
            ? 'Good afternoon'
            : 'Good evening';
    return Scaffold(
        body: SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: [
                Row(children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(DateFormat('EEEE, MMMM d').format(now),
                            style: TextStyle(
                                fontSize: 12, color: scheme.onSurfaceVariant)),
                        const SizedBox(height: 6),
                        Text(
                            '$greeting,\n${repository.user.name.split(' ').first}.',
                            style: const TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                                letterSpacing: -.6)),
                      ])),
                  IconButton(
                      tooltip: 'Search pet records',
                      onPressed: onOpenSearch,
                      icon: const Icon(Icons.search)),
                  IconButton(
                      tooltip: 'Pet calendar',
                      onPressed: onOpenCalendar,
                      icon: const Icon(Icons.calendar_month_outlined)),
                ]),
                if (repository.isDemoMode)
                  Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text('EXAMPLE PETS · DEMO ON THIS DEVICE',
                          style: TextStyle(
                              fontSize: 11,
                              color: scheme.onSurfaceVariant,
                              letterSpacing: .6))),
                const SizedBox(height: 18),
                PetSwitcher(
                    pets: repository.pets,
                    selectedPetId: repository.selectedPetId,
                    onSelectPet: repository.selectPet,
                    onAddPet: onOpenAddPet),
                const SizedBox(height: 18),
                if (pet == null)
                  EmptyStateView(
                      title: 'Make room for your companion',
                      subtitle: 'Add your pet to start their care story.',
                      buttonLabel: 'Add a pet',
                      onButtonPressed: onOpenAddPet)
                else ...[
                  AnimatedSwitcher(
                      duration: MediaQuery.of(context).disableAnimations
                          ? Duration.zero
                          : const Duration(milliseconds: 220),
                      child: PawlyCard(
                          key: ValueKey(pet.id),
                          padding: EdgeInsets.zero,
                          onTap: () => onOpenPetSpace(pet.id),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(18)),
                                    child: ColoredBox(
                                        color: Colors.transparent,
                                        child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image(
                                                image: pawlyImageProvider(
                                                    pet.imageUrl),
                                                fit: BoxFit.contain,
                                                loadingBuilder: (context, child, progress) => progress == null
                                                    ? child
                                                    : Center(
                                                        child: Icon(Icons.pets,
                                                            size: 64,
                                                            color: scheme
                                                                .onPrimaryContainer)),
                                                errorBuilder: (_, __, ___) => Center(
                                                    child: Icon(Icons.pets,
                                                        size: 64,
                                                        color: scheme.onPrimaryContainer)))))),
                                Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(children: [
                                            Expanded(
                                                child: Text(pet.name,
                                                    style: const TextStyle(
                                                        fontSize: 28,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        letterSpacing: -.5))),
                                            IconButton(
                                                tooltip:
                                                    'Open ${pet.name}’s profile',
                                                onPressed: () =>
                                                    onOpenPetSpace(pet.id),
                                                icon: const Icon(
                                                    Icons.arrow_outward))
                                          ]),
                                          Text(
                                              '${pet.breed} · ${pet.ageYears.toStringAsFixed(1)} years',
                                              style: TextStyle(
                                                  color:
                                                      scheme.onSurfaceVariant,
                                                  fontSize: 13)),
                                          const SizedBox(height: 12),
                                          Row(children: [
                                            Icon(Icons.pets,
                                                size: 15,
                                                color: scheme.primary),
                                            const SizedBox(width: 8),
                                            Expanded(
                                                child: Text(
                                                    routines
                                                            .where((r) =>
                                                                !r.isCompleted)
                                                            .isEmpty
                                                        ? routines.isEmpty
                                                            ? 'A little home for their everyday care'
                                                            : 'Today’s care, all taken care of'
                                                        : 'Next: ${routines.firstWhere((r) => !r.isCompleted).title}',
                                                    style: TextStyle(
                                                        color: scheme.primary,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600))),
                                          ]),
                                        ])),
                              ]))),
                  if (repository.isLostPetModeEnabled)
                    Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: PawlyCard(
                            backgroundColor: scheme.errorContainer,
                            child: Row(children: [
                              Icon(Icons.warning_amber,
                                  color: scheme.onErrorContainer),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: Text(
                                      'Lost pet mode is on. Review contact details in More.',
                                      style: TextStyle(
                                          color: scheme.onErrorContainer)))
                            ]))),
                  const SizedBox(height: 26),
                  Row(children: [
                    const Expanded(
                        child: Text('A little care today',
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.w700))),
                    TextButton(
                        onPressed: onOpenCareTab, child: const Text('See all'))
                  ]),
                  if (routines.isEmpty)
                    PawlyCard(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text('What does ${pet.name} need each day?',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16)),
                          const SizedBox(height: 6),
                          const Text(
                              'Start with a meal, a walk or fresh water.'),
                          const SizedBox(height: 14),
                          PawlyButton(
                              text: 'Add their first routine',
                              isSmall: true,
                              onPressed: onOpenAddCare),
                        ]))
                  else ...[
                    Row(children: [
                      Expanded(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                  value: done / routines.length,
                                  minHeight: 6,
                                  backgroundColor: scheme.outlineVariant))),
                      const SizedBox(width: 12),
                      Text('$done / ${routines.length}',
                          style: TextStyle(
                              color: scheme.primary,
                              fontWeight: FontWeight.w700))
                    ]),
                    const SizedBox(height: 18),
                    ...routines.take(4).map((routine) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CareTimelineItem(
                          time: routine.time,
                          petImageUrl: pet.imageUrl,
                          petName: pet.name,
                          title: routine.title,
                          subtitle: routine.notes.isEmpty
                              ? routine.category.displayName
                              : routine.notes,
                          isCompleted: routine.isCompleted,
                          isLast: true,
                          onToggle: () async {
                            try {
                              await repository.toggleRoutine(routine.id);
                              if (!context.mounted) return;
                              final allDone = repository.activePetRoutines
                                  .every((r) => r.isCompleted);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  duration: const Duration(seconds: 2),
                                  content: Text(allDone
                                      ? '${pet.name}’s care is all taken care of today.'
                                      : routine.isCompleted
                                          ? 'Marked as still to do'
                                          : '${routine.title} taken care of')));
                            } catch (_) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Couldn’t save this care. Please try again.')));
                              }
                            }
                          },
                        ))),
                    if (done == routines.length)
                      Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(children: [
                            Icon(Icons.pets, size: 18, color: scheme.primary),
                            const SizedBox(width: 10),
                            const Expanded(
                                child: Text(
                                    'Small things, beautifully taken care of.')),
                          ])),
                  ],
                  const SizedBox(height: 26),
                  if (upcoming.isNotEmpty) ...[
                    const Text('Next visit',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    PawlyCard(
                        onTap: onOpenAppointments,
                        child: Row(children: [
                          Icon(Icons.event_available,
                              color: scheme.primary, size: 28),
                          const SizedBox(width: 14),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(upcoming.first.purpose,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(
                                    '${DateFormat('MMM d').format(CareSchedule.parseDate(upcoming.first.date)!)} · ${upcoming.first.time}'),
                                Text(upcoming.first.clinic,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: scheme.onSurfaceVariant)),
                              ])),
                          const Icon(Icons.chevron_right),
                        ])),
                    const SizedBox(height: 24),
                  ],
                  const Text('Keep close',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    ActionChip(
                        avatar: const Icon(Icons.notifications_none, size: 18),
                        label: const Text('Care reminders'),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    RemindersScreen(repository: repository)))),
                    ActionChip(
                        avatar: const Icon(Icons.favorite_border, size: 18),
                        label: const Text('Health records'),
                        onPressed: onOpenHealthTab),
                    ActionChip(
                        avatar: const Icon(Icons.auto_graph, size: 18),
                        label: const Text('Log weight'),
                        onPressed: onOpenWeight),
                    ActionChip(
                        avatar: const Icon(Icons.history, size: 18),
                        label: const Text('Their story'),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PetTimelineScreen(
                                    repository: repository)))),
                  ]),
                  const SizedBox(height: 24),
                  const Text('The whole family',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  ...repository.pets.map((member) {
                    final care =
                        repository.routinesForDate(now, petId: member.id);
                    final remaining = care.where((r) => !r.isCompleted).length;
                    return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading:
                            PetAvatar(imageUrl: member.imageUrl, radius: 22),
                        title: Text(member.name),
                        subtitle: Text(care.isEmpty
                            ? 'No care scheduled today'
                            : remaining == 0
                                ? 'Today’s care is complete'
                                : '$remaining care routine${remaining == 1 ? '' : 's'} still to do'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          repository.selectPet(member.id);
                          onOpenCareTab();
                        });
                  }),
                ],
              ],
            )));
  }
}
