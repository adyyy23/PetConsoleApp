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
  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.repository.removeListener(_refresh);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.repository.addListener(_refresh);
  }

  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Overview', 'Care', 'Health', 'Memories'];

  final List<String> _presetPhotos = [
    'assets/pets/maple.png',
    'assets/pets/finn.png',
    'assets/pets/cleo.png',
    'assets/pets/pippin.png',
  ];

  Pet? _findPet() {
    final matches =
        widget.repository.pets.where((p) => p.id == widget.petId).toList();
    if (matches.isNotEmpty) return matches.first;
    return null;
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
      backgroundColor: PawlyColors.resolve(context, PawlyColors.surface),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Edit ${pet.name}’s Profile',
                        style: PawlyTypography.resolve(
                            context, PawlyTypography.titleLarge)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('CHANGE PORTRAIT',
                    style: PawlyTypography.resolve(
                        context, PawlyTypography.eyebrow)),
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
                              color: isSel
                                  ? PawlyColors.resolve(
                                      context, PawlyColors.black)
                                  : PawlyColors.resolve(
                                      context, PawlyColors.border),
                              width: isSel ? 2.5 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image(
                                image: pawlyImageProvider(url),
                                fit: BoxFit.contain),
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
                        value: ['Dog', 'Cat', 'Other'].contains(selectedSpecies)
                            ? selectedSpecies
                            : 'Dog',
                        decoration: const InputDecoration(labelText: 'Species'),
                        items: const [
                          DropdownMenuItem(value: 'Dog', child: Text('Dog')),
                          DropdownMenuItem(value: 'Cat', child: Text('Cat')),
                          DropdownMenuItem(
                              value: 'Other', child: Text('Other')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => selectedSpecies = val);
                          }
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
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration:
                            const InputDecoration(labelText: 'Weight (kg)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: ageCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration:
                            const InputDecoration(labelText: 'Age (years)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nicknameCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Nickname (optional)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesCtrl,
                  maxLines: 2,
                  decoration:
                      const InputDecoration(labelText: 'Personality Notes'),
                ),
                const SizedBox(height: 20),
                PawlyButton(
                  text: 'Save Changes',
                  onPressed: () {
                    final updated = pet.copyWith(
                      name: nameCtrl.text.trim().isNotEmpty
                          ? nameCtrl.text.trim()
                          : pet.name,
                      animalType: selectedSpecies,
                      breed: breedCtrl.text.trim().isNotEmpty
                          ? breedCtrl.text.trim()
                          : pet.breed,
                      weightKg: double.tryParse(weightCtrl.text.trim()) ??
                          pet.weightKg,
                      ageYears:
                          double.tryParse(ageCtrl.text.trim()) ?? pet.ageYears,
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
          style: PawlyTypography.resolve(context, PawlyTypography.bodyMedium),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: TextStyle(
                    color:
                        PawlyColors.resolve(context, PawlyColors.secondary))),
          ),
          TextButton(
            onPressed: () async {
              await widget.repository.deletePet(pet.id);
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              widget.onBack();
            },
            child: Text(
              'Delete Pet',
              style: TextStyle(
                  color: PawlyColors.resolve(context, PawlyColors.error),
                  fontWeight: FontWeight.w700),
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
        backgroundColor: PawlyColors.resolve(context, PawlyColors.background),
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

    final routines =
        widget.repository.routinesForDate(DateTime.now(), petId: pet.id);
    final healthEvents = widget.repository.allHealthEvents
        .where((h) => h.petId == pet.id)
        .toList();
    final vaccines = widget.repository.activePetVaccinations
        .where((v) => v.petId == pet.id)
        .toList();
    final memories = widget.repository.activePetMemories
        .where((m) => m.petId == pet.id)
        .toList();

    return Scaffold(
      backgroundColor: PawlyColors.resolve(context, PawlyColors.background),
      body: LayoutBuilder(
          builder: (context, constraints) => CustomScrollView(
                slivers: [
                  // Hero Collapsible Pet Header
                  SliverAppBar(
                    expandedHeight: constraints.maxWidth + kToolbarHeight,
                    pinned: true,
                    backgroundColor:
                        PawlyColors.resolve(context, PawlyColors.surface),
                    leading: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: AppTokens.rSm,
                          border: Border.all(color: Colors.white24, width: 0.8),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 16),
                      ),
                      tooltip: 'Back to pets',
                      onPressed: widget.onBack,
                    ),
                    actions: [
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            borderRadius: AppTokens.rSm,
                            border:
                                Border.all(color: Colors.white24, width: 0.8),
                          ),
                          child: const Icon(Icons.shield_outlined,
                              color: Colors.white, size: 18),
                        ),
                        onPressed: widget.onOpenEmergencyCard,
                      ),
                      PopupMenuButton<String>(
                        icon: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            borderRadius: AppTokens.rSm,
                            border:
                                Border.all(color: Colors.white24, width: 0.8),
                          ),
                          child: const Icon(Icons.more_vert_rounded,
                              color: Colors.white, size: 18),
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
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined,
                                    size: 18,
                                    color: PawlyColors.resolve(
                                        context, PawlyColors.black)),
                                const SizedBox(width: 10),
                                const Text('Edit Pet Details'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'weight',
                            child: Row(
                              children: [
                                Icon(Icons.monitor_weight_outlined,
                                    size: 18,
                                    color: PawlyColors.resolve(
                                        context, PawlyColors.black)),
                                const SizedBox(width: 10),
                                const Text('Record Weight'),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline_rounded,
                                    size: 18,
                                    color: PawlyColors.resolve(
                                        context, PawlyColors.error)),
                                const SizedBox(width: 10),
                                Text('Delete Pet',
                                    style: TextStyle(
                                        color: PawlyColors.resolve(
                                            context, PawlyColors.error))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                        background: Column(children: [
                      SizedBox(
                          height: kToolbarHeight +
                              MediaQuery.of(context).padding.top),
                      AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                              width: double.infinity,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Image(
                                  image: pawlyImageProvider(pet.imageUrl),
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Icon(Icons.pets,
                                      size: 64,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer)))),
                    ])),
                  ),
                  SliverToBoxAdapter(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Expanded(
                                      child: Text(pet.name,
                                          style: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w800))),
                                  StatusBadge(label: pet.animalType)
                                ]),
                                const SizedBox(height: 4),
                                Text(
                                    '${pet.breed} · ${pet.ageYears} years · ${pet.weightKg} kg',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                        fontSize: 13)),
                              ]))),

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
                            onTap: () =>
                                setState(() => _selectedTabIndex = index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? PawlyColors.black
                                    : Colors.white,
                                borderRadius: AppTokens.rSm,
                                border: Border.all(
                                  color: isSelected
                                      ? PawlyColors.black
                                      : PawlyColors.resolve(
                                          context, PawlyColors.border),
                                  width: 1.0,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _tabs[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : PawlyColors.resolve(
                                          context, PawlyColors.black),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.info_outline_rounded,
                                                color: PawlyColors.resolve(
                                                    context, PawlyColors.black),
                                                size: 18),
                                            const SizedBox(width: 8),
                                            Flexible(
                                                child: Text(
                                                    'Personality & Details',
                                                    style:
                                                        PawlyTypography.resolve(
                                                            context,
                                                            PawlyTypography
                                                                .titleMedium))),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          pet.notes.isNotEmpty
                                              ? pet.notes
                                              : '${pet.name} is a cherished companion in your household.',
                                          style: PawlyTypography.resolve(
                                              context,
                                              PawlyTypography.bodyLarge),
                                        ),
                                        if (pet.allergies.isNotEmpty) ...[
                                          const SizedBox(height: 12),
                                          Text(
                                            'ALLERGIES: ${pet.allergies}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: PawlyColors.resolve(
                                                  context,
                                                  PawlyColors.secondary),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Vitals Summary',
                                            style: PawlyTypography.resolve(
                                                context,
                                                PawlyTypography.titleMedium)),
                                        const SizedBox(height: 14),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Flexible(
                                                child: _VitalItem(
                                              label: 'WEIGHT',
                                              value: '${pet.weightKg} kg',
                                              onTap: widget.onOpenWeight,
                                            )),
                                            SizedBox(
                                                height: 36,
                                                child: VerticalDivider(
                                                    color: PawlyColors.resolve(
                                                        context,
                                                        PawlyColors.border))),
                                            Flexible(
                                                child: _VitalItem(
                                              label: 'AGE',
                                              value: '${pet.ageYears} yrs',
                                            )),
                                            SizedBox(
                                                height: 36,
                                                child: VerticalDivider(
                                                    color: PawlyColors.resolve(
                                                        context,
                                                        PawlyColors.border))),
                                            Flexible(
                                                child: _VitalItem(
                                              label: 'VACCINES',
                                              value: '${vaccines.length}',
                                              onTap: widget.onOpenVaccination,
                                            )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 14),

                                  // Actions Card
                                  SizedBox(
                                      width: double.infinity,
                                      child: PawlyCard(
                                          padding: EdgeInsets.zero,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        18, 18, 18, 8),
                                                    child: Text(
                                                        'Manage Companion',
                                                        style: PawlyTypography
                                                            .resolve(
                                                                context,
                                                                PawlyTypography
                                                                    .titleMedium))),
                                                ListTile(
                                                    leading: const Icon(
                                                        Icons.edit_outlined),
                                                    title: const Text(
                                                        'Edit Details'),
                                                    subtitle: const Text(
                                                        'Profile, photo and personality'),
                                                    trailing: const Icon(
                                                        Icons.chevron_right),
                                                    onTap: () =>
                                                        _showEditPetDialog(
                                                            pet)),
                                                const Divider(
                                                    height: 1,
                                                    indent: 18,
                                                    endIndent: 18),
                                                ListTile(
                                                    leading: const Icon(Icons
                                                        .monitor_weight_outlined),
                                                    title: const Text(
                                                        'Log Weight'),
                                                    subtitle: const Text(
                                                        'Track their growth over time'),
                                                    trailing: const Icon(
                                                        Icons.chevron_right),
                                                    onTap: widget.onOpenWeight),
                                                const Divider(
                                                    height: 1,
                                                    indent: 18,
                                                    endIndent: 18),
                                                ListTile(
                                                    leading: const Icon(
                                                        Icons.delete_outline),
                                                    title: const Text(
                                                        'Delete Pet'),
                                                    subtitle: const Text(
                                                        'Remove this pet and their records'),
                                                    trailing: const Icon(
                                                        Icons.chevron_right),
                                                    onTap: () =>
                                                        _showDeleteConfirmation(
                                                            pet)),
                                              ]))),
                                ],
                              );

                            // TAB 1: CARE
                            case 1:
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${pet.name}’s Routines',
                                          style: PawlyTypography.resolve(
                                              context,
                                              PawlyTypography.titleMedium)),
                                      TextButton(
                                        onPressed: widget.onOpenAddCare,
                                        child: Text('+ Add Care',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: PawlyColors.resolve(
                                                    context,
                                                    PawlyColors.black))),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (routines.isEmpty)
                                    EmptyStateView(
                                      title: 'No routines scheduled',
                                      subtitle:
                                          'Set up daily meals, walks, and medications.',
                                      buttonLabel: 'Add Routine',
                                      onButtonPressed: widget.onOpenAddCare,
                                    )
                                  else
                                    ...routines.map((r) => Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 8),
                                          child: CareTimelineItem(
                                            time: r.time,
                                            title: r.title,
                                            subtitle:
                                                '${r.category.displayName} · ${r.recurrence}',
                                            isCompleted: r.isCompleted,
                                            assignedTo: r.assignedTo,
                                            onToggle: () => widget.repository
                                                .toggleRoutine(r.id),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Health Records',
                                          style: PawlyTypography.resolve(
                                              context,
                                              PawlyTypography.titleMedium)),
                                      TextButton(
                                        onPressed: widget.onOpenAddHealth,
                                        child: Text('+ Log Record',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: PawlyColors.resolve(
                                                    context,
                                                    PawlyColors.black))),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (healthEvents.isEmpty)
                                    EmptyStateView(
                                      title: 'No health records yet',
                                      subtitle:
                                          'Log checkups, procedures, and clinical notes.',
                                      buttonLabel: 'Add Record',
                                      onButtonPressed: widget.onOpenAddHealth,
                                    )
                                  else
                                    ...healthEvents.map((h) => Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          child: PawlyCard(
                                            padding: const EdgeInsets.all(14),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    StatusBadge(label: h.type),
                                                    Text(h.date,
                                                        style: PawlyTypography
                                                            .resolve(
                                                                context,
                                                                PawlyTypography
                                                                    .caption)),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Text(h.title,
                                                    style:
                                                        PawlyTypography.resolve(
                                                            context,
                                                            PawlyTypography
                                                                .titleSmall)),
                                                if (h.notes.isNotEmpty) ...[
                                                  const SizedBox(height: 4),
                                                  Text(h.notes,
                                                      style: PawlyTypography
                                                          .resolve(
                                                              context,
                                                              PawlyTypography
                                                                  .bodyMedium)),
                                                ],
                                                if (h.clinic.isNotEmpty ||
                                                    h.veterinarian
                                                        .isNotEmpty) ...[
                                                  const SizedBox(height: 8),
                                                  Text(
                                                      'Vet: ${h.veterinarian} • ${h.clinic}',
                                                      style: PawlyTypography
                                                          .resolve(
                                                              context,
                                                              PawlyTypography
                                                                  .caption)),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Personal Moments',
                                          style: PawlyTypography.resolve(
                                              context,
                                              PawlyTypography.titleMedium)),
                                      TextButton(
                                        onPressed: widget.onOpenMemories,
                                        child: Text('+ Add Photo',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: PawlyColors.resolve(
                                                    context,
                                                    PawlyColors.black))),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (memories.isEmpty)
                                    EmptyStateView(
                                      title: 'No memories saved yet',
                                      subtitle:
                                          'Capture trips, milestones, and favorite moments together.',
                                      buttonLabel: 'Add First Memory',
                                      onButtonPressed: widget.onOpenMemories,
                                    )
                                  else
                                    ...memories.map((m) => Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 14),
                                          child: PawlyCard(
                                            padding: EdgeInsets.zero,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                          top: Radius.circular(
                                                              AppTokens.md)),
                                                  child: SizedBox(
                                                    height: 180,
                                                    width: double.infinity,
                                                    child: Image(
                                                      image: pawlyImageProvider(
                                                          m.imageUrl),
                                                      fit: BoxFit.contain,
                                                      errorBuilder:
                                                          (_, __, ___) =>
                                                              Container(
                                                        color:
                                                            PawlyColors.resolve(
                                                                context,
                                                                PawlyColors
                                                                    .surfaceWarm),
                                                        child: Icon(Icons.photo,
                                                            size: 48,
                                                            color: PawlyColors
                                                                .resolve(
                                                                    context,
                                                                    PawlyColors
                                                                        .tertiary)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(14),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              m.title,
                                                              style: PawlyTypography
                                                                  .resolve(
                                                                      context,
                                                                      PawlyTypography
                                                                          .titleSmall),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Text(m.date,
                                                              style: PawlyTypography
                                                                  .resolve(
                                                                      context,
                                                                      PawlyTypography
                                                                          .caption)),
                                                        ],
                                                      ),
                                                      if (m.caption
                                                          .isNotEmpty) ...[
                                                        const SizedBox(
                                                            height: 4),
                                                        Text(m.caption,
                                                            style: PawlyTypography
                                                                .resolve(
                                                                    context,
                                                                    PawlyTypography
                                                                        .bodyMedium)),
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
              )),
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
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: PawlyColors.resolve(context, PawlyColors.black)),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: PawlyTypography.resolve(context, PawlyTypography.eyebrow)
              .copyWith(fontSize: 10),
        ),
      ],
    );

    return onTap != null ? GestureDetector(onTap: onTap, child: item) : item;
  }
}
