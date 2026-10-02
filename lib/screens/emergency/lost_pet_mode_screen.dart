import 'package:flutter/material.dart';
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
          backgroundColor: PawlyColors.background,
          appBar: const PawlyAppBar(title: 'Lost Pet Alert Mode'),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Toggle status switch card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isLost ? PawlyColors.alertLight : Colors.white,
                    borderRadius: AppRadius.rMd,
                    border: Border.all(
                      color: isLost ? PawlyColors.alert : PawlyColors.border,
                      width: isLost ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isLost ? PawlyColors.alertRose : PawlyColors.border,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.radar_rounded,
                          color: isLost ? Colors.white : PawlyColors.textSecondary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isLost ? 'LOST PET BROADCAST ACTIVE' : 'Lost Pet Broadcast Inactive',
                              style: PawlyTypography.titleSmall.copyWith(
                                color: isLost ? PawlyColors.alertRose : PawlyColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              isLost
                                  ? 'Poster is public & ready to broadcast.'
                                  : 'Turn on if ${pet?.name ?? "your pet"} is missing.',
                              style: PawlyTypography.bodySmall.copyWith(
                                color: PawlyColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: isLost,
                        activeColor: PawlyColors.alertRose,
                        onChanged: (_) => repository.toggleLostPetMode(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Shareable Lost Pet Poster Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: PawlyColors.alertRose, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: PawlyColors.alertRose.withOpacity(0.12),
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
                        color: PawlyColors.alertRose,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Column(
                          children: [
                            Text(
                              'LOST PET REWARD',
                              style: PawlyTypography.headlineSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.0,
                              ),
                            ),
                            Text(
                              'PLEASE HELP BRING ${pet?.name.toUpperCase()} HOME',
                              style: PawlyTypography.labelSmall.copyWith(
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
                        child: Image.network(
                          pet?.imageUrl ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: PawlyColors.border,
                            child: const Icon(Icons.pets_rounded, size: 60, color: PawlyColors.textMuted),
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
                              style: PawlyTypography.headlineMedium.copyWith(
                                color: PawlyColors.deepEspresso,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${pet?.breed} • ${pet?.gender} • ${pet?.weightKg} kg',
                              style: PawlyTypography.bodyMedium.copyWith(
                                color: PawlyColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),

                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: PawlyColors.background,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Microchip:', style: PawlyTypography.bodySmall.copyWith(color: PawlyColors.textSecondary)),
                                      Text(
                                        pet?.microchipId.isNotEmpty == true ? pet!.microchipId : 'Registered',
                                        style: PawlyTypography.bodySmall.copyWith(fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Contact:', style: PawlyTypography.bodySmall.copyWith(color: PawlyColors.textSecondary)),
                                      Text(
                                        card.emergencyContactName,
                                        style: PawlyTypography.bodySmall.copyWith(fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Phone:', style: PawlyTypography.bodySmall.copyWith(color: PawlyColors.textSecondary)),
                                      Text(
                                        card.emergencyPhone,
                                        style: PawlyTypography.titleSmall.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: PawlyColors.forest,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            Text(
                              'If spotted or found, please call immediately. Approach gently as they may be scared.',
                              textAlign: TextAlign.center,
                              style: PawlyTypography.bodySmall.copyWith(
                                color: PawlyColors.textMuted,
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
                  text: 'Broadcast Digital Poster',
                  icon: Icons.share_rounded,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lost Pet alert generated for ${pet?.name}. Share link copied!'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: PawlyColors.alertRose,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                PawlyButton(
                  text: 'Call Emergency Vet',
                  icon: Icons.phone_in_talk_rounded,
                  isSecondary: true,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Dialing ${card.preferredClinic} (${card.preferredVetPhone})...'),
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
