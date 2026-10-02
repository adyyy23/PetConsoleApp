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
                      label: 'New Routine',
                      icon: Icons.add,
                      isSmall: true,
                      variant: PawlyButtonVariant.primary,
                      onPressed: widget.onOpenAddCare,
                    ),
                  ],
                ),
              ),
            ),

            // Category Filter Pills
            SliverToBoxAdapter(
              child: Container(
                height: 44,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    ChoiceChip(
                      label: const Text('All Routines'),
                      selected: _selectedCategory == null,
                      onSelected: (_) => setState(() => _selectedCategory = null),
                      backgroundColor: PawlyColors.surface,
                      selectedColor: PawlyColors.espresso,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: _selectedCategory == null ? FontWeight.w700 : FontWeight.w500,
                        color: _selectedCategory == null ? Colors.white : PawlyColors.charcoal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: _selectedCategory == null ? PawlyColors.espresso : PawlyColors.border,
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
                          backgroundColor: PawlyColors.surface,
                          selectedColor: PawlyColors.espresso,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Colors.white : PawlyColors.charcoal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isSelected ? PawlyColors.espresso : PawlyColors.border,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Agenda List
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
                        padding: EdgeInsets.only(bottom: 10, top: 4),
                        child: Text('SCHEDULED TODAY', style: PawlyTypography.labelSmall),
                      ),
                      ...pending.map((r) => _CareItemCard(
                            routine: r,
                            onToggle: () => widget.repository.toggleRoutine(r.id),
                            onDelete: () => widget.repository.deleteRoutine(r.id),
                          )),
                      const SizedBox(height: 18),
                    ],

                    if (completed.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text('COMPLETED TODAY', style: PawlyTypography.labelSmall),
                      ),
                      ...completed.map((r) => _CareItemCard(
                            routine: r,
                            onToggle: () => widget.repository.toggleRoutine(r.id),
                            onDelete: () => widget.repository.deleteRoutine(r.id),
                          )),
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

class _CareItemCard extends StatelessWidget {
  final CareRoutine routine;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _CareItemCard({
    required this.routine,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: routine.isCompleted ? PawlyColors.creamBg : PawlyColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: routine.isCompleted ? PawlyColors.borderLight : PawlyColors.border,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          // Circular Complete Check
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: routine.isCompleted ? PawlyColors.forest : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: routine.isCompleted ? PawlyColors.forest : PawlyColors.border,
                  width: 2,
                ),
              ),
              child: routine.isCompleted
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 14),

          // Content
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
                      routine.category.displayName,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: PawlyColors.mutedGrey),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${routine.recurrence}',
                      style: const TextStyle(fontSize: 11, color: PawlyColors.mutedGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  routine.title,
                  style: TextStyle(
                    fontSize: 16,
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

          IconButton(
            icon: const Icon(Icons.close, size: 16, color: PawlyColors.mutedGrey),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
