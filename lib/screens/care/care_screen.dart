import 'package:flutter/material.dart';
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
  int _selectedDayIndex = 4; // Friday in current week

  final List<Map<String, String>> _weekDays = const [
    {'day': 'M', 'date': '28'},
    {'day': 'T', 'date': '29'},
    {'day': 'W', 'date': '30'},
    {'day': 'T', 'date': '1'},
    {'day': 'F', 'date': '2'},
    {'day': 'S', 'date': '3'},
    {'day': 'S', 'date': '4'},
  ];

  @override
  Widget build(BuildContext context) {
    final activePet = widget.repository.activePet;
    final allRoutines = widget.repository.activePetRoutines;

    final filtered = _selectedCategory == null
        ? allRoutines
        : allRoutines.where((r) => r.category == _selectedCategory).toList();

    final pending = filtered.where((r) => !r.isCompleted).toList();
    final completed = filtered.where((r) => r.isCompleted).toList();

    return Scaffold(
      backgroundColor: PawlyColors.background,
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
                          Text('EVERYDAY ROUTINES • ${activePet.name.toUpperCase()}', style: PawlyTypography.eyebrow, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          const Text('Care', style: PawlyTypography.displayMedium, overflow: TextOverflow.ellipsis),
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

            // Horizontal Week Selector (Clean 8px card, 6px day buttons)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: PawlyCard(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(_weekDays.length, (idx) {
                      final item = _weekDays[idx];
                      final isSelected = idx == _selectedDayIndex;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDayIndex = idx),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? PawlyColors.black : Colors.transparent,
                            borderRadius: AppTokens.rSm,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item['day']!,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white70 : PawlyColors.tertiary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['date']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected ? Colors.white : PawlyColors.black,
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: PawlyCard(
                  backgroundColor: PawlyColors.surfaceWarm,
                  padding: const EdgeInsets.all(14),
                  child: Builder(builder: (context) {
                    final routineCount = allRoutines.length;
                    final doneCount = allRoutines.where((r) => r.isCompleted).length;
                    final pct = routineCount == 0 ? 0 : ((doneCount / routineCount) * 100).round();
                    return Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: PawlyColors.black,
                            borderRadius: AppTokens.rSm,
                          ),
                          child: const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 16),
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
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: PawlyColors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                routineCount > 0
                                    ? '${activePet.name} has $doneCount routine${doneCount == 1 ? '' : 's'} completed.'
                                    : 'Add everyday care routines for feeding, walks, or meds.',
                                style: PawlyTypography.bodyMedium,
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
                  subtitle: 'Add everyday care routines for feeding, medication, or walks.',
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
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8, top: 4),
                        child: Text('SCHEDULED TODAY', style: PawlyTypography.eyebrow),
                      ),
                      ...List.generate(pending.length, (idx) {
                        final r = pending[idx];
                        final isLast = idx == pending.length - 1 && completed.isEmpty;
                        return CareTimelineItem(
                          time: r.time,
                          title: r.title,
                          subtitle: r.notes.isNotEmpty ? r.notes : '${r.category.displayName} • ${r.recurrence}',
                          isCompleted: false,
                          isLast: isLast,
                          assignedTo: r.assignedTo,
                          onToggle: () => widget.repository.toggleRoutine(r.id),
                          onDelete: () => widget.repository.deleteRoutine(r.id),
                        );
                      }),
                      const SizedBox(height: 16),
                    ],

                    if (completed.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text('COMPLETED TODAY', style: PawlyTypography.eyebrow),
                      ),
                      ...List.generate(completed.length, (idx) {
                        final r = completed[idx];
                        final isLast = idx == completed.length - 1;
                        return CareTimelineItem(
                          time: r.time,
                          title: r.title,
                          subtitle: r.completedAt.isNotEmpty
                              ? 'Completed at ${r.completedAt}'
                              : (r.notes.isNotEmpty ? r.notes : '${r.category.displayName} • ${r.recurrence}'),
                          isCompleted: true,
                          isLast: isLast,
                          assignedTo: r.assignedTo,
                          onToggle: () => widget.repository.toggleRoutine(r.id),
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
            color: isSelected ? PawlyColors.black : PawlyColors.border,
            width: 1.0,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : PawlyColors.black,
          ),
        ),
      ),
    );
  }
}
