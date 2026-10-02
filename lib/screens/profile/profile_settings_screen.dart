import 'package:flutter/material.dart';
import '../../repositories/pawly_repository.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
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
            color: PawlyColors.surfaceWarm,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
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
              const SizedBox(height: 18),
              const Text('Invite to Care Circle', style: PawlyTypography.titleMedium),
              const SizedBox(height: 6),
              const Text(
                'Share care agendas, medication schedules, and digital health records with a co-owner or pet sitter.',
                style: TextStyle(fontSize: 13, color: PawlyColors.warmGrey),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Caregiver Name',
                  hintText: 'e.g. Alex',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: PawlyColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'e.g. alex@example.com',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: PawlyColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Role', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PawlyColors.warmGrey)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: ['Family Co-owner', 'Pet Sitter', 'Walker'].map((r) {
                  final isSelected = role == r;
                  return ChoiceChip(
                    label: Text(r),
                    selected: isSelected,
                    selectedColor: PawlyColors.forest,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : PawlyColors.espresso,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    onSelected: (_) => setModalState(() => role = r),
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
          backgroundColor: PawlyColors.creamBg,
          appBar: AppBar(
            backgroundColor: PawlyColors.creamBg,
            elevation: 0,
            title: const Text('Settings & More', style: PawlyTypography.titleLarge),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Card
                PawlyBubble(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundColor: PawlyColors.forestLight,
                        child: Icon(Icons.person_rounded, color: PawlyColors.forest, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name, style: PawlyTypography.titleMedium),
                            const SizedBox(height: 2),
                            Text(user.email, style: const TextStyle(fontSize: 12, color: PawlyColors.warmGrey)),
                          ],
                        ),
                      ),
                      const PawlyBadge(label: 'Owner', variant: PawlyBadgeVariant.sage),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Tools & Shortcuts
                const Text('TOOLS & DISCOVERY', style: PawlyTypography.labelSmall),
                const SizedBox(height: 10),
                PawlyBubble(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: PawlyColors.surfaceWarm,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.search_rounded, color: PawlyColors.forest, size: 20),
                        ),
                        title: const Text('Universal Search', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: PawlyColors.espresso)),
                        subtitle: const Text('Search across routines, health, meds & docs', style: TextStyle(fontSize: 12, color: PawlyColors.warmGrey)),
                        trailing: const Icon(Icons.chevron_right_rounded, color: PawlyColors.warmGrey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UniversalSearchScreen(repository: widget.repository),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 60),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: PawlyColors.butterYellow,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.calendar_month_outlined, color: PawlyColors.espresso, size: 20),
                        ),
                        title: const Text('Unified Pet Calendar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: PawlyColors.espresso)),
                        subtitle: const Text('Monthly schedule for appointments and routines', style: TextStyle(fontSize: 12, color: PawlyColors.warmGrey)),
                        trailing: const Icon(Icons.chevron_right_rounded, color: PawlyColors.warmGrey),
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
                    const Text('CARE CIRCLE & FAMILY PACK', style: PawlyTypography.labelSmall),
                    GestureDetector(
                      onTap: _showInviteCaregiverSheet,
                      child: const Text(
                        '+ Invite',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: PawlyColors.forest,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                PawlyBubble(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: careCircle.map((member) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            ClipOval(
                              child: member.avatarUrl.isNotEmpty
                                  ? Image.network(
                                      member.avatarUrl,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 40,
                                        height: 40,
                                        color: PawlyColors.forestLight,
                                        alignment: Alignment.center,
                                        child: Text(
                                          member.name.isNotEmpty ? member.name[0] : 'C',
                                          style: const TextStyle(fontWeight: FontWeight.w800, color: PawlyColors.forest),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 40,
                                      height: 40,
                                      color: PawlyColors.forestLight,
                                      alignment: Alignment.center,
                                      child: Text(
                                        member.name.isNotEmpty ? member.name[0] : 'C',
                                        style: const TextStyle(fontWeight: FontWeight.w800, color: PawlyColors.forest),
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
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: PawlyColors.espresso,
                                    ),
                                  ),
                                  Text(
                                    '${member.role} • ${member.phone}',
                                    style: const TextStyle(fontSize: 12, color: PawlyColors.warmGrey),
                                  ),
                                ],
                              ),
                            ),
                            PawlyBadge(
                              label: member.role == 'Owner' ? 'Owner' : 'Co-care',
                              variant: member.role == 'Owner' ? PawlyBadgeVariant.sage : PawlyBadgeVariant.slate,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // Safety & Emergency
                const Text('SAFETY & EMERGENCY', style: PawlyTypography.labelSmall),
                const SizedBox(height: 10),
                PawlyBubble(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: PawlyColors.terracottaLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.shield_outlined, color: PawlyColors.terracotta, size: 20),
                        ),
                        title: const Text('Digital Emergency Pet Card', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: PawlyColors.espresso)),
                        subtitle: const Text('Vet contacts, microchip, and critical notes', style: TextStyle(fontSize: 12, color: PawlyColors.warmGrey)),
                        trailing: const Icon(Icons.chevron_right_rounded, color: PawlyColors.warmGrey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmergencyCardScreen(repository: widget.repository),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 60),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: PawlyColors.roseLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.warning_amber_rounded, color: PawlyColors.rose, size: 20),
                        ),
                        title: const Text('Lost Pet Mode', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: PawlyColors.espresso)),
                        subtitle: const Text('Generate poster & activate emergency alert banner', style: TextStyle(fontSize: 12, color: PawlyColors.warmGrey)),
                        trailing: const Icon(Icons.chevron_right_rounded, color: PawlyColors.warmGrey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LostPetModeScreen(repository: widget.repository),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 60),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: PawlyColors.sageLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.pets_outlined, color: PawlyColors.forest, size: 20),
                        ),
                        title: const Text('Adopt & Foster Discovery', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: PawlyColors.espresso)),
                        subtitle: const Text('Browse rescues and foster animals seeking homes', style: TextStyle(fontSize: 12, color: PawlyColors.warmGrey)),
                        trailing: const Icon(Icons.chevron_right_rounded, color: PawlyColors.warmGrey),
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
                const Text('NOTIFICATIONS', style: PawlyTypography.labelSmall),
                const SizedBox(height: 10),
                PawlyBubble(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: const Icon(Icons.notifications_active_outlined, color: PawlyColors.forest),
                        title: const Text('Daily Routine Reminders', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: PawlyColors.espresso)),
                        subtitle: const Text('Feeding, walks, medication reminders', style: TextStyle(fontSize: 12, color: PawlyColors.warmGrey)),
                        activeColor: PawlyColors.forest,
                        value: _careNotifications,
                        onChanged: (val) => setState(() => _careNotifications = val),
                      ),
                      const Divider(height: 1, indent: 60),
                      SwitchListTile(
                        secondary: const Icon(Icons.event_available_outlined, color: PawlyColors.forest),
                        title: const Text('Veterinary Notifications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: PawlyColors.espresso)),
                        subtitle: const Text('Upcoming visit alerts and prep prompts', style: TextStyle(fontSize: 12, color: PawlyColors.warmGrey)),
                        activeColor: PawlyColors.forest,
                        value: _vetReminders,
                        onChanged: (val) => setState(() => _vetReminders = val),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Logout button
                SizedBox(
                  width: double.infinity,
                  child: PawlyButton(
                    text: 'Log Out of Pawly',
                    icon: Icons.logout_rounded,
                    isSecondary: true,
                    onPressed: widget.onLogout,
                  ),
                ),

                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    'Pawly Mobile • Version 2.0.0\nDesigned with care for pets and their companions',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: PawlyColors.mutedGrey,
                      height: 1.4,
                    ),
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
