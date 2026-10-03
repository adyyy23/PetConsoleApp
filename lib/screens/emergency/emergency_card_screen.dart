import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/models.dart';
import '../../repositories/pawly_repository.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/widgets.dart';
import 'lost_pet_mode_screen.dart';

class EmergencyCardScreen extends StatelessWidget {
  final PawlyRepository repository;

  const EmergencyCardScreen({
    super.key,
    required this.repository,
  });

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SingleChildScrollView(
          child: _EditEmergencySheet(repository: repository)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        final pet = repository.selectedPet;
        final card = repository.emergencyCard;

        return Scaffold(
          backgroundColor: PawlyColors.resolve(context, PawlyColors.background),
          appBar: PawlyAppBar(
            title: 'Emergency Pet Card',
            trailing: IconButton(
              icon: Icon(Icons.edit_outlined,
                  color: PawlyColors.resolve(context, PawlyColors.black),
                  size: 20),
              onPressed: () => _showEditSheet(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lost Pet Mode Banner Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            LostPetModeScreen(repository: repository),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: repository.isLostPetModeEnabled
                          ? PawlyColors.resolve(context, PawlyColors.error)
                          : PawlyColors.resolve(context, PawlyColors.border),
                      borderRadius: AppTokens.rMd,
                      border: Border.all(
                        color: repository.isLostPetModeEnabled
                            ? PawlyColors.resolve(context, PawlyColors.error)
                            : PawlyColors.resolve(context, PawlyColors.border),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: repository.isLostPetModeEnabled
                              ? Colors.white
                              : PawlyColors.resolve(context, PawlyColors.error),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                repository.isLostPetModeEnabled
                                    ? 'LOST PET MODE IS ACTIVE'
                                    : 'Lost Pet Mode',
                                style: PawlyTypography.resolve(
                                        context, PawlyTypography.titleSmall)
                                    .copyWith(
                                  color: repository.isLostPetModeEnabled
                                      ? Colors.white
                                      : PawlyColors.resolve(
                                          context, PawlyColors.black),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                repository.isLostPetModeEnabled
                                    ? 'Tap to view or share rescue poster'
                                    : 'Generate shareable rescue poster & alert',
                                style: PawlyTypography.resolve(
                                        context, PawlyTypography.caption)
                                    .copyWith(
                                  color: repository.isLostPetModeEnabled
                                      ? Colors.white70
                                      : PawlyColors.resolve(
                                          context, PawlyColors.tertiary),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: repository.isLostPetModeEnabled
                              ? Colors.white
                              : PawlyColors.resolve(
                                  context, PawlyColors.tertiary),
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Digital Passport Card
                Container(
                  decoration: BoxDecoration(
                    color: PawlyColors.black,
                    borderRadius: AppTokens.rMd,
                    border: Border.all(
                        color:
                            PawlyColors.resolve(context, PawlyColors.charcoal)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(22),
                        child: Row(
                          children: [
                            PawlyPetAvatar(
                              imageUrl: pet?.imageUrl ?? '',
                              size: 70,
                              isSelected: true,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                          child: Text(
                                        pet?.name ?? 'Pet',
                                        style: PawlyTypography.resolve(context,
                                                PawlyTypography.headlineSmall)
                                            .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )),
                                      const SizedBox(width: 8),
                                      StatusBadge(
                                        label: pet?.gender ?? '',
                                        backgroundColor: PawlyColors.resolve(
                                                context, PawlyColors.surface)
                                            .withOpacity(0.15),
                                        textColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${pet?.breed} • ${pet?.ageYears.toStringAsFixed(1)} yrs',
                                    style: PawlyTypography.resolve(
                                            context, PawlyTypography.bodyMedium)
                                        .copyWith(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Weight: ${pet?.weightKg.toStringAsFixed(1)} kg',
                                    style: PawlyTypography.resolve(
                                            context, PawlyTypography.bodyMedium)
                                        .copyWith(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Microchip ribbon
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 12),
                        color: Colors.white.withOpacity(0.08),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: Text(
                              'MICROCHIP ID',
                              style: PawlyTypography.resolve(
                                      context, PawlyTypography.eyebrow)
                                  .copyWith(
                                color: Colors.white70,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.1,
                              ),
                            )),
                            Flexible(
                                child: Text(
                              pet?.microchipId.isNotEmpty == true
                                  ? pet!.microchipId
                                  : 'Not Recorded',
                              style: PawlyTypography.resolve(
                                      context, PawlyTypography.labelMedium)
                                  .copyWith(
                                color: PawlyColors.resolve(
                                    context, PawlyColors.warmHoney),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            )),
                          ],
                        ),
                      ),

                      // Details list
                      Padding(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          children: [
                            _EmergencyRow(
                              icon: Icons.phone_in_talk_rounded,
                              label: 'Primary Emergency Contact',
                              value: card.emergencyContactName,
                              subValue: card.emergencyPhone,
                            ),
                            const Divider(color: Colors.white12, height: 24),
                            _EmergencyRow(
                              icon: Icons.local_hospital_outlined,
                              label: 'Primary Clinic',
                              value: card.preferredClinic,
                              subValue:
                                  '${card.preferredVetName} • ${card.preferredVetPhone}',
                            ),
                            const Divider(color: Colors.white12, height: 24),
                            _EmergencyRow(
                              icon: Icons.medical_services_outlined,
                              label: 'Allergies & Critical Conditions',
                              value: pet?.allergies.isNotEmpty == true
                                  ? pet!.allergies
                                  : 'None known',
                              subValue: card.criticalNotes.isNotEmpty
                                  ? card.criticalNotes
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Share / Save buttons
                PawlyButton(
                  text: 'Copy Emergency Card',
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(
                        text:
                            'Pawly emergency card: ${pet?.name}\nBreed: ${pet?.breed}\nMicrochip: ${pet?.microchipId}\nAllergies: ${pet?.allergies}\nContact: ${card.emergencyContactName} ${card.emergencyPhone}\nVet: ${card.preferredClinic} ${card.preferredVetPhone}\nCritical notes: ${card.criticalNotes}'));
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Emergency details for ${pet?.name} copied. Paste them into a message.'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmergencyRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subValue;

  const _EmergencyRow({
    required this.icon,
    required this.label,
    required this.value,
    this.subValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: PawlyTypography.resolve(context, PawlyTypography.eyebrow)
                    .copyWith(
                  color: Colors.white54,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style:
                    PawlyTypography.resolve(context, PawlyTypography.titleSmall)
                        .copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subValue != null) ...[
                const SizedBox(height: 2),
                Text(
                  subValue!,
                  style: PawlyTypography.resolve(
                          context, PawlyTypography.bodyMedium)
                      .copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _EditEmergencySheet extends StatefulWidget {
  final PawlyRepository repository;

  const _EditEmergencySheet({required this.repository});

  @override
  State<_EditEmergencySheet> createState() => _EditEmergencySheetState();
}

class _EditEmergencySheetState extends State<_EditEmergencySheet> {
  late TextEditingController _contactNameCtrl;
  late TextEditingController _contactPhoneCtrl;
  late TextEditingController _clinicCtrl;
  late TextEditingController _vetNameCtrl;
  late TextEditingController _vetPhoneCtrl;
  late TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    final card = widget.repository.emergencyCard;
    _contactNameCtrl = TextEditingController(text: card.emergencyContactName);
    _contactPhoneCtrl = TextEditingController(text: card.emergencyPhone);
    _clinicCtrl = TextEditingController(text: card.preferredClinic);
    _vetNameCtrl = TextEditingController(text: card.preferredVetName);
    _vetPhoneCtrl = TextEditingController(text: card.preferredVetPhone);
    _notesCtrl = TextEditingController(text: card.criticalNotes);
  }

  @override
  void dispose() {
    _contactNameCtrl.dispose();
    _contactPhoneCtrl.dispose();
    _clinicCtrl.dispose();
    _vetNameCtrl.dispose();
    _vetPhoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final updated = EmergencyCardData(
      petId: widget.repository.selectedPetId,
      emergencyContactName: _contactNameCtrl.text.trim(),
      emergencyPhone: _contactPhoneCtrl.text.trim(),
      preferredClinic: _clinicCtrl.text.trim(),
      preferredVetName: _vetNameCtrl.text.trim(),
      preferredVetPhone: _vetPhoneCtrl.text.trim(),
      criticalNotes: _notesCtrl.text.trim(),
    );
    await widget.repository.updateEmergencyCard(updated);
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
              'Edit Emergency Contacts',
              style:
                  PawlyTypography.resolve(context, PawlyTypography.titleMedium)
                      .copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contactNameCtrl,
              decoration:
                  const InputDecoration(labelText: 'Emergency Contact Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contactPhoneCtrl,
              decoration:
                  const InputDecoration(labelText: 'Emergency Contact Phone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _clinicCtrl,
              decoration: const InputDecoration(labelText: 'Preferred Clinic'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _vetNameCtrl,
              decoration: const InputDecoration(labelText: 'Veterinarian Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _vetPhoneCtrl,
              decoration:
                  const InputDecoration(labelText: 'Veterinarian Phone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesCtrl,
              decoration: const InputDecoration(
                  labelText: 'Special Alerts / Instructions'),
            ),
            const SizedBox(height: 24),
            PawlyButton(
              text: 'Save Details',
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
