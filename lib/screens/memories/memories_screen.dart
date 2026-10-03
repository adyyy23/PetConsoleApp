import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../repositories/pawly_repository.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/widgets.dart';

class MemoriesScreen extends StatelessWidget {
  final PawlyRepository repository;

  const MemoriesScreen({
    super.key,
    required this.repository,
  });

  void _showAddMemoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          SingleChildScrollView(child: _AddMemorySheet(repository: repository)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        final pet = repository.selectedPet;
        final memories = repository.memoriesForPet(repository.selectedPetId);

        return Scaffold(
          backgroundColor: PawlyColors.resolve(context, PawlyColors.background),
          appBar: PawlyAppBar(
            title: 'Memories & Milestones',
            trailing: IconButton(
              icon: Icon(Icons.add_photo_alternate_rounded,
                  color: PawlyColors.resolve(context, PawlyColors.black),
                  size: 20),
              onPressed: () => _showAddMemoryModal(context),
            ),
          ),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Pet Switcher
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: PetSwitcher(
                    pets: repository.pets,
                    selectedPetId: repository.selectedPetId,
                    onPetSelected: repository.selectPet,
                  ),
                ),
              ),

              if (memories.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyStateView(
                    title: 'No Memories Captured',
                    subtitle:
                        'Save adoption milestones, puppyhood memories, and adventures with ${pet?.name ?? "your pet"}.',
                    actionLabel: 'Capture First Memory',
                    onAction: () => _showAddMemoryModal(context),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final memory = memories[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _MemoryCard(memory: memory),
                        );
                      },
                      childCount: memories.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MemoryCard extends StatelessWidget {
  final MemoryEntry memory;

  const _MemoryCard({required this.memory});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PawlyColors.resolve(context, PawlyColors.surface),
        borderRadius: AppTokens.rMd,
        border:
            Border.all(color: PawlyColors.resolve(context, PawlyColors.border)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with milestone tag overlay
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Image(
                  image: pawlyImageProvider(memory.imageUrl),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: PawlyColors.resolve(context, PawlyColors.border),
                    child: Center(
                      child: Icon(Icons.broken_image_rounded,
                          color: PawlyColors.resolve(
                              context, PawlyColors.tertiary),
                          size: 40),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: PawlyColors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    memory.milestoneType,
                    style: PawlyTypography.resolve(
                            context, PawlyTypography.eyebrow)
                        .copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Caption & Info
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        memory.title,
                        style: PawlyTypography.resolve(
                                context, PawlyTypography.titleMedium)
                            .copyWith(
                          fontWeight: FontWeight.w700,
                          color: PawlyColors.resolve(
                              context, PawlyColors.textPrimary),
                        ),
                      ),
                    ),
                    Text(
                      memory.date,
                      style: PawlyTypography.resolve(
                              context, PawlyTypography.eyebrow)
                          .copyWith(
                        color:
                            PawlyColors.resolve(context, PawlyColors.secondary),
                      ),
                    ),
                  ],
                ),
                if (memory.caption.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    memory.caption,
                    style: PawlyTypography.resolve(
                            context, PawlyTypography.bodyMedium)
                        .copyWith(
                      color:
                          PawlyColors.resolve(context, PawlyColors.secondary),
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddMemorySheet extends StatefulWidget {
  final PawlyRepository repository;

  const _AddMemorySheet({required this.repository});

  @override
  State<_AddMemorySheet> createState() => _AddMemorySheetState();
}

class _AddMemorySheetState extends State<_AddMemorySheet> {
  final _titleController = TextEditingController();
  final _captionController = TextEditingController();
  String _selectedMilestone = 'Milestone';
  String _selectedImageUrl = 'assets/pets/maple.png';

  final List<String> _milestones = [
    'Milestone',
    'Adoption Day',
    'Birthday',
    'Adventure',
    'New Trick',
    'Recovery',
  ];

  final List<String> _presetPhotos = [
    'assets/pets/maple.png',
    'assets/pets/finn.png',
    'assets/pets/cleo.png',
    'assets/pets/pippin.png',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Give your memory a title.')));
      return;
    }

    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final entry = MemoryEntry(
      id: 'mem_${DateTime.now().millisecondsSinceEpoch}',
      petId: widget.repository.selectedPetId,
      date: dateStr,
      title: title,
      caption: _captionController.text.trim(),
      imageUrl: _selectedImageUrl,
      milestoneType: _selectedMilestone,
    );

    await widget.repository.addMemory(entry);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PawlyColors.resolve(context, PawlyColors.surface),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: PawlyColors.resolve(context, PawlyColors.border),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Add New Memory',
              style:
                  PawlyTypography.resolve(context, PawlyTypography.titleMedium)
                      .copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),

            // Select image preset
            Text(
              'SELECT PHOTO',
              style: PawlyTypography.resolve(context, PawlyTypography.eyebrow)
                  .copyWith(
                color: PawlyColors.resolve(context, PawlyColors.secondary),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _presetPhotos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, idx) {
                  final url = _presetPhotos[idx];
                  final isSelected = _selectedImageUrl == url;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedImageUrl = url),
                    child: Container(
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? PawlyColors.black
                              : Colors.transparent,
                          width: 2.5,
                        ),
                        image: DecorationImage(
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
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Milestone Title',
                hintText: 'e.g. Mastered the roll over trick',
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _milestones.map((m) {
                final isSelected = _selectedMilestone == m;
                return ChoiceChip(
                  label: Text(m),
                  selected: isSelected,
                  selectedColor: PawlyColors.black.withOpacity(0.15),
                  backgroundColor:
                      PawlyColors.resolve(context, PawlyColors.background),
                  labelStyle:
                      PawlyTypography.resolve(context, PawlyTypography.eyebrow)
                          .copyWith(
                    color: isSelected
                        ? PawlyColors.black
                        : PawlyColors.resolve(context, PawlyColors.textPrimary),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedMilestone = m);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _captionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Story / Caption',
                hintText: 'What made today special...',
              ),
            ),
            const SizedBox(height: 20),

            PawlyButton(
              text: 'Save to Timeline',
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
