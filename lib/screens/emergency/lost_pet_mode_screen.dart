import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../repositories/pawly_repository.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/widgets.dart';

class LostPetModeScreen extends StatelessWidget {
  final PawlyRepository repository;

  const LostPetModeScreen({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        final pet = repository.selectedPet;
        final card = repository.emergencyCard;
        final isLost = repository.isLostPetModeEnabled;

        return Scaffold(
          backgroundColor: PawlyColors.resolve(context, PawlyColors.background),
          appBar: const PawlyAppBar(title: 'Lost Pet Alert Mode'),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Toggle status switch card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isLost
                        ? PawlyColors.resolve(context, PawlyColors.border)
                        : Colors.white,
                    borderRadius: AppTokens.rMd,
                    border: Border.all(
                      color: isLost
                          ? PawlyColors.resolve(context, PawlyColors.error)
                          : PawlyColors.resolve(context, PawlyColors.border),
                      width: isLost ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isLost
                              ? PawlyColors.resolve(
                                  context, PawlyColors.alertRose)
                              : PawlyColors.resolve(
                                  context, PawlyColors.border),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.radar_rounded,
                          color: isLost
                              ? Colors.white
                              : PawlyColors.resolve(
                                  context, PawlyColors.secondary),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isLost
                                  ? 'LOST PET BROADCAST ACTIVE'
                                  : 'Lost Pet Broadcast Inactive',
                              style: PawlyTypography.resolve(
                                      context, PawlyTypography.titleSmall)
                                  .copyWith(
                                color: isLost
                                    ? PawlyColors.resolve(
                                        context, PawlyColors.alertRose)
                                    : PawlyColors.resolve(
                                        context, PawlyColors.textPrimary),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              isLost
                                  ? 'Details are ready for you to copy and share.'
                                  : 'Turn on if ${pet?.name ?? "your pet"} is missing.',
                              style: PawlyTypography.resolve(
                                      context, PawlyTypography.bodyMedium)
                                  .copyWith(
                                color: PawlyColors.resolve(
                                    context, PawlyColors.secondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: isLost,
                        activeColor:
                            PawlyColors.resolve(context, PawlyColors.alertRose),
                        onChanged: (val) => repository.toggleLostPetMode(val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Shareable Lost Pet Poster Card
                Container(
                  decoration: BoxDecoration(
                    color: PawlyColors.resolve(context, PawlyColors.surface),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color:
                            PawlyColors.resolve(context, PawlyColors.alertRose),
                        width: 3),
                    boxShadow: [
                      BoxShadow(
                        color:
                            PawlyColors.resolve(context, PawlyColors.alertRose)
                                .withOpacity(0.12),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      // Header Alert Bar
                      Container(
                        width: double.infinity,
                        color:
                            PawlyColors.resolve(context, PawlyColors.alertRose),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Column(
                          children: [
                            Text(
                              'LOST PET REWARD',
                              style: PawlyTypography.resolve(
                                      context, PawlyTypography.headlineSmall)
                                  .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.0,
                              ),
                            ),
                            Text(
                              'PLEASE HELP BRING ${pet?.name.toUpperCase()} HOME',
                              style: PawlyTypography.resolve(
                                      context, PawlyTypography.eyebrow)
                                  .copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Pet Big Photo
                      AspectRatio(
                        aspectRatio: 16 / 11,
                        child: Image(
                          image: pawlyImageProvider(pet?.imageUrl ?? ''),
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            color: PawlyColors.resolve(
                                context, PawlyColors.border),
                            child: Icon(Icons.pets_rounded,
                                size: 60,
                                color: PawlyColors.resolve(
                                    context, PawlyColors.tertiary)),
                          ),
                        ),
                      ),

                      // Pet Details
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              pet?.name ?? 'Pet',
                              style: PawlyTypography.resolve(
                                      context, PawlyTypography.headlineSmall)
                                  .copyWith(
                                color: PawlyColors.resolve(
                                    context, PawlyColors.deepEspresso),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${pet?.breed} • ${pet?.gender} • ${pet?.weightKg} kg',
                              style: PawlyTypography.resolve(
                                      context, PawlyTypography.bodyMedium)
                                  .copyWith(
                                color: PawlyColors.resolve(
                                    context, PawlyColors.secondary),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: PawlyColors.resolve(
                                    context, PawlyColors.background),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          child: Text('Microchip:',
                                              style: PawlyTypography.resolve(
                                                      context,
                                                      PawlyTypography
                                                          .bodyMedium)
                                                  .copyWith(
                                                      color: PawlyColors.resolve(
                                                          context,
                                                          PawlyColors
                                                              .secondary)))),
                                      Flexible(
                                          child: Text(
                                        pet?.microchipId.isNotEmpty == true
                                            ? pet!.microchipId
                                            : 'Registered',
                                        style: PawlyTypography.resolve(context,
                                                PawlyTypography.bodyMedium)
                                            .copyWith(
                                                fontWeight: FontWeight.w700),
                                      )),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          child: Text('Contact:',
                                              style: PawlyTypography.resolve(
                                                      context,
                                                      PawlyTypography
                                                          .bodyMedium)
                                                  .copyWith(
                                                      color: PawlyColors.resolve(
                                                          context,
                                                          PawlyColors
                                                              .secondary)))),
                                      Flexible(
                                          child: Text(
                                        card.emergencyContactName,
                                        style: PawlyTypography.resolve(context,
                                                PawlyTypography.bodyMedium)
                                            .copyWith(
                                                fontWeight: FontWeight.w700),
                                      )),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          child: Text('Phone:',
                                              style: PawlyTypography.resolve(
                                                      context,
                                                      PawlyTypography
                                                          .bodyMedium)
                                                  .copyWith(
                                                      color: PawlyColors.resolve(
                                                          context,
                                                          PawlyColors
                                                              .secondary)))),
                                      Flexible(
                                          child: Text(
                                        card.emergencyPhone,
                                        style: PawlyTypography.resolve(context,
                                                PawlyTypography.titleSmall)
                                            .copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: PawlyColors.resolve(
                                              context, PawlyColors.black),
                                        ),
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'If spotted or found, please call immediately. Approach gently as they may be scared.',
                              textAlign: TextAlign.center,
                              style: PawlyTypography.resolve(
                                      context, PawlyTypography.bodyMedium)
                                  .copyWith(
                                color: PawlyColors.resolve(
                                    context, PawlyColors.tertiary),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Broadcast actions
                PawlyButton(
                  text: 'Copy Lost Pet Details',
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(
                        text:
                            'LOST PET: ${pet?.name}\n${pet?.animalType} · ${pet?.breed}\nMicrochip: ${pet?.microchipId}\nPlease contact ${card.emergencyContactName}: ${card.emergencyPhone}'));
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'Lost pet details copied. Paste them into your community message.'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor:
                            PawlyColors.resolve(context, PawlyColors.alertRose),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                PawlyButton(
                  text: 'Copy Vet Phone Number',
                  isSecondary: true,
                  onPressed: () async {
                    await Clipboard.setData(
                        ClipboardData(text: card.preferredVetPhone));
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Vet phone number copied: ${card.preferredVetPhone}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
