import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';
import '../../models/models.dart';
import '../../repositories/pawly_repository.dart';

class AddHealthEventScreen extends StatefulWidget {
  final PawlyRepository repository;
  final VoidCallback onSaved;

  const AddHealthEventScreen(
      {super.key, required this.repository, required this.onSaved});

  @override
  State<AddHealthEventScreen> createState() => _AddHealthEventScreenState();
}

class _AddHealthEventScreenState extends State<AddHealthEventScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _vetController = TextEditingController();
  final TextEditingController _clinicController = TextEditingController();

  String _eventType = 'Checkup';
  final List<String> _types = [
    'Checkup',
    'Vaccination',
    'Medication',
    'Procedure',
    'Dentistry',
    'Observation'
  ];

  String? _error;
  bool _saving = false;
  @override
  void dispose() {
    for (final controller in [
      _titleController,
      _notesController,
      _vetController,
      _clinicController
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_saving) return;
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _error = 'Give this health record a title.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });

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

    final petId = widget.repository.selectedPetId.isNotEmpty
        ? widget.repository.selectedPetId
        : widget.repository.activePet.id;

    final event = HealthEvent(
      id: 'health_${DateTime.now().millisecondsSinceEpoch}',
      petId: petId,
      date: dateStr,
      title: title,
      type: _eventType,
      notes: _notesController.text.trim(),
      veterinarian: _vetController.text.trim(),
      clinic: _clinicController.text.trim(),
    );

    try {
      await widget.repository.addHealthEvent(event);
      if (mounted) widget.onSaved();
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Couldn’t save this record. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PawlyColors.resolve(context, PawlyColors.background),
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
              if (_error != null)
                Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(_error!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error))),
              Text('Event Type',
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.labelLarge)),
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
                    backgroundColor:
                        PawlyColors.resolve(context, PawlyColors.surface),
                    selectedColor: PawlyColors.black,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : PawlyColors.resolve(context, PawlyColors.charcoal),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected
                            ? PawlyColors.resolve(
                                context, PawlyColors.surfaceWarm)
                            : PawlyColors.resolve(context, PawlyColors.border),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text('Event Title *',
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.labelLarge)),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText:
                      'e.g. Annual physical, Core DHPP booster, Cytology exam',
                  filled: true,
                  fillColor: PawlyColors.resolve(context, PawlyColors.surface),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: PawlyColors.resolve(
                              context, PawlyColors.border))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: PawlyColors.resolve(
                              context, PawlyColors.border))),
                ),
              ),
              const SizedBox(height: 20),
              Text('Clinical Notes & Observations',
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.labelLarge)),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText:
                      'e.g. Normal vitals, ears clear, no adverse reaction observed.',
                  filled: true,
                  fillColor: PawlyColors.resolve(context, PawlyColors.surface),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: PawlyColors.resolve(
                              context, PawlyColors.border))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: PawlyColors.resolve(
                              context, PawlyColors.border))),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Veterinarian',
                            style: PawlyTypography.resolve(
                                context, PawlyTypography.labelLarge)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _vetController,
                          decoration: InputDecoration(
                            hintText: 'Dr. Sarah Ramos',
                            filled: true,
                            fillColor: PawlyColors.resolve(
                                context, PawlyColors.surface),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: PawlyColors.resolve(
                                        context, PawlyColors.border))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: PawlyColors.resolve(
                                        context, PawlyColors.border))),
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
                        Text('Clinic',
                            style: PawlyTypography.resolve(
                                context, PawlyTypography.labelLarge)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _clinicController,
                          decoration: InputDecoration(
                            hintText: 'CityVet Center',
                            filled: true,
                            fillColor: PawlyColors.resolve(
                                context, PawlyColors.surface),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: PawlyColors.resolve(
                                        context, PawlyColors.border))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: PawlyColors.resolve(
                                        context, PawlyColors.border))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              PawlyButton(
                text: _saving ? 'Saving…' : 'Save Health Event',
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
