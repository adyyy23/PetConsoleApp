import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';
import '../../repositories/pawly_repository.dart';
import '../../models/models.dart';

class HealthScreen extends StatelessWidget {
  final PawlyRepository repository;
  final VoidCallback onOpenAddHealthEvent;
  final VoidCallback onOpenWeight;
  final VoidCallback onOpenVaccination;
  final VoidCallback onOpenMedication;

  const HealthScreen({
    super.key,
    required this.repository,
    required this.onOpenAddHealthEvent,
    required this.onOpenWeight,
    required this.onOpenVaccination,
    required this.onOpenMedication,
  });

  @override
  Widget build(BuildContext context) {
    final activePet = repository.activePet;
    final events = repository.activePetHealthEvents;

    return Scaffold(
      backgroundColor: PawlyColors.creamBg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MEDICAL & WELLNESS • ${activePet.name.toUpperCase()}', style: PawlyTypography.labelSmall),
                        const SizedBox(height: 2),
                        const Text('Health Story', style: PawlyTypography.displayMedium),
                      ],
                    ),
                    PawlyButton(
                      label: 'Log Event',
                      icon: Icons.add,
                      isSmall: true,
                      variant: PawlyButtonVariant.primary,
                      onPressed: onOpenAddHealthEvent,
                    ),
                  ],
                ),
              ),
            ),

            // Health Hub Shortcuts (Weight, Vaccines, Medications)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickHealthShortcut(
                        icon: Icons.monitor_weight_outlined,
                        color: PawlyColors.honey,
                        label: 'Weight',
                        value: '${activePet.weightKg} kg',
                        onTap: onOpenWeight,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickHealthShortcut(
                        icon: Icons.shield_outlined,
                        color: PawlyColors.forest,
                        label: 'Passport',
                        value: '${repository.activePetVaccinations.length} Vaccines',
                        onTap: onOpenVaccination,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickHealthShortcut(
                        icon: Icons.medication_outlined,
                        color: PawlyColors.slate,
                        label: 'Medications',
                        value: '${repository.activePetMedications.length} Active',
                        onTap: onOpenMedication,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Timeline Header
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Text('CHRONOLOGICAL TIMELINE', style: PawlyTypography.labelSmall),
              ),
            ),

            // Health Timeline
            if (events.isEmpty)
              SliverFillRemaining(
                child: EmptyStateView(
                  icon: Icons.favorite_border,
                  title: 'No health records yet',
                  subtitle: 'Keep a clean medical history of checkups, vaccines, and dosages.',
                  buttonLabel: 'Record First Event',
                  onButtonPressed: onOpenAddHealthEvent,
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = events[index];
                      return _TimelineEventTile(event: item);
                    },
                    childCount: events.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QuickHealthShortcut extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _QuickHealthShortcut({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PawlyColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: PawlyColors.border, width: 1.2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PawlyColors.mutedGrey),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: PawlyColors.espresso),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineEventTile extends StatelessWidget {
  final HealthEvent event;

  const _TimelineEventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: PawlyColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PawlyColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PawlyBadge(label: event.type, variant: PawlyBadgeVariant.clay),
              Text(
                event.date,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: PawlyColors.mutedGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(event.title, style: PawlyTypography.titleMedium),
          const SizedBox(height: 6),
          Text(event.notes, style: PawlyTypography.bodyLarge),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.verified_user_outlined, size: 14, color: PawlyColors.forest),
              const SizedBox(width: 6),
              Text(
                '${event.veterinarian}${event.clinic.isNotEmpty ? ' • ${event.clinic}' : ''}',
                style: const TextStyle(fontSize: 12, color: PawlyColors.warmGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
