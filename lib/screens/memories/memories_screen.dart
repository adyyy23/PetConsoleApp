import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../repositories/pawly_repository.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
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
      builder: (_) => _AddMemorySheet(repository: repository),
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
          backgroundColor: PawlyColors.background,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: PawlyColors.surface,
                elevation: 0,
                pinned: true,
                expandedHeight: 120,
                leading: Navigator.canPop(context)
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: PawlyColors.textPrimary, size: 20),
                        onPressed: () => Navigator.pop(context),
                      )
                    : null,
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: PawlyColors.forest.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add_photo_alternate_rounded, color: PawlyColors.forest, size: 20),
                    ),
                    onPressed: () => _showAddMemoryModal(context),
                  ),
                  const SizedBox(width: 12),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  title: Text(
                    'Memories & Milestones',
                    style: PawlyTypography.titleMedium.copyWith(
                      color: PawlyColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

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
                    icon: Icons.photo_library_outlined,
                    title: 'No Memories Captured',
                    subtitle: 'Save adoption milestones, puppyhood memories, and adventures with ${pet?.name ?? "your pet"}.',
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
                          padding: const EdgeInsets.only(bottom: 24),
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
        color: PawlyColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: PawlyColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
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
                child: Image.network(
                  memory.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: PawlyColors.border,
                    child: const Center(
                      child: Icon(Icons.broken_image_rounded, color: PawlyColors.textMuted, size: 40),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: PawlyColors.deepEspresso.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    memory.milestoneType,
                    style: PawlyTypography.labelSmall.copyWith(
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
                        style: PawlyTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: PawlyColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      memory.date,
                      style: PawlyTypography.labelSmall.copyWith(
                        color: PawlyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (memory.caption.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    memory.caption,
                    style: PawlyTypography.bodyMedium.copyWith(
                      color: PawlyColors.textSecondary,
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
  String _selectedImageUrl = 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=800&q=80';

  final List<String> _milestones = [
    'Milestone',
    'Adoption Day',
    'Birthday',
    'Adventure',
    'New Trick',
    'Recovery',
  ];

  final List<String> _presetPhotos = [
    'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&w=800&q=80',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final now = DateTime.now();
    final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final entry = MemoryEntry(
      id: 'mem_${DateTime.now().millisecondsSinceEpoch}',
      petId: widget.repository.selectedPetId,
      date: dateStr,
      title: title,
      caption: _captionController.text.trim(),
      imageUrl: _selectedImageUrl,
      milestoneType: _selectedMilestone,
    );

    widget.repository.addMemory(entry);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: PawlyColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
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
                  color: PawlyColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Add New Memory',
              style: PawlyTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),

            // Select image preset
            Text(
              'SELECT PHOTO',
              style: PawlyTypography.labelSmall.copyWith(
                color: PawlyColors.textSecondary,
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
                          color: isSelected ? PawlyColors.forest : Colors.transparent,
                          width: 2.5,
                        ),
                        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
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
                  selectedColor: PawlyColors.forest.withOpacity(0.15),
                  backgroundColor: PawlyColors.background,
                  labelStyle: PawlyTypography.labelSmall.copyWith(
                    color: isSelected ? PawlyColors.forest : PawlyColors.textPrimary,
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
              icon: Icons.check_rounded,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
