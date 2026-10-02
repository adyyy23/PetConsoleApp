import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
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

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Care':
        return PawlyColors.forest;
      case 'Health':
        return PawlyColors.terracotta;
      case 'Medication':
        return PawlyColors.honey;
      case 'Appointment':
        return PawlyColors.slate;
      case 'Memory':
        return PawlyColors.rose;
      case 'Document':
        return PawlyColors.warmGrey;
      case 'Pet':
        return PawlyColors.forest;
      default:
        return PawlyColors.espresso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredResults = _selectedCategory == 'All'
        ? _results
        : _results.where((r) => r.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: PawlyColors.creamBg,
      appBar: AppBar(
        backgroundColor: PawlyColors.creamBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: PawlyColors.espresso),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Universal Search', style: PawlyTypography.titleMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input Field
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: PawlyColors.border, width: 1.2),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: PawlyColors.espresso,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search routines, medications, records...',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: PawlyColors.mutedGrey,
                    ),
                    prefixIcon: const Icon(Icons.search_rounded, color: PawlyColors.forest),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18, color: PawlyColors.warmGrey),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),

            // Category Filter Pills
            SizedBox(
              height: 38,
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
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? PawlyColors.forest : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? PawlyColors.forest : PawlyColors.border,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : PawlyColors.warmGrey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

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
                              padding: const EdgeInsets.all(18),
                              decoration: const BoxDecoration(
                                color: PawlyColors.surfaceWarm,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.search_rounded, size: 40, color: PawlyColors.forest),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Search Across Everything',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: PawlyColors.espresso,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Search pet profiles, care schedules, vet checkups, medications, memories, and documents.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: PawlyColors.warmGrey,
                                height: 1.4,
                              ),
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
                                const Icon(Icons.search_off_rounded, size: 44, color: PawlyColors.mutedGrey),
                                const SizedBox(height: 12),
                                Text(
                                  'No results for "${_searchController.text}"',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: PawlyColors.espresso,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Try checking your spelling or choosing another category.',
                                  style: TextStyle(fontSize: 13, color: PawlyColors.warmGrey),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                          itemCount: filteredResults.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, idx) {
                            final item = filteredResults[idx];
                            final icon = _getCategoryIcon(item.category);
                            final color = _getCategoryColor(item.category);

                            return PawlyBubble(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(icon, color: color, size: 18),
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
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                  color: PawlyColors.espresso,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: color.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                item.category,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w800,
                                                  color: color,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          item.subtitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: PawlyColors.warmGrey,
                                          ),
                                        ),
                                        if (item.date.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            item.date,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: PawlyColors.mutedGrey,
                                            ),
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
