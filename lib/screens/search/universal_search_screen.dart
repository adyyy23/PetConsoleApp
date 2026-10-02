import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/widgets.dart';
import '../../repositories/pawly_repository.dart';
import '../../models/models.dart';

class UniversalSearchScreen extends StatefulWidget {
  final PawlyRepository repository;

  const UniversalSearchScreen({super.key, required this.repository});

  @override
  State<UniversalSearchScreen> createState() => _UniversalSearchScreenState();
}

class _UniversalSearchScreenState extends State<UniversalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<SearchResultItem> _results = [];

  final List<String> _categories = [
    'All',
    'Care',
    'Health',
    'Medication',
    'Appointment',
    'Memory',
    'Document',
    'Pet',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _results = widget.repository.search(_searchController.text);
    });
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Care':
        return Icons.check_circle_outline_rounded;
      case 'Health':
        return Icons.favorite_border_rounded;
      case 'Medication':
        return Icons.medication_outlined;
      case 'Appointment':
        return Icons.calendar_today_outlined;
      case 'Memory':
        return Icons.photo_library_outlined;
      case 'Document':
        return Icons.description_outlined;
      case 'Pet':
        return Icons.pets_outlined;
      default:
        return Icons.search_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredResults = _selectedCategory == 'All'
        ? _results
        : _results.where((r) => r.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: PawlyColors.background,
      appBar: const PawlyAppBar(title: 'Universal Search'),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input Field (Clean 8px container)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.rMd,
                  border: Border.all(color: PawlyColors.border, width: 1.0),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: PawlyTypography.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Search routines, medications, records...',
                    hintStyle: PawlyTypography.bodyMedium,
                    prefixIcon: const Icon(Icons.search_rounded, color: PawlyColors.black, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18, color: PawlyColors.textMuted),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
            ),

            // Category Filter Pills (6px)
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final cat = _categories[idx];
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? PawlyColors.black : Colors.white,
                        borderRadius: AppRadius.rSm,
                        border: Border.all(
                          color: isSelected ? PawlyColors.black : PawlyColors.border,
                          width: 1.0,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cat,
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

            const SizedBox(height: 12),

            // Search Content
            Expanded(
              child: _searchController.text.trim().isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: PawlyColors.softGrey,
                                borderRadius: AppRadius.rMd,
                              ),
                              child: const Icon(Icons.search_rounded, size: 32, color: PawlyColors.black),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Search Across Everything',
                              style: PawlyTypography.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Search pet profiles, care schedules, vet checkups, medications, memories, and documents.',
                              textAlign: TextAlign.center,
                              style: PawlyTypography.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                  : filteredResults.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.search_off_rounded, size: 36, color: PawlyColors.textMuted),
                                const SizedBox(height: 12),
                                Text(
                                  'No results for "${_searchController.text}"',
                                  style: PawlyTypography.titleSmall,
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Try checking your spelling or choosing another category.',
                                  style: PawlyTypography.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                          itemCount: filteredResults.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, idx) {
                            final item = filteredResults[idx];
                            final icon = _getCategoryIcon(item.category);

                            return PawlyCard(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: PawlyColors.softGrey,
                                      borderRadius: AppRadius.rSm,
                                    ),
                                    child: Icon(icon, color: PawlyColors.black, size: 18),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: PawlyTypography.titleSmall,
                                              ),
                                            ),
                                            PawlyBadge(label: item.category),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item.subtitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: PawlyTypography.bodySmall,
                                        ),
                                        if (item.date.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            item.date,
                                            style: PawlyTypography.caption,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
