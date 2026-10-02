import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';
import '../../models/pet.dart';

class AddFirstPetScreen extends StatefulWidget {
  final ValueChanged<Pet> onPetCreated;

  const AddFirstPetScreen({super.key, required this.onPetCreated});

  @override
  State<AddFirstPetScreen> createState() => _AddFirstPetScreenState();
}

class _AddFirstPetScreenState extends State<AddFirstPetScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController(text: '2');
  final TextEditingController _weightController = TextEditingController(text: '12.5');
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedSpecies = 'Dog';
  String _selectedGender = 'Male';
  String _selectedPhotoUrl =
      'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=600&q=80';

  final List<String> _speciesOptions = const ['Dog', 'Cat', 'Rabbit', 'Bird', 'Other'];

  final List<String> _presetPhotos = const [
    'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=600&q=80', // Golden
    'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&w=600&q=80', // French Bulldog
    'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=600&q=80', // British Cat
    'https://images.unsplash.com/photo-1574158622682-e40e69881006?auto=format&fit=crop&w=600&q=80', // Tabby
    'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?auto=format&fit=crop&w=600&q=80', // Bunny
  ];

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final newPet = Pet(
      id: 'pet_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      animalType: _selectedSpecies,
      breed: _breedController.text.trim().isEmpty ? 'Mixed Breed' : _breedController.text.trim(),
      ageYears: double.tryParse(_ageController.text.trim()) ?? 2.0,
      weightKg: double.tryParse(_weightController.text.trim()) ?? 10.0,
      gender: _selectedGender,
      imageUrl: _selectedPhotoUrl,
      allergies: _allergiesController.text.trim().isEmpty ? 'None reported' : _allergiesController.text.trim(),
      notes: _notesController.text.trim(),
      birthday: 'Approx. 2 years ago',
      category: 'Companion',
    );

    widget.onPetCreated(newPet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PawlyColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text('Who are we\ncaring for?', style: PawlyTypography.displayMedium),
              const SizedBox(height: 6),
              const Text(
                'Let’s set up your companion’s personal space. We’ll organize their daily care around them.',
                style: PawlyTypography.bodyLarge,
              ),

              const SizedBox(height: 28),

              // Portrait Selector
              const Text('Choose a portrait photo', style: PawlyTypography.labelLarge),
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
                            color: isSelected ? PawlyColors.black : PawlyColors.border,
                            width: isSelected ? 3 : 1.2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(photo, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Pet Name
              const Text('Pet Name *', style: PawlyTypography.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g. Mochi, Luna, Barnaby',
                  filled: true,
                  fillColor: PawlyColors.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
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
                        const Text('Species', style: PawlyTypography.labelLarge),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: PawlyColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: PawlyColors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedSpecies,
                              isExpanded: true,
                              items: _speciesOptions
                                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedSpecies = val);
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
                        const Text('Breed', style: PawlyTypography.labelLarge),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _breedController,
                          decoration: InputDecoration(
                            hintText: 'e.g. Retriever',
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

              const SizedBox(height: 20),

              // Age & Weight & Gender
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Age (years)', style: PawlyTypography.labelLarge),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '3',
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Weight (kg)', style: PawlyTypography.labelLarge),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: '28.5',
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Sex', style: PawlyTypography.labelLarge),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: PawlyColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: PawlyColors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedGender,
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(value: 'Male', child: Text('Male')),
                                DropdownMenuItem(value: 'Female', child: Text('Female')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedGender = val);
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
              const Text('Allergies & Sensitivities (optional)', style: PawlyTypography.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _allergiesController,
                decoration: InputDecoration(
                  hintText: 'e.g. Grass pollen, chicken allergy, or none',
                  filled: true,
                  fillColor: PawlyColors.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                ),
              ),

              const SizedBox(height: 20),

              // Important Notes
              const Text('Personality & Quirks (optional)', style: PawlyTypography.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'e.g. Loves belly rubs, afraid of thunderstorms, microchipped',
                  filled: true,
                  fillColor: PawlyColors.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: PawlyColors.border)),
                ),
              ),

              const SizedBox(height: 32),

              PawlyButton(text: 'Enter Pawly with My Pet',
                
                
                
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
