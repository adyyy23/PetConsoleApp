import '../../widgets/passport/pawly_passport.dart';
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
                  PawlyPassport(
                      pet: pet,
                      ownerName: repository.user.name,
                      vaccines: vaccines),
                  const SizedBox(height: 18),
                  Text(
                      '${vaccines.length} vaccination records · ${vaccines.where((v) => v.effectiveStatus != VaccineStatus.current).length} boosters need attention',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12)),
                  const SizedBox(height: 8),
                  const Text(
                      'Keep your pet’s identity and vaccine history together. This is a personal record; your clinic provides official documents.',
                      style: TextStyle(fontSize: 12)),
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
