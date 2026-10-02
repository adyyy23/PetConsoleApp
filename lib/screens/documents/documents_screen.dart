import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../repositories/pawly_repository.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/widgets.dart';

class DocumentsScreen extends StatefulWidget {
  final PawlyRepository repository;

  const DocumentsScreen({
    super.key,
    required this.repository,
  });

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Vaccination',
    'Lab Result',
    'Prescription',
    'Insurance',
    'Registration',
  ];

  void _showAddDocumentModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddDocumentSheet(repository: widget.repository),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.repository,
      builder: (context, _) {
        final pet = widget.repository.selectedPet;
        final allDocs = widget.repository.documentsForPet(widget.repository.selectedPetId);
        final filteredDocs = _selectedCategory == 'All'
            ? allDocs
            : allDocs.where((d) => d.category == _selectedCategory).toList();

        return Scaffold(
          backgroundColor: PawlyColors.background,
          appBar: PawlyAppBar(
            title: 'Document Wallet',
            trailing: IconButton(
              icon:  const Icon(Icons.upload_file_rounded, color: PawlyColors.black, size: 20),
              onPressed: _showAddDocumentModal,
            ),
          ),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Pet Switcher
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: PetSwitcher(
                    pets: widget.repository.pets,
                    selectedPetId: widget.repository.selectedPetId,
                    onPetSelected: widget.repository.selectPet,
                  ),
                ),
              ),

              // Category Pills
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, idx) {
                      final cat = _categories[idx];
                      final isSelected = _selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: PawlyColors.black,
                        backgroundColor: PawlyColors.surface,
                        labelStyle: PawlyTypography.eyebrow.copyWith(
                          color: isSelected ? Colors.white : PawlyColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedCategory = cat);
                        },
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Docs List
              if (filteredDocs.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyStateView(
                    
                    title: 'No Documents Found',
                    subtitle: 'Keep certificates, insurance policies, and blood panels organized for ${pet?.name ?? "your pet"}.',
                    actionLabel: 'Upload Document',
                    onAction: _showAddDocumentModal,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final doc = filteredDocs[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _DocumentCard(doc: doc),
                        );
                      },
                      childCount: filteredDocs.length,
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

class _DocumentCard extends StatelessWidget {
  final DocumentItem doc;

  const _DocumentCard({required this.doc});

  @override
  Widget build(BuildContext context) {
    return PawlyCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: PawlyColors.border,
              borderRadius: AppTokens.rSm,
            ),
            child: const Icon(
              Icons.description_rounded,
              color: PawlyColors.black,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.title,
                  style: PawlyTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    StatusBadge(
                      label: doc.category,
                      backgroundColor: PawlyColors.background,
                      textColor: PawlyColors.secondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Added ${doc.dateAdded}',
                      style: PawlyTypography.bodyMedium.copyWith(color: PawlyColors.tertiary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon:  const Icon(Icons.download_rounded, color: PawlyColors.secondary, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Downloading ${doc.title}...'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AddDocumentSheet extends StatefulWidget {
  final PawlyRepository repository;

  const _AddDocumentSheet({required this.repository});

  @override
  State<_AddDocumentSheet> createState() => _AddDocumentSheetState();
}

class _AddDocumentSheetState extends State<_AddDocumentSheet> {
  final _titleController = TextEditingController();
  String _selectedCategory = 'Vaccination';

  final List<String> _categories = [
    'Vaccination',
    'Lab Result',
    'Prescription',
    'Insurance',
    'Registration',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final now = DateTime.now();
    final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final doc = DocumentItem(
      id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
      petId: widget.repository.selectedPetId,
      title: title,
      category: _selectedCategory,
      dateAdded: dateStr,
      fileType: 'PDF',
    );

    widget.repository.addDocument(doc);
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
            'Add Clinical Document',
            style: PawlyTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Document Name',
              hintText: 'e.g. 2026 Comprehensive Blood Panel',
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'CATEGORY',
            style: PawlyTypography.eyebrow.copyWith(
              color: PawlyColors.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _categories.map((c) {
              final isSelected = _selectedCategory == c;
              return ChoiceChip(
                label: Text(c),
                selected: isSelected,
                selectedColor: PawlyColors.black.withOpacity(0.15),
                backgroundColor: PawlyColors.background,
                labelStyle: PawlyTypography.eyebrow.copyWith(
                  color: isSelected ? PawlyColors.black : PawlyColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                onSelected: (val) {
                  if (val) setState(() => _selectedCategory = c);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          PawlyButton(
            text: 'Save Document',
            
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}
