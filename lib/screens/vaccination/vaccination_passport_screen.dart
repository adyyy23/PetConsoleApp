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
    final nextDueController = TextEditingController(text: 'Oct 2027');
    final clinicController = TextEditingController(text: 'CityVet Wellness Center');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
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
            const Text('Add Vaccination Record', style: PawlyTypography.titleLarge),
            const SizedBox(height: 6),
            const Text('Keep proof of immunization and booster due dates.', style: PawlyTypography.bodyMedium),
            const SizedBox(height: 20),
            const Text('Vaccine Name *', style: PawlyTypography.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'e.g. Leptospirosis 4-way, Rabies 3-Year',
                filled: true,
                fillColor: PawlyColors.surfaceWarm,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Next Booster Due Date', style: PawlyTypography.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: nextDueController,
              decoration: InputDecoration(
                hintText: 'Oct 2027',
                filled: true,
                fillColor: PawlyColors.surfaceWarm,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Clinic / Administering Vet', style: PawlyTypography.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: clinicController,
              decoration: InputDecoration(
                hintText: 'CityVet Wellness Center',
                filled: true,
                fillColor: PawlyColors.surfaceWarm,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
              ),
            ),
            const SizedBox(height: 24),
            PawlyButton(text: 'Save to Passport',
              
              
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  repository.addVaccination(
                    VaccinationRecord(
                      id: 'v_${DateTime.now().millisecondsSinceEpoch}',
                      petId: repository.activePet.id,
                      vaccineName: name,
                      dateAdministered: 'Today',
                      nextDueDate: nextDueController.text.trim(),
                      veterinarian: 'Dr. Sarah Ramos, DVM',
                      clinic: clinicController.text.trim(),
                      status: VaccineStatus.current,
                    ),
                  );
                  Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pet = repository.activePet;
    final vaccines = repository.activePetVaccinations;

    return Scaffold(
      backgroundColor: PawlyColors.background,
      appBar: AppBar(
        title: Text('${pet.name}’s Passport'),
        leading: IconButton(
          icon:  const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon:  const Icon(Icons.add_rounded),
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
                      color: PawlyColors.black.withOpacity(0.2),
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
                        const Text(
                          'CANINE HEALTH PASSPORT',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: Colors.white70,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'IMMUNIZED',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
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
                      style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.85)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text('RECORDED VACCINATIONS', style: PawlyTypography.eyebrow),
              const SizedBox(height: 12),

              if (vaccines.isEmpty)
                EmptyStateView(
                  
                  title: 'No vaccines logged',
                  subtitle: 'Add core boosters to keep an official digital record.',
                  buttonLabel: 'Add Vaccine Record',
                  onButtonPressed: () => _openAddVaccineDialog(context),
                )
              else
                ...vaccines.map((v) {
                  PawlyBadgeVariant badgeVariant;
                  String statusLabel;

                  switch (v.status) {
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
                            Text(v.vaccineName, style: PawlyTypography.titleMedium),
                            StatusBadge(label: statusLabel, variant: badgeVariant),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Given on', style: TextStyle(fontSize: 11, color: PawlyColors.tertiary)),
                                  const SizedBox(height: 2),
                                  Text(v.dateAdministered, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: PawlyColors.charcoal)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Next Booster Due', style: TextStyle(fontSize: 11, color: PawlyColors.tertiary)),
                                  const SizedBox(height: 2),
                                  Text(v.nextDueDate, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: PawlyColors.black)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${v.clinic} • ${v.veterinarian}',
                          style: const TextStyle(fontSize: 12, color: PawlyColors.secondary),
                        ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 20),

              PawlyButton(text: 'Add Vaccine to Passport',
                
                
                
                onPressed: () => _openAddVaccineDialog(context),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
