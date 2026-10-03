import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';
import '../../models/pet.dart';

class AddFirstPetScreen extends StatefulWidget {
  final Future<void> Function(Pet) onPetCreated;
  final VoidCallback? onBack;

  const AddFirstPetScreen({super.key, required this.onPetCreated, this.onBack});

  @override
  State<AddFirstPetScreen> createState() => _AddFirstPetScreenState();
}

class _AddFirstPetScreenState extends State<AddFirstPetScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedSpecies = 'Dog';
  String _selectedGender = 'Male';
  String _selectedPhotoUrl = '';

  final List<String> _speciesOptions = [
    'Dog',
    'Cat',
    'Rabbit',
    'Bird',
    'Other'
  ];

  final List<String> _presetPhotos = [
    'assets/pets/maple.png', // Golden
    'assets/pets/finn.png', // Beagle
    'assets/pets/cleo.png', // British Cat
    'assets/pets/pippin.png', // Bunny
  ];

  String? _error;
  bool _saving = false;
  final _photoController = TextEditingController();
  @override
  void dispose() {
    for (final controller in [
      _nameController,
      _breedController,
      _ageController,
      _weightController,
      _allergiesController,
      _notesController,
      _photoController
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving) return;
    final name = _nameController.text.trim();
    final age = double.tryParse(_ageController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());
    if (name.isEmpty ||
        age == null ||
        !age.isFinite ||
        age < 0 ||
        weight == null ||
        !weight.isFinite ||
        weight <= 0) {
      setState(() => _error =
          'Enter a name, age of zero or more, and a weight above zero.');
      return;
    }
    final photo = _photoController.text.trim();
    if (photo.isNotEmpty && Uri.tryParse(photo)?.scheme != 'https') {
      setState(
          () => _error = 'Use a full https photo link, or leave it empty.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });

    final newPet = Pet(
      id: 'pet_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      animalType: _selectedSpecies,
      breed: _breedController.text.trim().isEmpty
          ? 'Mixed Breed'
          : _breedController.text.trim(),
      ageYears: age,
      weightKg: weight,
      gender: _selectedGender,
      imageUrl: photo.isEmpty ? _selectedPhotoUrl : photo,
      allergies: _allergiesController.text.trim().isEmpty
          ? 'None reported'
          : _allergiesController.text.trim(),
      notes: _notesController.text.trim(),
      birthday: '',
      category: 'Companion',
    );

    try {
      await widget.onPetCreated(newPet);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Couldn’t save your pet. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PawlyColors.resolve(context, PawlyColors.background),
      appBar: PawlyAppBar(title: 'Add your companion', onBack: widget.onBack),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text('Who are we\ncaring for?',
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.displayMedium)),
              const SizedBox(height: 6),
              Text(
                'Let’s set up your companion’s personal space. We’ll organize their daily care around them.',
                style:
                    PawlyTypography.resolve(context, PawlyTypography.bodyLarge),
              ),

              const SizedBox(height: 28),

              // Portrait Selector
              Text('Choose a sample portrait',
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.labelLarge)),
              const SizedBox(height: 10),
              SizedBox(
                height: 72,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _presetPhotos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final photo = _presetPhotos[i];
                    final isSelected = photo == _selectedPhotoUrl;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedPhotoUrl = photo),
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected
                                ? PawlyColors.black
                                : PawlyColors.resolve(
                                    context, PawlyColors.border),
                            width: isSelected ? 3 : 1.2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image(
                              image: pawlyImageProvider(photo),
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.pets)),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              TextField(
                  controller: _photoController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                      labelText: 'Your own photo URL (optional)',
                      hintText: 'https://…')),
              const SizedBox(height: 20),
              if (_error != null)
                Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(_error!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error))),
              // Pet Name
              Text('Pet Name *',
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.labelLarge)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g. Maple, Cleo, Pippin',
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

              // Species & Breed
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Species',
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
                              value: _selectedSpecies,
                              isExpanded: true,
                              items: _speciesOptions
                                  .map((s) => DropdownMenuItem(
                                      value: s, child: Text(s)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedSpecies = val);
                                }
                              },
                            ),
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
                        Text('Breed',
                            style: PawlyTypography.resolve(
                                context, PawlyTypography.labelLarge)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _breedController,
                          decoration: InputDecoration(
                            hintText: 'e.g. Retriever',
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

              const SizedBox(height: 20),

              // Age & Weight & Gender
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Age (years)',
                            style: PawlyTypography.resolve(
                                context, PawlyTypography.labelLarge)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '3',
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Weight (kg)',
                            style: PawlyTypography.resolve(
                                context, PawlyTypography.labelLarge)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: InputDecoration(
                            hintText: '28.5',
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sex',
                            style: PawlyTypography.resolve(
                                context, PawlyTypography.labelLarge)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
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
                              value: _selectedGender,
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(
                                    value: 'Male', child: Text('Male')),
                                DropdownMenuItem(
                                    value: 'Female', child: Text('Female')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedGender = val);
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

              // Known Allergies
              Text('Allergies & Sensitivities (optional)',
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.labelLarge)),
              const SizedBox(height: 8),
              TextField(
                controller: _allergiesController,
                decoration: InputDecoration(
                  hintText: 'e.g. Grass pollen, chicken allergy, or none',
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

              // Important Notes
              Text('Personality & Quirks (optional)',
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.labelLarge)),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText:
                      'e.g. Loves belly rubs, afraid of thunderstorms, microchipped',
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
                text: 'Enter Pawly with My Pet',
                onPressed: _submit,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
