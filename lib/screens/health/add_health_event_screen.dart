import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';
import '../../models/models.dart';
import '../../repositories/pawly_repository.dart';

class AddHealthEventScreen extends StatefulWidget {
  final PawlyRepository repository;
  final VoidCallback onSaved;

  const AddHealthEventScreen({super.key, required this.repository, required this.onSaved});

  @override
  State<AddHealthEventScreen> createState() => _AddHealthEventScreenState();
}

class _AddHealthEventScreenState extends State<AddHealthEventScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _vetController = TextEditingController(text: 'Dr. Sarah Ramos, DVM');
  final TextEditingController _clinicController = TextEditingController(text: 'CityVet Wellness Center');

  String _eventType = 'Checkup';
  final List<String> _types = const ['Checkup', 'Vaccination', 'Medication', 'Procedure', 'Dentistry', 'Observation'];

  void _handleSave() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final event = HealthEvent(
      id: 'health_${DateTime.now().millisecondsSinceEpoch}',
      petId: widget.repository.selectedPetId,
      date: 'Today',
      title: title,
      type: _eventType,
      notes: _notesController.text.trim(),
      veterinarian: _vetController.text.trim(),
      clinic: _clinicController.text.trim(),
    );

    widget.repository.addHealthEvent(event);
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PawlyColors.creamBg,
      appBar: AppBar(
        title: const Text('Log Health Event'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Event Type', style: PawlyTypography.labelLarge),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _types.map((t) {
                  final isSelected = _eventType == t;
                  return ChoiceChip(
                    label: Text(t),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _eventType = t),
                    backgroundColor: PawlyColors.surface,
                    selectedColor: PawlyColors.clay,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : PawlyColors.charcoal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected ? PawlyColors.clay : PawlyColors.border,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              const Text('Event Title *', style: PawlyTypography.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'e.g. Annual physical, Core DHPP booster, Cytology exam',
                  filled: true,
                  fillColor: PawlyColors.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                ),
              ),

              const SizedBox(height: 20),

              const Text('Clinical Notes & Observations', style: PawlyTypography.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'e.g. Normal vitals, ears clear, no adverse reaction observed.',
                  filled: true,
                  fillColor: PawlyColors.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Veterinarian', style: PawlyTypography.labelLarge),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _vetController,
                          decoration: InputDecoration(
                            hintText: 'Dr. Sarah Ramos',
                            filled: true,
                            fillColor: PawlyColors.surface,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Clinic', style: PawlyTypography.labelLarge),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _clinicController,
                          decoration: InputDecoration(
                            hintText: 'CityVet Center',
                            filled: true,
                            fillColor: PawlyColors.surface,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              PawlyButton(
                label: 'Save Health Event',
                icon: Icons.check,
                isFullWidth: true,
                variant: PawlyButtonVariant.clay,
                onPressed: _handleSave,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
