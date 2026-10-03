import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../repositories/pawly_repository.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';

class AddAppointmentScreen extends StatefulWidget {
  final PawlyRepository repository;

  const AddAppointmentScreen({
    super.key,
    required this.repository,
  });

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _purposeController =
      TextEditingController(text: 'Annual Wellness Exam');
  final _clinicController = TextEditingController();
  final _vetController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 30);

  final List<String> _quickPurposes = [
    'Annual Wellness Exam',
    'Vaccination Booster',
    'Dental Cleaning',
    'Follow-up Consultation',
    'Dermatology Check',
    'Post-Op Check',
  ];

  @override
  void dispose() {
    _purposeController.dispose();
    _clinicController.dispose();
    _vetController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_purposeController.text.trim().isEmpty ||
        widget.repository.selectedPet == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Choose a pet and enter a visit purpose.')));
      return;
    }

    final formattedDate =
        '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
    final formattedTime =
        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

    final appt = Appointment(
      id: 'appt_${DateTime.now().millisecondsSinceEpoch}',
      petId: widget.repository.selectedPetId,
      date: formattedDate,
      time: formattedTime,
      purpose: _purposeController.text.trim(),
      clinic: _clinicController.text.trim(),
      vetName: _vetController.text.trim(),
      notes: _notesController.text.trim(),
    );

    await widget.repository.addAppointment(appt);

    // Also populate default prep items for this appointment
    await widget.repository.addVetPrepItem(
      VetPrepItem(
        id: 'prep_${DateTime.now().millisecondsSinceEpoch}_1',
        appointmentId: appt.id,
        text: 'Ask the clinic whether any preparation is needed',
      ),
    );
    await widget.repository.addVetPrepItem(
      VetPrepItem(
        id: 'prep_${DateTime.now().millisecondsSinceEpoch}_2',
        appointmentId: appt.id,
        text: 'Bring current medication containers',
      ),
    );
    await widget.repository.addVetPrepItem(
      VetPrepItem(
        id: 'prep_${DateTime.now().millisecondsSinceEpoch}_3',
        appointmentId: appt.id,
        text: 'List questions about appetite and energy changes',
      ),
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.repository.selectedPet;

    return Scaffold(
      backgroundColor: PawlyColors.resolve(context, PawlyColors.background),
      appBar: AppBar(
        backgroundColor: PawlyColors.resolve(context, PawlyColors.surface),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: PawlyColors.resolve(context, PawlyColors.textPrimary),
              size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Book Vet Visit',
          style: PawlyTypography.resolve(context, PawlyTypography.titleMedium)
              .copyWith(
            fontWeight: FontWeight.w700,
            color: PawlyColors.resolve(context, PawlyColors.textPrimary),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Indicator
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: PawlyColors.resolve(context, PawlyColors.surface),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: PawlyColors.resolve(context, PawlyColors.border)),
              ),
              child: Row(
                children: [
                  PawlyPetAvatar(imageUrl: pet?.imageUrl ?? '', size: 36),
                  const SizedBox(width: 12),
                  Flexible(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scheduling for ${pet?.name ?? "Pet"}',
                        style: PawlyTypography.resolve(
                                context, PawlyTypography.titleSmall)
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${pet?.breed ?? ""} • ${pet?.species ?? ""}',
                        style: PawlyTypography.resolve(
                                context, PawlyTypography.bodyMedium)
                            .copyWith(
                                color: PawlyColors.resolve(
                                    context, PawlyColors.secondary)),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Purpose Pills
            Text(
              'REASON FOR VISIT',
              style:
                  PawlyTypography.resolve(context, PawlyTypography.labelMedium)
                      .copyWith(
                color: PawlyColors.resolve(context, PawlyColors.secondary),
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickPurposes.map((p) {
                final isSelected = _purposeController.text == p;
                return ChoiceChip(
                  label: Text(p),
                  selected: isSelected,
                  selectedColor: PawlyColors.black.withOpacity(0.15),
                  backgroundColor:
                      PawlyColors.resolve(context, PawlyColors.surface),
                  labelStyle:
                      PawlyTypography.resolve(context, PawlyTypography.eyebrow)
                          .copyWith(
                    color: isSelected
                        ? PawlyColors.black
                        : PawlyColors.resolve(context, PawlyColors.textPrimary),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  onSelected: (val) {
                    if (val) {
                      setState(() => _purposeController.text = p);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _purposeController,
              decoration: const InputDecoration(
                labelText: 'Purpose / Specific Concerns',
                hintText: 'e.g. Annual exam, limping on left paw',
                prefixIcon: Icon(Icons.edit_note_rounded),
              ),
            ),
            const SizedBox(height: 24),

            // Date and Time Pickers
            Text(
              'DATE & TIME',
              style:
                  PawlyTypography.resolve(context, PawlyTypography.labelMedium)
                      .copyWith(
                color: PawlyColors.resolve(context, PawlyColors.secondary),
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color:
                            PawlyColors.resolve(context, PawlyColors.surface),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: PawlyColors.resolve(
                                context, PawlyColors.border)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_rounded,
                              color: PawlyColors.resolve(
                                  context, PawlyColors.black),
                              size: 20),
                          const SizedBox(width: 10),
                          Flexible(
                              child: Text(
                            '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                            style: PawlyTypography.resolve(
                                    context, PawlyTypography.bodyMedium)
                                .copyWith(fontWeight: FontWeight.w600),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (picked != null) {
                        setState(() => _selectedTime = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color:
                            PawlyColors.resolve(context, PawlyColors.surface),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: PawlyColors.resolve(
                                context, PawlyColors.border)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time_rounded,
                              color: PawlyColors.resolve(
                                  context, PawlyColors.black),
                              size: 20),
                          const SizedBox(width: 10),
                          Flexible(
                              child: Text(
                            _selectedTime.format(context),
                            style: PawlyTypography.resolve(
                                    context, PawlyTypography.bodyMedium)
                                .copyWith(fontWeight: FontWeight.w600),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Clinic & Doctor
            Text(
              'CLINIC & VETERINARIAN',
              style:
                  PawlyTypography.resolve(context, PawlyTypography.labelMedium)
                      .copyWith(
                color: PawlyColors.resolve(context, PawlyColors.secondary),
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _clinicController,
              decoration: const InputDecoration(
                labelText: 'Clinic Name',
                prefixIcon: Icon(Icons.local_hospital_outlined),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _vetController,
              decoration: const InputDecoration(
                labelText: 'Veterinarian Name (optional)',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Instructions / Notes',
                hintText: 'e.g. Fasting instructions, questions to ask...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 36),

            PawlyButton(
              text: 'Save Appointment',
              onPressed: _submit,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
