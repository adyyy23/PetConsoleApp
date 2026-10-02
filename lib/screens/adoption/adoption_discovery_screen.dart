import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../repositories/pawly_repository.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';

class AdoptionDiscoveryScreen extends StatefulWidget {
  final PawlyRepository repository;

  const AdoptionDiscoveryScreen({
    super.key,
    required this.repository,
  });

  @override
  State<AdoptionDiscoveryScreen> createState() => _AdoptionDiscoveryScreenState();
}

class _AdoptionDiscoveryScreenState extends State<AdoptionDiscoveryScreen> {
  String _filter = 'All';

  void _showInquiryDialog(AdoptionPet pet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _InquiryBottomSheet(pet: pet),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allPets = widget.repository.adoptionPets;
    final pets = _filter == 'All'
        ? allPets
        : allPets.where((p) => p.species.toLowerCase() == _filter.toLowerCase()).toList();

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
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                'Adopt & Foster',
                style: PawlyTypography.titleMedium.copyWith(
                  color: PawlyColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // Filters
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: ['All', 'Dog', 'Cat'].map((category) {
                  final isSelected = _filter == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category == 'All' ? 'All Pets' : '${category}s'),
                      selected: isSelected,
                      selectedColor: PawlyColors.forest,
                      backgroundColor: PawlyColors.surface,
                      labelStyle: PawlyTypography.labelSmall.copyWith(
                        color: isSelected ? Colors.white : PawlyColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _filter = category);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Adoption cards list
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final pet = pets[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _AdoptionCard(
                      pet: pet,
                      onInquire: () => _showInquiryDialog(pet),
                    ),
                  );
                },
                childCount: pets.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdoptionCard extends StatelessWidget {
  final AdoptionPet pet;
  final VoidCallback onInquire;

  const _AdoptionCard({
    required this.pet,
    required this.onInquire,
  });

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
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.network(
                  pet.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: PawlyColors.border,
                    child: const Icon(Icons.pets_rounded, size: 50, color: PawlyColors.textMuted),
                  ),
                ),
              ),
              Positioned(
                top: 14,
                right: 14,
                child: PawlyBadge(
                  label: pet.fosterStatus,
                  backgroundColor: PawlyColors.forest,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pet.name,
                      style: PawlyTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${pet.ageYears.toStringAsFixed(1)} yrs old',
                      style: PawlyTypography.bodyMedium.copyWith(color: PawlyColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${pet.breed} • ${pet.species}',
                  style: PawlyTypography.bodySmall.copyWith(
                    color: PawlyColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  pet.bio,
                  style: PawlyTypography.bodyMedium.copyWith(
                    color: PawlyColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: PawlyButton(
                        text: 'Meet ${pet.name}',
                        icon: Icons.favorite_rounded,
                        onPressed: onInquire,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InquiryBottomSheet extends StatefulWidget {
  final AdoptionPet pet;

  const _InquiryBottomSheet({required this.pet});

  @override
  State<_InquiryBottomSheet> createState() => _InquiryBottomSheetState();
}

class _InquiryBottomSheetState extends State<_InquiryBottomSheet> {
  late TextEditingController _messageController;
  final _emailController = TextEditingController(text: 'sarah.miller@example.com');
  final _phoneController = TextEditingController(text: '+1 (555) 234-5678');

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(
      text: 'Hi! I would love to schedule a meet-and-greet with ${widget.pet.name}. I have experience with ${widget.pet.species.toLowerCase()}s and a pet-safe home.',
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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
              'Inquire about ${widget.pet.name}',
              style: PawlyTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Connect directly with the foster shelter coordinator.',
              style: PawlyTypography.bodySmall.copyWith(color: PawlyColors.textSecondary),
            ),
            const SizedBox(height: 18),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Your Contact Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Your Phone Number'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Message to Rescue Team',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),

            PawlyButton(
              text: 'Submit Adoption Inquiry',
              icon: Icons.send_rounded,
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Inquiry sent for ${widget.pet.name}! The coordinator will reach out shortly.'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: PawlyColors.forest,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
