import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';
import '../../models/models.dart';
import '../../repositories/pawly_repository.dart';

class VaccinationPassportScreen extends StatelessWidget {
  final PawlyRepository repository;

  const VaccinationPassportScreen({super.key, required this.repository});

  void _openAddVaccineDialog(BuildContext context) {
    final nameController = TextEditingController();
    final nextDueController = TextEditingController();
    final clinicController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Vaccination Record',
                style: PawlyTypography.resolve(
                    context, PawlyTypography.titleLarge)),
            const SizedBox(height: 6),
            Text('Keep proof of immunization and booster due dates.',
                style: PawlyTypography.resolve(
                    context, PawlyTypography.bodyMedium)),
            const SizedBox(height: 20),
            Text('Vaccine Name *',
                style: PawlyTypography.resolve(
                    context, PawlyTypography.labelLarge)),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'e.g. Leptospirosis 4-way, Rabies 3-Year',
                filled: true,
                fillColor:
                    PawlyColors.resolve(context, PawlyColors.surfaceWarm),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color:
                            PawlyColors.resolve(context, PawlyColors.border))),
              ),
            ),
            const SizedBox(height: 16),
            Text('Next Booster Due Date',
                style: PawlyTypography.resolve(
                    context, PawlyTypography.labelLarge)),
            const SizedBox(height: 8),
            TextField(
              controller: nextDueController,
              readOnly: true,
              onTap: () async {
                final selected = await showDatePicker(
                    context: ctx,
                    initialDate: DateTime.now().add(const Duration(days: 365)),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100));
                if (selected != null) {
                  nextDueController.text =
                      selected.toIso8601String().substring(0, 10);
                }
              },
              decoration: InputDecoration(
                hintText: 'Choose booster date (optional)',
                filled: true,
                fillColor:
                    PawlyColors.resolve(context, PawlyColors.surfaceWarm),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color:
                            PawlyColors.resolve(context, PawlyColors.border))),
              ),
            ),
            const SizedBox(height: 16),
            Text('Clinic / Administering Vet',
                style: PawlyTypography.resolve(
                    context, PawlyTypography.labelLarge)),
            const SizedBox(height: 8),
            TextField(
              controller: clinicController,
              decoration: InputDecoration(
                hintText: 'CityVet Wellness Center',
                filled: true,
                fillColor:
                    PawlyColors.resolve(context, PawlyColors.surfaceWarm),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color:
                            PawlyColors.resolve(context, PawlyColors.border))),
              ),
            ),
            const SizedBox(height: 24),
            PawlyButton(
              text: 'Save to Passport',
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                      content: Text('Enter a name before saving.')));
                  return;
                }
                if (name.isNotEmpty) {
                  final now = DateTime.now();
                  const months = [
                    'Jan',
                    'Feb',
                    'Mar',
                    'Apr',
                    'May',
                    'Jun',
                    'Jul',
                    'Aug',
                    'Sep',
                    'Oct',
                    'Nov',
                    'Dec'
                  ];
                  final dateStr =
                      '${months[now.month - 1]} ${now.day.toString().padLeft(2, '0')}, ${now.year}';
                  await repository.addVaccination(
                    VaccinationRecord(
                      id: 'v_${DateTime.now().millisecondsSinceEpoch}',
                      petId: repository.activePet.id,
                      vaccineName: name,
                      dateAdministered: dateStr,
                      nextDueDate: nextDueController.text.trim(),
                      veterinarian: '',
                      clinic: clinicController.text.trim(),
                      status: VaccineStatus.current,
                    ),
                  );
                  if (ctx.mounted) Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        final pet = repository.activePet;
        final vaccines = repository.activePetVaccinations;

        return Scaffold(
          backgroundColor: PawlyColors.resolve(context, PawlyColors.background),
          appBar: AppBar(
            title: Text('${pet.name}’s Passport'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded),
                onPressed: () => _openAddVaccineDialog(context),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Passport Certificate Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: PawlyColors.black,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: PawlyColors.resolve(context, PawlyColors.black)
                              .withOpacity(0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Flexible(
                                child: Text(
                              'CANINE HEALTH PASSPORT',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                                color: Colors.white70,
                              ),
                            )),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: PawlyColors.resolve(
                                        context, PawlyColors.surface)
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'IMMUNIZED',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          pet.name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${pet.breed} • Microchip: ${pet.microchipNumber.isNotEmpty ? pet.microchipNumber : "Verified"}',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.85)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text('RECORDED VACCINATIONS',
                      style: PawlyTypography.resolve(
                          context, PawlyTypography.eyebrow)),
                  const SizedBox(height: 12),

                  if (vaccines.isEmpty)
                    EmptyStateView(
                      title: 'No vaccines logged',
                      subtitle:
                          'Add core boosters to keep an official digital record.',
                      buttonLabel: 'Add Vaccine Record',
                      onButtonPressed: () => _openAddVaccineDialog(context),
                    )
                  else
                    ...vaccines.map((v) {
                      PawlyBadgeVariant badgeVariant;
                      String statusLabel;

                      switch (v.effectiveStatus) {
                        case VaccineStatus.current:
                          badgeVariant = PawlyBadgeVariant.sage;
                          statusLabel = 'CURRENT';
                          break;
                        case VaccineStatus.dueSoon:
                          badgeVariant = PawlyBadgeVariant.honey;
                          statusLabel = 'DUE SOON';
                          break;
                        case VaccineStatus.overdue:
                          badgeVariant = PawlyBadgeVariant.alert;
                          statusLabel = 'OVERDUE';
                          break;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color:
                              PawlyColors.resolve(context, PawlyColors.surface),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: PawlyColors.resolve(
                                  context, PawlyColors.border)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    child: Text(v.vaccineName,
                                        style: PawlyTypography.resolve(context,
                                            PawlyTypography.titleMedium))),
                                StatusBadge(
                                    label: statusLabel, variant: badgeVariant),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Given on',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: PawlyColors.resolve(
                                                  context,
                                                  PawlyColors.tertiary))),
                                      const SizedBox(height: 2),
                                      Text(v.dateAdministered,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: PawlyColors.resolve(
                                                  context,
                                                  PawlyColors.charcoal))),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Next Booster Due',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: PawlyColors.resolve(
                                                  context,
                                                  PawlyColors.tertiary))),
                                      const SizedBox(height: 2),
                                      Text(v.nextDueDate,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: PawlyColors.resolve(
                                                  context, PawlyColors.black))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${v.clinic} • ${v.veterinarian}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: PawlyColors.resolve(
                                      context, PawlyColors.secondary)),
                            ),
                          ],
                        ),
                      );
                    }),

                  const SizedBox(height: 20),

                  PawlyButton(
                    text: 'Add Vaccine to Passport',
                    onPressed: () => _openAddVaccineDialog(context),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      });
}
