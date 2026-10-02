import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';
import '../../models/models.dart';
import '../../repositories/pawly_repository.dart';

class MedicationScreen extends StatelessWidget {
  final PawlyRepository repository;

  const MedicationScreen({super.key, required this.repository});

  void _openAddMedicationDialog(BuildContext context) {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    final freqController = TextEditingController(text: 'Once daily with meal');
    final instructionsController = TextEditingController();

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
            const Text('Add Prescribed Medication', style: PawlyTypography.titleLarge),
            const SizedBox(height: 6),
            const Text('Keep dosage schedules and administration instructions clear.', style: PawlyTypography.bodyMedium),
            const SizedBox(height: 20),
            const Text('Medication Name *', style: PawlyTypography.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'e.g. Apoquel, Amoxicillin, NexGard',
                filled: true,
                fillColor: PawlyColors.surfaceWarm,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Dosage', style: PawlyTypography.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: dosageController,
              decoration: InputDecoration(
                hintText: 'e.g. 16mg, 1 tablet, 2.5ml',
                filled: true,
                fillColor: PawlyColors.surfaceWarm,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Frequency', style: PawlyTypography.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: freqController,
              decoration: InputDecoration(
                hintText: 'Once daily with food',
                filled: true,
                fillColor: PawlyColors.surfaceWarm,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Instructions / Notes', style: PawlyTypography.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: instructionsController,
              decoration: InputDecoration(
                hintText: 'e.g. Take with morning kibble, complete full 10-day course',
                filled: true,
                fillColor: PawlyColors.surfaceWarm,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
              ),
            ),
            const SizedBox(height: 24),
            PawlyButton(text: 'Save Medication',
              
              
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  final now = DateTime.now();
                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                  final dateStr = '${months[now.month - 1]} ${now.day.toString().padLeft(2, '0')}, ${now.year}';
                  repository.addMedication(
                    Medication(
                      id: 'med_${DateTime.now().millisecondsSinceEpoch}',
                      petId: repository.activePet.id,
                      name: name,
                      dosage: dosageController.text.trim().isEmpty ? 'As directed' : dosageController.text.trim(),
                      frequency: freqController.text.trim(),
                      instructions: instructionsController.text.trim(),
                      startDate: dateStr,
                      endDate: 'Ongoing',
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
    final medications = repository.activePetMedications;

    return Scaffold(
      backgroundColor: PawlyColors.background,
      appBar: AppBar(
        title: Text('${pet.name}’s Medications'),
        leading: IconButton(
          icon:  const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon:  const Icon(Icons.add_rounded),
            onPressed: () => _openAddMedicationDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ACTIVE MEDICATIONS', style: PawlyTypography.eyebrow),
              const SizedBox(height: 12),

              if (medications.isEmpty)
                EmptyStateView(
                  
                  title: 'No active prescriptions',
                  subtitle: 'Track allergy treatments, antibiotics, or chronic condition pills.',
                  buttonLabel: 'Add Prescription',
                  onButtonPressed: () => _openAddMedicationDialog(context),
                )
              else
                ...medications.map((m) => Container(
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
                              Text(m.name, style: PawlyTypography.titleMedium),
                              const StatusBadge(label: 'Active', ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Dosage: ${m.dosage} • ${m.frequency}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: PawlyColors.black),
                          ),
                          if (m.instructions.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(m.instructions, style: PawlyTypography.bodyMedium),
                          ],
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Started: ${m.startDate}', style: const TextStyle(fontSize: 11, color: PawlyColors.tertiary)),
                              Text('Ends: ${m.endDate}', style: const TextStyle(fontSize: 11, color: PawlyColors.tertiary)),
                            ],
                          ),
                        ],
                      ),
                    )),

              const SizedBox(height: 20),

              PawlyButton(text: 'Add Medication Prescription',
                
                
                
                onPressed: () => _openAddMedicationDialog(context),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
