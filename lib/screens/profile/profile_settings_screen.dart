import 'package:flutter/material.dart';
import '../../repositories/pawly_repository.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';
import '../adoption/adoption_discovery_screen.dart';
import '../emergency/emergency_card_screen.dart';
import '../emergency/lost_pet_mode_screen.dart';

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
    final emailCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: PawlyColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
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
            Text('Invite Family or Caregiver', style: PawlyTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(
              'Share live care agendas, medication logs, and digital health records with a co-owner or pet sitter.',
              style: PawlyTypography.bodySmall.copyWith(color: PawlyColors.textSecondary),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Caregiver Email',
                hintText: 'e.g. alex@example.com',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 24),
            PawlyButton(
              text: 'Send Care Invite',
              icon: Icons.send_rounded,
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Care invitation sent! They will receive a link to join your family pack.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
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
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  title: Text(
                    'Settings & More',
                    style: PawlyTypography.titleMedium.copyWith(
                      color: PawlyColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: PawlyColors.surface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: PawlyColors.border),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: PawlyColors.forest.withOpacity(0.12),
                              child: const Icon(Icons.person_rounded, color: PawlyColors.forest, size: 30),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: PawlyTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    user.email,
                                    style: PawlyTypography.bodySmall.copyWith(color: PawlyColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            PawlyBadge(
                              label: 'Active Caregiver',
                              backgroundColor: PawlyColors.forest.withOpacity(0.12),
                              textColor: PawlyColors.forest,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Caregiver Pack Section
                      const _SectionHeader(title: 'SHARED CARE & FAMILY'),
                      Container(
                        decoration: BoxDecoration(
                          color: PawlyColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: PawlyColors.border),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.group_add_outlined, color: PawlyColors.forest),
                              title: const Text('Invite Co-Owner or Sitter', style: PawlyTypography.titleSmall),
                              subtitle: const Text('Manage permissions and shared alerts', style: PawlyTypography.bodySmall),
                              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                              onTap: _showInviteCaregiverSheet,
                            ),
                            const Divider(height: 1, indent: 56),
                            const ListTile(
                              leading: Icon(Icons.handshake_outlined, color: PawlyColors.warmHoney),
                              title: Text('Active Family Pack (2 members)', style: PawlyTypography.titleSmall),
                              subtitle: Text('Sarah Miller (Owner), David Miller (Caregiver)', style: PawlyTypography.bodySmall),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Emergency & Rescue
                      const _SectionHeader(title: 'SAFETY & EMERGENCY'),
                      Container(
                        decoration: BoxDecoration(
                          color: PawlyColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: PawlyColors.border),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.emergency_outlined, color: PawlyColors.warmClay),
                              title: const Text('Digital Emergency Pet Card', style: PawlyTypography.titleSmall),
                              subtitle: const Text('Direct clinic access & critical notes', style: PawlyTypography.bodySmall),
                              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EmergencyCardScreen(repository: widget.repository),
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1, indent: 56),
                            ListTile(
                              leading: const Icon(Icons.warning_amber_rounded, color: PawlyColors.alertRose),
                              title: const Text('Lost Pet Mode', style: PawlyTypography.titleSmall),
                              subtitle: const Text('Generate missing poster & alert network', style: PawlyTypography.bodySmall),
                              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LostPetModeScreen(repository: widget.repository),
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1, indent: 56),
                            ListTile(
                              leading: const Icon(Icons.favorite_border_rounded, color: PawlyColors.forest),
                              title: const Text('Adopt & Foster Discovery', style: PawlyTypography.titleSmall),
                              subtitle: const Text('Browse companion animals seeking homes', style: PawlyTypography.bodySmall),
                              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
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
                      const SizedBox(height: 24),

                      // Preferences
                      const _SectionHeader(title: 'PREFERENCES & NOTIFICATIONS'),
                      Container(
                        decoration: BoxDecoration(
                          color: PawlyColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: PawlyColors.border),
                        ),
                        child: Column(
                          children: [
                            SwitchListTile(
                              secondary: const Icon(Icons.notifications_active_outlined, color: PawlyColors.forest),
                              title: const Text('Daily Routine Reminders', style: PawlyTypography.titleSmall),
                              subtitle: const Text('Feeding, walks, medication prompts', style: PawlyTypography.bodySmall),
                              activeColor: PawlyColors.forest,
                              value: _careNotifications,
                              onChanged: (val) => setState(() => _careNotifications = val),
                            ),
                            const Divider(height: 1, indent: 56),
                            SwitchListTile(
                              secondary: const Icon(Icons.event_available_outlined, color: PawlyColors.forest),
                              title: const Text('Veterinary Notifications', style: PawlyTypography.titleSmall),
                              subtitle: const Text('Upcoming visit alerts and prep prompts', style: PawlyTypography.bodySmall),
                              activeColor: PawlyColors.forest,
                              value: _vetReminders,
                              onChanged: (val) => setState(() => _vetReminders = val),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Logout button
                      PawlyButton(
                        text: 'Log Out of Pawly',
                        icon: Icons.logout_rounded,
                        isSecondary: true,
                        onPressed: widget.onLogout,
                      ),
                      const SizedBox(height: 20),

                      Center(
                        child: Text(
                          'Pawly Mobile • Version 2.0.0 (Build 42)\nDesigned with care for pets and their companions',
                          textAlign: TextAlign.center,
                          style: PawlyTypography.bodySmall.copyWith(
                            color: PawlyColors.textMuted,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
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

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: PawlyTypography.labelMedium.copyWith(
          color: PawlyColors.textSecondary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
