import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/widgets.dart';
import '../../repositories/pawly_repository.dart';
import '../../models/models.dart';

class MyPetsScreen extends StatelessWidget {
  final PawlyRepository repository;
  final ValueChanged<String> onOpenPetSpace;
  final VoidCallback onOpenAddPet;

  const MyPetsScreen({
    super.key,
    required this.repository,
    required this.onOpenPetSpace,
    required this.onOpenAddPet,
  });

  @override
  Widget build(BuildContext context) {
    final pets = repository.pets;

    return Scaffold(
      backgroundColor: PawlyColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('FAMILY COMPANIONS', style: PawlyTypography.eyebrow),
                        SizedBox(height: 2),
                        Text('My Pets', style: PawlyTypography.displayMedium),
                      ],
                    ),
                    PawlyButton(
                      label: 'Add Pet',
                      icon: Icons.add,
                      isSmall: true,
                      variant: PawlyButtonVariant.primary,
                      onPressed: onOpenAddPet,
                    ),
                  ],
                ),
              ),
            ),

            if (pets.isEmpty)
              SliverFillRemaining(
                child: EmptyStateView(
                  icon: Icons.pets_outlined,
                  title: 'No pets added yet',
                  subtitle: 'Add your first companion to begin tracking care and health.',
                  buttonLabel: 'Add First Pet',
                  onButtonPressed: onOpenAddPet,
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final pet = pets[index];
                      final nextRoutine = repository.allRoutines
                          .where((r) => r.petId == pet.id && !r.isCompleted)
                          .toList();

                      return _PetCollectionCard(
                        pet: pet,
                        nextCareText: nextRoutine.isNotEmpty
                            ? nextRoutine.first.title
                            : 'All care up to date',
                        onTap: () => onOpenPetSpace(pet.id),
                      );
                    },
                    childCount: pets.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PetCollectionCard extends StatelessWidget {
  final Pet pet;
  final String nextCareText;
  final VoidCallback onTap;

  const _PetCollectionCard({
    required this.pet,
    required this.nextCareText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: PawlyCard(
        padding: EdgeInsets.zero,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expressive Pet Photography Banner (8px top radius)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
              child: SizedBox(
                height: 190,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      pet.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: PawlyColors.softGrey,
                        child: const Icon(Icons.pets, size: 44, color: PawlyColors.charcoal),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.35),
                            Colors.transparent,
                            Colors.black.withOpacity(0.65),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                          borderRadius: AppRadius.rSm,
                          border: Border.all(color: Colors.white24, width: 0.8),
                        ),
                        child: Text(
                          pet.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (pet.nickname.isNotEmpty)
                      Positioned(
                        bottom: 12,
                        left: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.65),
                            borderRadius: AppRadius.rSm,
                            border: Border.all(color: Colors.white12, width: 0.8),
                          ),
                          child: Text(
                            '“${pet.nickname}”',
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Pet Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pet.name, style: PawlyTypography.titleLarge),
                          const SizedBox(height: 2),
                          Text(
                            '${pet.breed} • ${pet.ageYears.toStringAsFixed(pet.ageYears.truncateToDouble() == pet.ageYears ? 0 : 1)} yrs • ${pet.gender}',
                            style: PawlyTypography.bodyMedium,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: PawlyColors.softGrey,
                          borderRadius: AppRadius.rSm,
                          border: Border.all(color: PawlyColors.border, width: 0.8),
                        ),
                        child: Text(
                          '${pet.weightKg} kg',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: PawlyColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Next routine row
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: PawlyColors.surfaceWarm,
                      borderRadius: AppRadius.rSm,
                      border: Border.all(color: PawlyColors.border, width: 0.8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.alarm, size: 14, color: PawlyColors.black),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            nextCareText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: PawlyColors.black,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: PawlyColors.textMuted),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
