import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/widgets.dart';
import '../../repositories/pawly_repository.dart';
import '../../models/models.dart';

class CareScreen extends StatefulWidget {
  final PawlyRepository repository;
  final VoidCallback onOpenAddCare;

  const CareScreen({
    super.key,
    required this.repository,
    required this.onOpenAddCare,
  });

  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> {
  CareCategory? _selectedCategory;
  int _selectedDayIndex = DateTime.now().weekday - 1;
  final DateTime _weekStart =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.repository.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.repository.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activePet = widget.repository.activePet;
    final selectedDate = _weekStart.add(Duration(days: _selectedDayIndex));
    final allRoutines =
        widget.repository.routinesForDate(selectedDate, petId: activePet.id);

    final filtered = _selectedCategory == null
        ? allRoutines
        : allRoutines.where((r) => r.category == _selectedCategory).toList();

    final pending = filtered.where((r) => !r.isCompleted).toList();
    final completed = filtered.where((r) => r.isCompleted).toList();

    return Scaffold(
      backgroundColor: PawlyColors.resolve(context, PawlyColors.background),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // Top Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'EVERYDAY ROUTINES • ${activePet.name.toUpperCase()}',
                              style: PawlyTypography.resolve(
                                  context, PawlyTypography.eyebrow),
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text('Care',
                              style: PawlyTypography.resolve(
                                  context, PawlyTypography.displayMedium),
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    PawlyButton(
                      text: '+ Add Care',
                      isSmall: true,
                      onPressed: widget.onOpenAddCare,
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                    child: PetSwitcher(
                        pets: widget.repository.pets,
                        selectedPetId: widget.repository.selectedPetId,
                        onPetSelected: widget.repository.selectPet))),

            // Horizontal Week Selector (Clean 8px card, 6px day buttons)
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: PawlyCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (idx) {
                      final item = _weekStart.add(Duration(days: idx));
                      final isSelected = idx == _selectedDayIndex;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDayIndex = idx),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? PawlyColors.black
                                : Colors.transparent,
                            borderRadius: AppTokens.rSm,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                DateFormat('EEE').format(item).substring(0, 1),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white70
                                      : PawlyColors.resolve(
                                          context, PawlyColors.tertiary),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.day.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected
                                      ? Colors.white
                                      : PawlyColors.resolve(
                                          context, PawlyColors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),

            // Real Care Progress Banner
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: PawlyCard(
                  backgroundColor:
                      PawlyColors.resolve(context, PawlyColors.surfaceWarm),
                  padding: const EdgeInsets.all(14),
                  child: Builder(builder: (context) {
                    final routineCount = allRoutines.length;
                    final doneCount =
                        allRoutines.where((r) => r.isCompleted).length;
                    final pct = routineCount == 0
                        ? 0
                        : ((doneCount / routineCount) * 100).round();
                    return Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: PawlyColors.black,
                            borderRadius: AppTokens.rSm,
                          ),
                          child: const Icon(Icons.check_circle_outline_rounded,
                              color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                routineCount > 0
                                    ? '$doneCount of $routineCount completed ($pct%)'
                                    : 'No routines scheduled today',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: PawlyColors.resolve(
                                      context, PawlyColors.black),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                routineCount > 0
                                    ? '${activePet.name} has $doneCount routine${doneCount == 1 ? '' : 's'} completed.'
                                    : 'Add everyday care routines for feeding, walks, or meds.',
                                style: PawlyTypography.resolve(
                                    context, PawlyTypography.bodyMedium),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),

            // Category Filter Pills (Clean 6px tags)
            SliverToBoxAdapter(
              child: Container(
                height: 38,
                margin: const EdgeInsets.only(top: 8, bottom: 12),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _FilterChip(
                      label: 'All Routines',
                      isSelected: _selectedCategory == null,
                      onTap: () => setState(() => _selectedCategory = null),
                    ),
                    const SizedBox(width: 8),
                    ...CareCategory.values.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _FilterChip(
                          label: cat.displayName,
                          isSelected: isSelected,
                          onTap: () => setState(() => _selectedCategory = cat),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Care Agenda Timeline
            if (filtered.isEmpty)
              SliverFillRemaining(
                child: EmptyStateView(
                  title: 'No routines found',
                  subtitle:
                      'Add everyday care routines for feeding, medication, or walks.',
                  buttonLabel: 'Create Care Routine',
                  onButtonPressed: widget.onOpenAddCare,
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (pending.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, top: 4),
                        child: Text('SCHEDULED FOR THIS DAY',
                            style: PawlyTypography.resolve(
                                context, PawlyTypography.eyebrow)),
                      ),
                      ...List.generate(pending.length, (idx) {
                        final r = pending[idx];
                        final isLast =
                            idx == pending.length - 1 && completed.isEmpty;
                        return CareTimelineItem(
                          time: r.time,
                          petImageUrl: activePet.imageUrl,
                          petName: activePet.name,
                          title: r.title,
                          subtitle: r.notes.isNotEmpty
                              ? r.notes
                              : '${r.category.displayName} • ${r.recurrence}',
                          isCompleted: false,
                          isLast: isLast,
                          assignedTo: r.assignedTo,
                          onToggle: () => widget.repository
                              .toggleRoutine(r.id, date: selectedDate),
                          onDelete: () => widget.repository.deleteRoutine(r.id),
                        );
                      }),
                      const SizedBox(height: 16),
                    ],
                    if (completed.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('COMPLETED FOR THIS DAY',
                            style: PawlyTypography.resolve(
                                context, PawlyTypography.eyebrow)),
                      ),
                      ...List.generate(completed.length, (idx) {
                        final r = completed[idx];
                        final isLast = idx == completed.length - 1;
                        return CareTimelineItem(
                          time: r.time,
                          petImageUrl: activePet.imageUrl,
                          petName: activePet.name,
                          title: r.title,
                          subtitle: r.completedAt.isNotEmpty
                              ? 'Completed at ${r.completedAt}'
                              : (r.notes.isNotEmpty
                                  ? r.notes
                                  : '${r.category.displayName} • ${r.recurrence}'),
                          isCompleted: true,
                          isLast: isLast,
                          assignedTo: r.assignedTo,
                          onToggle: () => widget.repository
                              .toggleRoutine(r.id, date: selectedDate),
                          onDelete: () => widget.repository.deleteRoutine(r.id),
                        );
                      }),
                    ],
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? PawlyColors.black : Colors.white,
          borderRadius: AppTokens.rSm,
          border: Border.all(
            color: isSelected
                ? PawlyColors.black
                : PawlyColors.resolve(context, PawlyColors.border),
            width: 1.0,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected
                ? Colors.white
                : PawlyColors.resolve(context, PawlyColors.black),
          ),
        ),
      ),
    );
  }
}
