import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const OnboardingScreen({super.key, required this.onFinish});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _chapter = 0;
  bool _breakfast = false;
  String _companion = 'Dog';
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final headings = [
      'Everything about them.\nOne little home.',
      'Small routines.\nA happier every day.',
      'Their health.\nTheir whole story.'
    ];
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(children: [
            Icon(Icons.pets, color: scheme.primary),
            const SizedBox(width: 8),
            const Text('Pawly',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
            const Spacer(),
            TextButton(onPressed: widget.onFinish, child: const Text('Skip')),
          ])),
      Expanded(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: AnimatedSwitcher(
                duration: MediaQuery.of(context).disableAnimations
                    ? Duration.zero
                    : const Duration(milliseconds: 250),
                child: Column(
                    key: ValueKey(_chapter),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          [
                            'MEET YOUR COMPANION',
                            'TRY A LITTLE CARE',
                            'KEEP WHAT MATTERS'
                          ][_chapter],
                          style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                              color: scheme.primary)),
                      const SizedBox(height: 16),
                      Text(headings[_chapter],
                          style: const TextStyle(
                              fontSize: 34,
                              height: 1.12,
                              letterSpacing: -.8,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 24),
                      if (_chapter == 0) ...[
                        PawlyCard(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Row(children: [
                                CircleAvatar(
                                    radius: 32,
                                    backgroundColor: scheme.primaryContainer,
                                    child: Icon(Icons.pets,
                                        size: 34, color: scheme.primary)),
                                const SizedBox(width: 16),
                                const Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text('Your favourite someone',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700)),
                                      SizedBox(height: 4),
                                      Text('A space that grows with them'),
                                    ])),
                              ]),
                              const SizedBox(height: 24),
                              const Text('Who shares your home?'),
                              const SizedBox(height: 12),
                              Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: ['Dog', 'Cat', 'Other']
                                      .map((species) => ChoiceChip(
                                          label: Text(species),
                                          selected: _companion == species,
                                          onSelected: (_) => setState(
                                              () => _companion = species)))
                                      .toList()),
                            ])),
                        const SizedBox(height: 20),
                        const Text(
                            'From the first breakfast to their next vet visit, keep every pet’s care together. Add your own companion after this introduction.',
                            style: TextStyle(fontSize: 16, height: 1.6)),
                      ],
                      if (_chapter == 1) ...[
                        PawlyCard(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              const Text('A PREVIEW OF THEIR DAY',
                                  style: TextStyle(
                                      fontSize: 11, letterSpacing: 1)),
                              const SizedBox(height: 16),
                              CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  value: _breakfast,
                                  title: const Text('Breakfast & fresh water'),
                                  subtitle: Text(_breakfast
                                      ? 'A little care, taken care of.'
                                      : 'Tap to try completing a routine'),
                                  onChanged: (value) =>
                                      setState(() => _breakfast = value!)),
                              const Divider(),
                              const ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(Icons.directions_walk),
                                  title: Text('Evening walk'),
                                  subtitle: Text('Later today')),
                              AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 180),
                                  child: Text(
                                      _breakfast
                                          ? '1 of 2 moments of care complete'
                                          : 'Two small things. One lovely day.',
                                      key: ValueKey(_breakfast),
                                      style: TextStyle(
                                          color: scheme.primary,
                                          fontWeight: FontWeight.w600))),
                            ])),
                        const SizedBox(height: 20),
                        const Text(
                            'Create routines that fit your pet. Mark care done for each day and plan ahead with a shared calendar.',
                            style: TextStyle(fontSize: 16, height: 1.6)),
                      ],
                      if (_chapter == 2) ...[
                        PawlyCard(
                            child: Column(children: [
                          _story(
                              context,
                              Icons.favorite_border,
                              'Health, ready when you need it',
                              'Vaccinations, medication and vet notes'),
                          const Divider(height: 24),
                          _story(context, Icons.auto_graph, 'See how they grow',
                              'Weigh-ins alongside their milestones'),
                          const Divider(height: 24),
                          _story(
                              context,
                              Icons.photo_library_outlined,
                              'Remember the little things',
                              'Memories and care in one timeline'),
                        ])),
                        const SizedBox(height: 20),
                        const Text(
                            'Your records are saved on this device. Pawly’s agenda shows upcoming care inside the app; it does not send phone notifications.',
                            style: TextStyle(fontSize: 16, height: 1.6)),
                      ],
                    ]),
              ))),
      Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          child: Column(children: [
            Row(
                children: List.generate(
                    3,
                    (index) => Expanded(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                height: 4,
                                decoration: BoxDecoration(
                                    color: index <= _chapter
                                        ? scheme.primary
                                        : scheme.outlineVariant,
                                    borderRadius:
                                        BorderRadius.circular(2))))))),
            const SizedBox(height: 16),
            PawlyButton(
                text: _chapter == 2
                    ? 'Make room for my pet'
                    : _chapter == 0
                        ? 'Explore their day'
                        : 'Discover their story',
                onPressed: () {
                  if (_chapter == 2) {
                    widget.onFinish();
                  } else {
                    setState(() => _chapter++);
                  }
                }),
            if (_chapter > 0)
              TextButton(
                  onPressed: () => setState(() => _chapter--),
                  child: const Text('Back')),
          ])),
    ])));
  }

  Widget _story(
          BuildContext context, IconData icon, String title, String subtitle) =>
      Row(children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
        const SizedBox(width: 14),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(height: 1.4)),
        ])),
      ]);
}
