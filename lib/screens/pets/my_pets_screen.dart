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
      backgroundColor: PawlyColors.resolve(context, PawlyColors.background),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('FAMILY COMPANIONS',
                              style: PawlyTypography.resolve(
                                  context, PawlyTypography.eyebrow),
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text('My Pets',
                              style: PawlyTypography.resolve(
                                  context, PawlyTypography.displayMedium),
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    PawlyButton(
                      text: 'Add Pet',
                      isSmall: true,
                      onPressed: onOpenAddPet,
                    ),
                  ],
                ),
              ),
            ),
            if (pets.isEmpty)
              SliverFillRemaining(
                child: EmptyStateView(
                  title: 'No pets added yet',
                  subtitle:
                      'Add your first companion to begin tracking care and health.',
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
                      final nextRoutine = repository
                          .routinesForDate(DateTime.now(), petId: pet.id)
                          .where((r) => !r.isCompleted)
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
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppTokens.md)),
              child: AspectRatio(
                aspectRatio: 1,
                child: ColoredBox(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Image(
                        image: pawlyImageProvider(pet.imageUrl),
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Center(child: Icon(Icons.pets, size: 44)))),
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
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pet.name,
                              style: PawlyTypography.resolve(
                                  context, PawlyTypography.titleLarge)),
                          const SizedBox(height: 2),
                          Text(
                            '${pet.breed} • ${pet.ageYears.toStringAsFixed(pet.ageYears.truncateToDouble() == pet.ageYears ? 0 : 1)} yrs • ${pet.gender}',
                            style: PawlyTypography.resolve(
                                context, PawlyTypography.bodyMedium),
                          ),
                        ],
                      )),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              PawlyColors.resolve(context, PawlyColors.border),
                          borderRadius: AppTokens.rSm,
                          border: Border.all(
                              color: PawlyColors.resolve(
                                  context, PawlyColors.border),
                              width: 0.8),
                        ),
                        child: Text(
                          '${pet.weightKg} kg',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color:
                                PawlyColors.resolve(context, PawlyColors.black),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Next routine row
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color:
                          PawlyColors.resolve(context, PawlyColors.surfaceWarm),
                      borderRadius: AppTokens.rSm,
                      border: Border.all(
                          color:
                              PawlyColors.resolve(context, PawlyColors.border),
                          width: 0.8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.alarm,
                            size: 14,
                            color: PawlyColors.resolve(
                                context, PawlyColors.black)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            nextCareText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: PawlyColors.resolve(
                                  context, PawlyColors.black),
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded,
                            size: 10,
                            color: PawlyColors.resolve(
                                context, PawlyColors.tertiary)),
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
