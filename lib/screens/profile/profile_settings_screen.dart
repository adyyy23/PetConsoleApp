import '../../theme/pawly_palette.dart';
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../repositories/pawly_repository.dart';
import '../../widgets/widgets.dart';
import '../adoption/adoption_discovery_screen.dart';
import '../emergency/emergency_card_screen.dart';
import '../emergency/lost_pet_mode_screen.dart';
import '../calendar/pet_calendar_screen.dart';
import '../search/universal_search_screen.dart';
import '../timeline/pet_timeline_screen.dart';
import '../reminders/reminders_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final PawlyRepository repository;
  final VoidCallback onLogout;
  const ProfileSettingsScreen(
      {super.key, required this.repository, required this.onLogout});
  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  void _open(Widget screen) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => ListenableBuilder(
              listenable: widget.repository, builder: (_, __) => screen)));
  Future<void> _editName() async {
    final name = TextEditingController(text: widget.repository.user.name);
    final key = GlobalKey<FormState>();
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => PawlySheet(
            child: Form(
                key: key,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Make yourself at home',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 16),
                      TextFormField(
                          controller: name,
                          autofocus: true,
                          decoration:
                              const InputDecoration(labelText: 'Your name'),
                          validator: (value) => value!.trim().isEmpty
                              ? 'Enter your name.'
                              : null),
                      const SizedBox(height: 20),
                      PawlyButton(
                          text: 'Save my name',
                          onPressed: () async {
                            if (!key.currentState!.validate()) return;
                            await widget.repository.updateUser(name.text);
                            if (ctx.mounted) Navigator.pop(ctx);
                          }),
                    ]))));
    name.dispose();
  }

  Future<void> _addCaregiver() async {
    final name = TextEditingController();
    final phone = TextEditingController();
    final key = GlobalKey<FormState>();
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => PawlySheet(
            child: Form(
                key: key,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Someone they can count on',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      const Text(
                          'Save a caregiver contact here. This does not send an invitation or give them access to your records.'),
                      const SizedBox(height: 20),
                      TextFormField(
                          controller: name,
                          decoration: const InputDecoration(
                              labelText: 'Caregiver name'),
                          validator: (value) =>
                              value!.trim().isEmpty ? 'Enter a name.' : null),
                      const SizedBox(height: 12),
                      TextFormField(
                          controller: phone,
                          keyboardType: TextInputType.phone,
                          decoration:
                              const InputDecoration(labelText: 'Phone number'),
                          validator: (value) => value!.trim().isEmpty
                              ? 'Enter a phone number.'
                              : null),
                      const SizedBox(height: 20),
                      PawlyButton(
                          text: 'Save caregiver contact',
                          onPressed: () async {
                            if (!key.currentState!.validate()) return;
                            await widget.repository.addCaregiver(CareCircleMember(
                                id: 'contact_${DateTime.now().microsecondsSinceEpoch}',
                                name: name.text.trim(),
                                role: 'Caregiver',
                                email: '',
                                phone: phone.text.trim()));
                            if (ctx.mounted) Navigator.pop(ctx);
                          }),
                    ]))));
    name.dispose();
    phone.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: widget.repository,
      builder: (context, _) {
        final repo = widget.repository;
        final scheme = Theme.of(context).colorScheme;
        return Scaffold(
            appBar: AppBar(title: const Text('Settings & More')),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                PawlyCard(
                    onTap: _editName,
                    child: Row(children: [
                      CircleAvatar(
                          backgroundColor: scheme.primaryContainer,
                          child: Icon(Icons.person_outline,
                              color: scheme.onPrimaryContainer)),
                      const SizedBox(width: 14),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(repo.user.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text('Local profile · saved on this device',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: scheme.onSurfaceVariant)),
                          ])),
                      const Icon(Icons.edit_outlined, size: 20),
                    ])),
                const SizedBox(height: 28),
                const Text('Make it feel like you',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                const Text('Choose your colors. Black & white is the default.'),
                const SizedBox(height: 14),
                Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: PawlyPalette.values
                        .map((palette) => ChoiceChip(
                              label: Text(palette.label),
                              avatar: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                      color: palette.lightAccent,
                                      shape: BoxShape.circle)),
                              selected: repo.palette == palette,
                              onSelected: (_) => repo.setPalette(palette),
                            ))
                        .toList()),
                const SizedBox(height: 18),
                const Text('Appearance',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                          value: ThemeMode.system, label: Text('Auto')),
                      ButtonSegment(
                          value: ThemeMode.light, label: Text('Light')),
                      ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                    ],
                    selected: {
                      repo.themeMode
                    },
                    onSelectionChanged: (selection) =>
                        repo.setThemeMode(selection.first)),
                const SizedBox(height: 28),
                const Text('Their everyday essentials',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                PawlyCard(
                    padding: EdgeInsets.zero,
                    child: Column(children: [
                      _tool(
                          Icons.notifications_none,
                          'Care reminders',
                          'Today, upcoming and completed for all pets',
                          () => _open(RemindersScreen(repository: repo))),
                      _tool(
                          Icons.search,
                          'Universal Search',
                          'Find care, health records and memories',
                          () => _open(UniversalSearchScreen(repository: repo))),
                      _tool(
                          Icons.calendar_month_outlined,
                          'Unified Pet Calendar',
                          'Plan care for your selected companion',
                          () => _open(PetCalendarScreen(repository: repo))),
                      _tool(
                          Icons.history,
                          'Their story',
                          'Health milestones and everyday memories',
                          () => _open(PetTimelineScreen(repository: repo))),
                    ])),
                const SizedBox(height: 28),
                Row(children: [
                  const Expanded(
                      child: Text('Caregiver contacts',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700))),
                  IconButton(
                      tooltip: 'Add caregiver contact',
                      onPressed: _addCaregiver,
                      icon: const Icon(Icons.person_add_outlined))
                ]),
                PawlyCard(
                    child: repo.careCircle.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                const Text('A helping hand, close by.',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 6),
                                const Text(
                                    'Keep a sitter or family member’s contact on hand.'),
                                const SizedBox(height: 12),
                                PawlyButton(
                                    text: 'Add a caregiver',
                                    isSmall: true,
                                    isSecondary: true,
                                    onPressed: _addCaregiver),
                              ])
                        : Column(
                            children: repo.careCircle
                                .map((member) => ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: const Icon(Icons.person_outline),
                                    title: Text(member.name),
                                    subtitle: Text(member.phone)))
                                .toList())),
                const SizedBox(height: 28),
                const Text('For peace of mind',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                PawlyCard(
                    padding: EdgeInsets.zero,
                    child: Column(children: [
                      _tool(
                          Icons.shield_outlined,
                          'Digital Emergency Pet Card',
                          'Contact details and essential pet information',
                          () => _open(EmergencyCardScreen(repository: repo))),
                      _tool(
                          Icons.warning_amber,
                          'Lost Pet Mode',
                          'Prepare details you can copy and share',
                          () => _open(LostPetModeScreen(repository: repo))),
                      _tool(
                          Icons.favorite_border,
                          'Adopt & Foster Discovery',
                          'Example rescue listings and inquiry drafts',
                          () =>
                              _open(AdoptionDiscoveryScreen(repository: repo))),
                    ])),
                const SizedBox(height: 24),
                Text(
                    'Pawly keeps records on this device. Care reminders appear in the app; phone notifications, file uploads, shelter submissions and shared online accounts are not connected.',
                    style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        height: 1.5,
                        fontSize: 13)),
                const SizedBox(height: 24),
                PawlyButton(
                    text: 'Close my local profile',
                    isSecondary: true,
                    onPressed: widget.onLogout),
                const SizedBox(height: 24),
                Center(
                    child: Text('Pawly · A little care. Every day.',
                        style: TextStyle(
                            color: scheme.onSurfaceVariant, fontSize: 12))),
              ],
            ));
      });
  Widget _tool(
          IconData icon, String title, String subtitle, VoidCallback action) =>
      ListTile(
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(title),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: action);
}
