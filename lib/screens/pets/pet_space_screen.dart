import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../repositories/pawly_repository.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/widgets.dart';

class PetSpaceScreen extends StatefulWidget {
  final String petId;
  final PawlyRepository repository;
  final VoidCallback onBack;
  final VoidCallback onOpenAddCare;
  final VoidCallback onOpenAddHealth;
  final VoidCallback onOpenWeight;
  final VoidCallback onOpenVaccination;
  final VoidCallback onOpenMedication;
  final VoidCallback onOpenAppointments;
  final VoidCallback onOpenMemories;
  final VoidCallback onOpenDocuments;
  final VoidCallback onOpenEmergencyCard;

  const PetSpaceScreen({
    super.key,
    required this.petId,
    required this.repository,
    required this.onBack,
    required this.onOpenAddCare,
    required this.onOpenAddHealth,
    required this.onOpenWeight,
    required this.onOpenVaccination,
    required this.onOpenMedication,
    required this.onOpenAppointments,
    required this.onOpenMemories,
    required this.onOpenDocuments,
    required this.onOpenEmergencyCard,
  });

  @override
  State<PetSpaceScreen> createState() => _PetSpaceScreenState();
}

class _PetSpaceScreenState extends State<PetSpaceScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = const ['Overview', 'Care', 'Health', 'Memories'];

  final List<String> _presetPhotos = const [
    'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1574158622682-e40e69881006?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?auto=format&fit=crop&w=600&q=80',
  ];

  Pet? _findPet() {
    final matches = widget.repository.pets.where((p) => p.id == widget.petId).toList();
    if (matches.isNotEmpty) return matches.first;
    return widget.repository.selectedPet;
  }

  void _showEditPetDialog(Pet pet) {
    final nameCtrl = TextEditingController(text: pet.name);
    final breedCtrl = TextEditingController(text: pet.breed);
    final weightCtrl = TextEditingController(text: pet.weightKg.toString());
    final ageCtrl = TextEditingController(text: pet.ageYears.toString());
    final nicknameCtrl = TextEditingController(text: pet.nickname);
    final notesCtrl = TextEditingController(text: pet.notes);
    String selectedSpecies = pet.animalType;
    String selectedPhoto = pet.imageUrl;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Edit ${pet.name}’s Profile', style: PawlyTypography.titleLarge),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('CHANGE PORTRAIT', style: PawlyTypography.eyebrow),
                const SizedBox(height: 8),
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _presetPhotos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final url = _presetPhotos[i];
                      final isSel = url == selectedPhoto;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedPhoto = url),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSel ? PawlyColors.black : PawlyColors.border,
                              width: isSel ? 2.5 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(url, fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Pet Name'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: ['Dog', 'Cat', 'Other'].contains(selectedSpecies) ? selectedSpecies : 'Dog',
                        decoration: const InputDecoration(labelText: 'Species'),
                        items: const [
                          DropdownMenuItem(value: 'Dog', child: Text('Dog')),
                          DropdownMenuItem(value: 'Cat', child: Text('Cat')),
                          DropdownMenuItem(value: 'Other', child: Text('Other')),
                        ],
                        onChanged: (val) {
                          if (val != null) setModalState(() => selectedSpecies = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: breedCtrl,
                        decoration: const InputDecoration(labelText: 'Breed'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: weightCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Weight (kg)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: ageCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Age (years)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nicknameCtrl,
                  decoration: const InputDecoration(labelText: 'Nickname (optional)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Personality Notes'),
                ),
                const SizedBox(height: 20),
                PawlyButton(
                  text: 'Save Changes',
                  onPressed: () {
                    final updated = pet.copyWith(
                      name: nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : pet.name,
                      animalType: selectedSpecies,
                      breed: breedCtrl.text.trim().isNotEmpty ? breedCtrl.text.trim() : pet.breed,
                      weightKg: double.tryParse(weightCtrl.text.trim()) ?? pet.weightKg,
                      ageYears: double.tryParse(ageCtrl.text.trim()) ?? pet.ageYears,
                      nickname: nicknameCtrl.text.trim(),
                      notes: notesCtrl.text.trim(),
                      imageUrl: selectedPhoto,
                    );
                    widget.repository.updatePet(updated);
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Pet pet) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete ${pet.name}?'),
        content: Text(
          'This will permanently delete ${pet.name} and all associated care routines, health records, appointments, and memories. This action cannot be undone.',
          style: PawlyTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: PawlyColors.secondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.repository.deletePet(pet.id);
              widget.onBack();
            },
            child: const Text(
              'Delete Pet',
              style: TextStyle(color: PawlyColors.error, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pet = _findPet();

    if (pet == null) {
      return Scaffold(
        backgroundColor: PawlyColors.background,
        appBar: PawlyAppBar(
          title: 'Pet Profile',
          onBack: widget.onBack,
        ),
        body: Center(
          child: EmptyStateView(
            title: 'Pet Not Found',
            subtitle: 'This companion may have been removed.',
            buttonLabel: 'Go Back',
            onButtonPressed: widget.onBack,
          ),
        ),
      );
    }

    final routines = widget.repository.allRoutines.where((r) => r.petId == pet.id).toList();
    final healthEvents = widget.repository.allHealthEvents.where((h) => h.petId == pet.id).toList();
    final vaccines = widget.repository.activePetVaccinations.where((v) => v.petId == pet.id).toList();
    final memories = widget.repository.activePetMemories.where((m) => m.petId == pet.id).toList();

    return Scaffold(
      backgroundColor: PawlyColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero Collapsible Pet Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: PawlyColors.black,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: AppTokens.rSm,
                  border: Border.all(color: Colors.white24, width: 0.8),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
              ),
              onPressed: widget.onBack,
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: AppTokens.rSm,
                    border: Border.all(color: Colors.white24, width: 0.8),
                  ),
                  child: const Icon(Icons.shield_outlined, color: Colors.white, size: 18),
                ),
                onPressed: widget.onOpenEmergencyCard,
              ),
              PopupMenuButton<String>(
                icon: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: AppTokens.rSm,
                    border: Border.all(color: Colors.white24, width: 0.8),
                  ),
                  child: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 18),
                ),
                onSelected: (val) {
                  switch (val) {
                    case 'edit':
                      _showEditPetDialog(pet);
                      break;
                    case 'weight':
                      widget.onOpenWeight();
                      break;
                    case 'delete':
                      _showDeleteConfirmation(pet);
                      break;
                  }
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18, color: PawlyColors.black),
                        SizedBox(width: 10),
                        Text('Edit Pet Details'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'weight',
                    child: Row(
                      children: [
                        Icon(Icons.monitor_weight_outlined, size: 18, color: PawlyColors.black),
                        SizedBox(width: 10),
                        Text('Record Weight'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded, size: 18, color: PawlyColors.error),
                        SizedBox(width: 10),
                        Text('Delete Pet', style: TextStyle(color: PawlyColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    pet.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: PawlyColors.charcoal),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.transparent,
                          Colors.black.withOpacity(0.85),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppTokens.pill),
                              ),
                              child: Text(
                                pet.animalType.toUpperCase(),
                                style: const TextStyle(
                                  color: PawlyColors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              pet.gender,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          pet.name,
                          style: PawlyTypography.display.copyWith(color: Colors.white, fontSize: 32),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${pet.breed} • ${pet.ageYears} yrs • ${pet.weightKg} kg',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 0.2,
                          ),
                        ),
                        if (pet.nickname.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            '“${pet.nickname}”',
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Standardized 4 Profile Tabs (Overview, Care, Health, Memories)
          SliverToBoxAdapter(
            child: Container(
              height: 42,
              margin: const EdgeInsets.only(top: 14, bottom: 8),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedTabIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTabIndex = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? PawlyColors.black : Colors.white,
                        borderRadius: AppTokens.rSm,
                        border: Border.all(
                          color: isSelected ? PawlyColors.black : PawlyColors.border,
                          width: 1.0,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _tabs[index],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? Colors.white : PawlyColors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Tab Contents
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
            sliver: SliverToBoxAdapter(
              child: Builder(
                builder: (context) {
                  switch (_selectedTabIndex) {
                    // TAB 0: OVERVIEW
                    case 0:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PawlyCard(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.info_outline_rounded, color: PawlyColors.black, size: 18),
                                    SizedBox(width: 8),
                                    Text('Personality & Details', style: PawlyTypography.titleMedium),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  pet.notes.isNotEmpty
                                      ? pet.notes
                                      : '${pet.name} is a cherished companion in your household.',
                                  style: PawlyTypography.bodyLarge,
                                ),
                                if (pet.allergies.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    'ALLERGIES: ${pet.allergies}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: PawlyColors.secondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Vitals Row
                          PawlyCard(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Vitals Summary', style: PawlyTypography.titleMedium),
                                const SizedBox(height: 14),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _VitalItem(
                                      label: 'WEIGHT',
                                      value: '${pet.weightKg} kg',
                                      onTap: widget.onOpenWeight,
                                    ),
                                    const SizedBox(height: 36, child: VerticalDivider(color: PawlyColors.border)),
                                    _VitalItem(
                                      label: 'AGE',
                                      value: '${pet.ageYears} yrs',
                                    ),
                                    const SizedBox(height: 36, child: VerticalDivider(color: PawlyColors.border)),
                                    _VitalItem(
                                      label: 'VACCINES',
                                      value: '${vaccines.length}',
                                      onTap: widget.onOpenVaccination,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Actions Card
                          PawlyCard(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Manage Companion', style: PawlyTypography.titleMedium),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    PawlyButton(
                                      text: 'Edit Details',
                                      isSmall: true,
                                      isSecondary: true,
                                      onPressed: () => _showEditPetDialog(pet),
                                    ),
                                    PawlyButton(
                                      text: 'Log Weight',
                                      isSmall: true,
                                      isSecondary: true,
                                      onPressed: widget.onOpenWeight,
                                    ),
                                    PawlyButton(
                                      text: 'Delete Pet',
                                      isSmall: true,
                                      isSecondary: true,
                                      onPressed: () => _showDeleteConfirmation(pet),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );

                    // TAB 1: CARE
                    case 1:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${pet.name}’s Routines', style: PawlyTypography.titleMedium),
                              TextButton(
                                onPressed: widget.onOpenAddCare,
                                child: const Text('+ Add Care', style: TextStyle(fontWeight: FontWeight.w700, color: PawlyColors.black)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (routines.isEmpty)
                            EmptyStateView(
                              title: 'No routines scheduled',
                              subtitle: 'Set up daily meals, walks, and medications.',
                              buttonLabel: 'Add Routine',
                              onButtonPressed: widget.onOpenAddCare,
                            )
                          else
                            ...routines.map((r) => Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: CareTimelineItem(
                                    time: r.time,
                                    title: r.title,
                                    subtitle: '${r.category.displayName} · ${r.recurrence}',
                                    isCompleted: r.isCompleted,
                                    assignedTo: r.assignedTo,
                                    onToggle: () => widget.repository.toggleRoutine(r.id),
                                  ),
                                )),
                        ],
                      );

                    // TAB 2: HEALTH
                    case 2:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Health Records', style: PawlyTypography.titleMedium),
                              TextButton(
                                onPressed: widget.onOpenAddHealth,
                                child: const Text('+ Log Record', style: TextStyle(fontWeight: FontWeight.w700, color: PawlyColors.black)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (healthEvents.isEmpty)
                            EmptyStateView(
                              title: 'No health records yet',
                              subtitle: 'Log checkups, procedures, and clinical notes.',
                              buttonLabel: 'Add Record',
                              onButtonPressed: widget.onOpenAddHealth,
                            )
                          else
                            ...healthEvents.map((h) => Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: PawlyCard(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            StatusBadge(label: h.type),
                                            Text(h.date, style: PawlyTypography.caption),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(h.title, style: PawlyTypography.titleSmall),
                                        if (h.notes.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(h.notes, style: PawlyTypography.bodyMedium),
                                        ],
                                        if (h.clinic.isNotEmpty || h.veterinarian.isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          Text('Vet: ${h.veterinarian} • ${h.clinic}', style: PawlyTypography.caption),
                                        ],
                                      ],
                                    ),
                                  ),
                                )),
                        ],
                      );

                    // TAB 3: MEMORIES
                    case 3:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Personal Moments', style: PawlyTypography.titleMedium),
                              TextButton(
                                onPressed: widget.onOpenMemories,
                                child: const Text('+ Add Photo', style: TextStyle(fontWeight: FontWeight.w700, color: PawlyColors.black)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (memories.isEmpty)
                            EmptyStateView(
                              title: 'No memories saved yet',
                              subtitle: 'Capture trips, milestones, and favorite moments together.',
                              buttonLabel: 'Add First Memory',
                              onButtonPressed: widget.onOpenMemories,
                            )
                          else
                            ...memories.map((m) => Container(
                                  margin: const EdgeInsets.only(bottom: 14),
                                  child: PawlyCard(
                                    padding: EdgeInsets.zero,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTokens.md)),
                                          child: SizedBox(
                                            height: 180,
                                            width: double.infinity,
                                            child: Image.network(
                                              m.imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => Container(
                                                color: PawlyColors.surfaceWarm,
                                                child: const Icon(Icons.photo, size: 48, color: PawlyColors.tertiary),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      m.title,
                                                      style: PawlyTypography.titleSmall,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text(m.date, style: PawlyTypography.caption),
                                                ],
                                              ),
                                              if (m.caption.isNotEmpty) ...[
                                                const SizedBox(height: 4),
                                                Text(m.caption, style: PawlyTypography.bodyMedium),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                        ],
                      );

                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VitalItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _VitalItem({
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final item = Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: PawlyColors.black),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: PawlyTypography.eyebrow.copyWith(fontSize: 10),
        ),
      ],
    );

    return onTap != null ? GestureDetector(onTap: onTap, child: item) : item;
  }
}
