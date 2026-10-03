import 'package:flutter/material.dart';
import '../../models/care_schedule.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';
import '../../models/care_routine.dart';
import '../../repositories/pawly_repository.dart';

class AddCareScreen extends StatefulWidget {
  final PawlyRepository repository;
  final VoidCallback onSaved;

  const AddCareScreen(
      {super.key, required this.repository, required this.onSaved});

  @override
  State<AddCareScreen> createState() => _AddCareScreenState();
}

class _AddCareScreenState extends State<AddCareScreen> {
  CareCategory _selectedCategory = CareCategory.medication;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController =
      TextEditingController(text: '08:00 AM');
  final TextEditingController _notesController = TextEditingController();

  String _recurrence = 'Daily';
  final String _priority = 'Medium';
  late String _selectedPetId;

  @override
  void initState() {
    super.initState();
    _selectedPetId = widget.repository.selectedPetId;
  }

  String? _error;
  bool _saving = false;
  DateTime _startDate = DateTime.now();
  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_saving) return;
    final title = _titleController.text.trim();
    if (title.isEmpty ||
        _selectedPetId.isEmpty ||
        CareSchedule.minutes(_timeController.text) >= 1440) {
      setState(() =>
          _error = 'Choose a pet, enter a title and choose a valid time.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });

    final routine = CareRoutine(
      id: 'care_${DateTime.now().millisecondsSinceEpoch}',
      petId: _selectedPetId,
      title: title,
      time: _timeController.text.trim(),
      date: CareSchedule.dayKey(_startDate),
      category: _selectedCategory,
      priority: _priority,
      recurrence: _recurrence,
      notes: _notesController.text.trim(),
    );

    try {
      await widget.repository.addRoutine(routine);
      if (mounted) widget.onSaved();
    } catch (_) {
      if (mounted) {
        setState(
            () => _error = 'Couldn’t save this routine. Please try again.');
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
        title: const Text('Add Care Routine'),
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
              // Which Pet?
              Text('Which pet is this for?',
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.labelLarge)),
              const SizedBox(height: 10),
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.repository.pets.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final pet = widget.repository.pets[i];
                    final isSelected = pet.id == _selectedPetId;
                    return ChoiceChip(
                      label: Text(pet.name),
                      selected: isSelected,
                      onSelected: (_) =>
                          setState(() => _selectedPetId = pet.id),
                      backgroundColor:
                          PawlyColors.resolve(context, PawlyColors.surface),
                      selectedColor: PawlyColors.black,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : PawlyColors.resolve(
                                context, PawlyColors.charcoal),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSelected
                              ? PawlyColors.black
                              : PawlyColors.resolve(
                                  context, PawlyColors.border),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Care Category Selector
              Text('Care Category',
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.labelLarge)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: CareCategory.values.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat.displayName),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    backgroundColor:
                        PawlyColors.resolve(context, PawlyColors.surface),
                    selectedColor:
                        PawlyColors.resolve(context, PawlyColors.charcoal),
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
                            ? PawlyColors.resolve(context, PawlyColors.charcoal)
                            : PawlyColors.resolve(context, PawlyColors.border),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Title
              Text('Routine Title *',
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.labelLarge)),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'e.g. Apoquel 16mg, Evening walk, Timothy hay',
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

              // Time & Recurrence
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Scheduled Time',
                            style: PawlyTypography.resolve(
                                context, PawlyTypography.labelLarge)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _timeController,
                          readOnly: true,
                          onTap: () async {
                            final time = await showTimePicker(
                                context: context,
                                initialTime:
                                    const TimeOfDay(hour: 8, minute: 0));
                            if (time != null) {
                              _timeController.text =
                                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                            }
                          },
                          decoration: InputDecoration(
                            hintText: '08:00 AM',
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
                        Text('Recurrence',
                            style: PawlyTypography.resolve(
                                context, PawlyTypography.labelLarge)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: PawlyColors.resolve(
                                context, PawlyColors.surface),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: PawlyColors.resolve(
                                    context, PawlyColors.border)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _recurrence,
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(
                                    value: 'Daily', child: Text('Daily')),
                                DropdownMenuItem(
                                    value: 'Weekly', child: Text('Weekly')),
                                DropdownMenuItem(
                                    value: 'Monthly', child: Text('Monthly')),
                                DropdownMenuItem(
                                    value: 'Once', child: Text('Once')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _recurrence = val);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text('Starts on'),
                  subtitle: Text(CareSchedule.dayKey(_startDate)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100));
                    if (date != null) setState(() => _startDate = date);
                  }),
              if (_error != null)
                Text(_error!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              const SizedBox(height: 16),
              // Instructions / Notes
              Text('Instructions / Meal Amount / Notes',
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.labelLarge)),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'e.g. Give with breakfast kibble, do not skip dose',
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

              const SizedBox(height: 32),

              PawlyButton(
                text: _saving ? 'Saving…' : 'Save Care Routine',
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
