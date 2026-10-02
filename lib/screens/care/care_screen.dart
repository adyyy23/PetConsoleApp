import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';
import '../../repositories/pawly_repository.dart';
import '../../models/care_routine.dart';

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
      backgroundColor: PawlyColors.creamBg,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('EVERYDAY ROUTINES • ${activePet.name.toUpperCase()}', style: PawlyTypography.labelSmall),
                        const SizedBox(height: 2),
                        const Text('Care Agenda', style: PawlyTypography.displayMedium),
                      ],
                    ),
                    PawlyButton(
                      text: '+ Add Care',
                      isSmall: true,
                      variant: PawlyButtonVariant.primary,
                      onPressed: widget.onOpenAddCare,
                    ),
                  ],
                ),
              ),
            ),

            // Horizontal Week Selector
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: PawlyBubble(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(_weekDays.length, (idx) {
                      final item = _weekDays[idx];
                      final isSelected = idx == _selectedDayIndex;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDayIndex = idx),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? PawlyColors.forest : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item['day']!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white70 : PawlyColors.warmGrey,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['date']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected ? Colors.white : PawlyColors.espresso,
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

            // Gentle Care Consistency Streak Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: PawlyBubble(
                  backgroundColor: PawlyColors.sageLight,
                  borderColor: PawlyColors.softSage,
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: PawlyColors.forest,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star_rounded, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Care Consistency: 6 of last 7 days',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: PawlyColors.forest,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              '${activePet.name} is on track with scheduled wellness care.',
                              style: const TextStyle(
                                fontSize: 11,
                                color: PawlyColors.forest,
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

            // Category Filter Pills
            SliverToBoxAdapter(
              child: Container(
                height: 44,
                margin: const EdgeInsets.only(top: 6, bottom: 12),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    ChoiceChip(
                      label: const Text('All Routines'),
                      selected: _selectedCategory == null,
                      onSelected: (_) => setState(() => _selectedCategory = null),
                      backgroundColor: Colors.white,
                      selectedColor: PawlyColors.forest,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: _selectedCategory == null ? FontWeight.w800 : FontWeight.w600,
                        color: _selectedCategory == null ? Colors.white : PawlyColors.espresso,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: _selectedCategory == null ? PawlyColors.forest : PawlyColors.border,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...CareCategory.values.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat.displayName),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _selectedCategory = cat),
                          backgroundColor: Colors.white,
                          selectedColor: PawlyColors.forest,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? Colors.white : PawlyColors.espresso,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: BorderSide(
                              color: isSelected ? PawlyColors.forest : PawlyColors.border,
                            ),
                          ),
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
                  icon: Icons.check_circle_outline,
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
                        padding: EdgeInsets.only(bottom: 12, top: 4),
                        child: Text('SCHEDULED TODAY', style: PawlyTypography.labelSmall),
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
                        );
                      }),
                      const SizedBox(height: 16),
                    ],

                    if (completed.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text('COMPLETED TODAY', style: PawlyTypography.labelSmall),
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
