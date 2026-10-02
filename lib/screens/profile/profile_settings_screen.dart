import 'package:flutter/material.dart';
import '../../repositories/pawly_repository.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/widgets.dart';
import '../adoption/adoption_discovery_screen.dart';
import '../emergency/emergency_card_screen.dart';
import '../emergency/lost_pet_mode_screen.dart';
import '../calendar/pet_calendar_screen.dart';
import '../search/universal_search_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final PawlyRepository repository;
  final VoidCallback onLogout;

  const ProfileSettingsScreen({
    super.key,
    required this.repository,
    required this.onLogout,
  });

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool _careNotifications = true;
  bool _vetReminders = true;

  void _showInviteCaregiverSheet() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    String role = 'Family Co-owner';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: const BoxDecoration(
            color: PawlyColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: PawlyColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Invite to Care Circle', style: PawlyTypography.titleLarge),
              const SizedBox(height: 4),
              const Text(
                'Share care agendas, medication schedules, and digital health records with a co-owner or pet sitter.',
                style: PawlyTypography.bodyMedium,
              ),
              const SizedBox(height: 16),
              const Text('CAREGIVER NAME', style: PawlyTypography.eyebrow),
              const SizedBox(height: 6),
              TextField(
                controller: nameCtrl,
                style: PawlyTypography.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'e.g. Alex Rivera',
                  filled: true,
                  fillColor: PawlyColors.surfaceWarm,
                  border: OutlineInputBorder(
                    borderRadius: AppTokens.rMd,
                    borderSide: const BorderSide(color: PawlyColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppTokens.rMd,
                    borderSide: const BorderSide(color: PawlyColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppTokens.rMd,
                    borderSide: const BorderSide(color: PawlyColors.black, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text('EMAIL ADDRESS', style: PawlyTypography.eyebrow),
              const SizedBox(height: 6),
              TextField(
                controller: emailCtrl,
                style: PawlyTypography.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'e.g. alex@example.com',
                  filled: true,
                  fillColor: PawlyColors.surfaceWarm,
                  border: OutlineInputBorder(
                    borderRadius: AppTokens.rMd,
                    borderSide: const BorderSide(color: PawlyColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppTokens.rMd,
                    borderSide: const BorderSide(color: PawlyColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppTokens.rMd,
                    borderSide: const BorderSide(color: PawlyColors.black, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text('ROLE', style: PawlyTypography.eyebrow),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: ['Family Co-owner', 'Pet Sitter', 'Walker'].map((r) {
                  final isSelected = role == r;
                  return GestureDetector(
                    onTap: () => setModalState(() => role = r),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? PawlyColors.black : Colors.white,
                        borderRadius: AppTokens.rSm,
                        border: Border.all(
                          color: isSelected ? PawlyColors.black : PawlyColors.border,
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        r,
                        style: TextStyle(
                          color: isSelected ? Colors.white : PawlyColors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: PawlyButton(
                  text: 'Send Care Circle Invite',
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Care invitation sent! They can now access your pet’s routines.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.repository,
      builder: (context, _) {
        final user = widget.repository.user;
        final careCircle = widget.repository.careCircle;

        return Scaffold(
          backgroundColor: PawlyColors.background,
          appBar: AppBar(
            backgroundColor: PawlyColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: const Text('Settings & More', style: PawlyTypography.displayMedium),
            centerTitle: false,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1.0),
              child: Divider(height: 1.0, color: PawlyColors.border),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Account Section
                PawlyCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: PawlyColors.border,
                          borderRadius: AppTokens.rSm,
                          border: Border.all(color: PawlyColors.border),
                        ),
                        child: const Icon(Icons.person_rounded, color: PawlyColors.black, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name, style: PawlyTypography.titleMedium),
                            const SizedBox(height: 2),
                            Text(user.email, style: PawlyTypography.caption),
                          ],
                        ),
                      ),
                      const StatusBadge(label: 'Owner'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Tools & Discovery
                const Text('TOOLS & DISCOVERY', style: PawlyTypography.eyebrow),
                const SizedBox(height: 8),
                PawlyCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _SettingsRow(
                        icon: Icons.search_rounded,
                        title: 'Universal Search',
                        subtitle: 'Search across routines, health, meds & docs',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UniversalSearchScreen(repository: widget.repository),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 52, color: PawlyColors.border),
                      _SettingsRow(
                        icon: Icons.calendar_month_outlined,
                        title: 'Unified Pet Calendar',
                        subtitle: 'Monthly schedule for appointments and routines',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PetCalendarScreen(repository: widget.repository),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Care Circle Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('CARE CIRCLE & FAMILY PACK', style: PawlyTypography.eyebrow),
                    GestureDetector(
                      onTap: _showInviteCaregiverSheet,
                      child: const Text(
                        '+ Invite',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: PawlyColors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                PawlyCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: careCircle.map((member) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: PawlyColors.border,
                                borderRadius: AppTokens.rSm,
                                border: Border.all(color: PawlyColors.border, width: 0.8),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: member.avatarUrl.isNotEmpty
                                  ? Image.network(
                                      member.avatarUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Center(
                                        child: Text(
                                          member.name.isNotEmpty ? member.name[0] : 'C',
                                          style: const TextStyle(fontWeight: FontWeight.w800, color: PawlyColors.black),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        member.name.isNotEmpty ? member.name[0] : 'C',
                                        style: const TextStyle(fontWeight: FontWeight.w800, color: PawlyColors.black),
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.name,
                                    style: PawlyTypography.titleSmall,
                                  ),
                                  Text(
                                    '${member.role} • ${member.phone}',
                                    style: PawlyTypography.caption,
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge(
                              label: member.role == 'Owner' ? 'Owner' : 'Co-care',
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // Safety & Emergency
                const Text('SAFETY & EMERGENCY', style: PawlyTypography.eyebrow),
                const SizedBox(height: 8),
                PawlyCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _SettingsRow(
                        icon: Icons.shield_outlined,
                        title: 'Digital Emergency Pet Card',
                        subtitle: 'Vet contacts, microchip, and critical notes',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmergencyCardScreen(repository: widget.repository),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 52, color: PawlyColors.border),
                      _SettingsRow(
                        icon: Icons.warning_amber_rounded,
                        title: 'Lost Pet Mode',
                        subtitle: 'Generate poster & activate emergency alert banner',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LostPetModeScreen(repository: widget.repository),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 52, color: PawlyColors.border),
                      _SettingsRow(
                        icon: Icons.favorite_border_rounded,
                        title: 'Adopt & Foster Discovery',
                        subtitle: 'Browse rescues and foster animals seeking homes',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdoptionDiscoveryScreen(repository: widget.repository),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Notifications
                const Text('NOTIFICATIONS', style: PawlyTypography.eyebrow),
                const SizedBox(height: 8),
                PawlyCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: PawlyColors.border,
                            borderRadius: AppTokens.rSm,
                          ),
                          child: const Icon(Icons.notifications_active_outlined, color: PawlyColors.black, size: 18),
                        ),
                        title: const Text('Daily Routine Reminders', style: PawlyTypography.titleSmall),
                        subtitle: const Text('Feeding, walks, medication reminders', style: PawlyTypography.caption),
                        activeColor: PawlyColors.black,
                        value: _careNotifications,
                        onChanged: (val) => setState(() => _careNotifications = val),
                      ),
                      const Divider(height: 1, indent: 52, color: PawlyColors.border),
                      SwitchListTile(
                        secondary: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: PawlyColors.border,
                            borderRadius: AppTokens.rSm,
                          ),
                          child: const Icon(Icons.event_available_outlined, color: PawlyColors.black, size: 18),
                        ),
                        title: const Text('Veterinary Notifications', style: PawlyTypography.titleSmall),
                        subtitle: const Text('Upcoming visit alerts and prep prompts', style: PawlyTypography.caption),
                        activeColor: PawlyColors.black,
                        value: _vetReminders,
                        onChanged: (val) => setState(() => _vetReminders = val),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Logout button
                PawlyButton(
                  text: 'Log Out of Pawly',
                  
                  isSecondary: true,
                  
                  onPressed: widget.onLogout,
                ),

                const SizedBox(height: 24),

                const Center(
                  child: Text(
                    'Pawly Mobile • Version 2.0.0\nDesigned with care for pets and their companions',
                    textAlign: TextAlign.center,
                    style: PawlyTypography.caption,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: PawlyColors.border,
          borderRadius: AppTokens.rSm,
        ),
        child: Icon(icon, color: PawlyColors.black, size: 18),
      ),
      title: Text(title, style: PawlyTypography.titleSmall),
      subtitle: Text(subtitle, style: PawlyTypography.caption),
      trailing: const Icon(Icons.chevron_right_rounded, color: PawlyColors.tertiary, size: 18),
      onTap: onTap,
    );
  }
}
