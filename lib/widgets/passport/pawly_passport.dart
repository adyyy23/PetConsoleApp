import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../widgets.dart';

/// A personal booklet with actual saved identity and vaccination pages.
class PawlyPassport extends StatefulWidget {
  final Pet pet;
  final String ownerName;
  final List<VaccinationRecord> vaccines;
  const PawlyPassport(
      {super.key,
      required this.pet,
      required this.ownerName,
      required this.vaccines});
  @override
  State<PawlyPassport> createState() => _PawlyPassportState();
}

class _PawlyPassportState extends State<PawlyPassport> {
  int _page = -1;
  void _turn(int page) => setState(() => _page = page);
  Widget _field(String title, String value) => Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title.toUpperCase(),
            style: TextStyle(
                fontSize: 10,
                letterSpacing: 1,
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(value.isEmpty ? 'Not recorded' : value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ]));
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pet = widget.pet;
    final page = _page.clamp(-1, widget.vaccines.length);
    Widget contents;
    if (page < 0) {
      contents = Semantics(
          button: true,
          label: 'Open ${pet.name}’s passport',
          child: InkWell(
              onTap: () => _turn(0),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                  key: const ValueKey('cover'),
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(28, 28, 22, 24),
                  decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border(
                          left: BorderSide(
                              color: scheme.onPrimary.withOpacity(.25),
                              width: 8))),
                  child: Column(children: [
                    Text('PAWLY',
                        style: TextStyle(
                            color: scheme.onPrimary,
                            letterSpacing: 5,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 18),
                    Icon(Icons.pets_outlined,
                        color: scheme.onPrimary, size: 54),
                    const SizedBox(height: 20),
                    Text('PET\nPASSPORT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: scheme.onPrimary,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                            height: 1.3)),
                    const SizedBox(height: 20),
                    Text(pet.name.toUpperCase(),
                        style: TextStyle(
                            color: scheme.onPrimary,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('Personal health & identity record',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: scheme.onPrimary.withOpacity(.75),
                            fontSize: 11)),
                    const SizedBox(height: 26),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Open passport',
                          style: TextStyle(
                              color: scheme.onPrimary,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward,
                          color: scheme.onPrimary, size: 18)
                    ]),
                  ]))));
    } else {
      final record = page == 0 ? null : widget.vaccines[page - 1];
      final status = record?.effectiveStatus;
      final statusText = status == VaccineStatus.overdue
          ? 'BOOSTER OVERDUE'
          : status == VaccineStatus.dueSoon
              ? 'BOOSTER DUE SOON'
              : 'RECORDED';
      contents = Container(
          key: ValueKey('${pet.id}:$page'),
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 22, 18, 18),
          decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: scheme.outlineVariant)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.pets_outlined, size: 17, color: scheme.primary),
              const SizedBox(width: 8),
              const Expanded(
                  child: Text('PAWLY / PET PASSPORT',
                      style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700))),
              Text('${page + 1}'.padLeft(2, '0'),
                  style:
                      TextStyle(color: scheme.onSurfaceVariant, fontSize: 12))
            ]),
            const Divider(height: 28),
            Text(record == null ? 'Identity page' : 'Vaccination entry',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'serif')),
            const SizedBox(height: 20),
            if (record == null) ...[
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                    width: 88,
                    height: 108,
                    decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        border: Border.all(color: scheme.outlineVariant)),
                    child: Image(
                        image: pawlyImageProvider(pet.imageUrl),
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.pets_outlined))),
                const SizedBox(width: 16),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      _field('Name', pet.name),
                      _field('Species', pet.animalType),
                      _field('Sex', pet.gender)
                    ])),
              ]),
              _field('Breed', pet.breed),
              _field('Birthday', pet.birthday),
              _field('Microchip', pet.microchipNumber),
              _field('Pet parent', widget.ownerName),
            ] else ...[
              Row(children: [
                PetAvatar(imageUrl: pet.imageUrl, radius: 22),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(pet.name,
                        style: const TextStyle(fontWeight: FontWeight.w700)))
              ]),
              const SizedBox(height: 18),
              Text(record.vaccineName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 18),
              _field('Given on', record.dateAdministered),
              _field('Next booster', record.nextDueDate),
              _field('Clinic', record.clinic),
              _field('Veterinarian', record.veterinarian),
              if (record.notes.isNotEmpty) _field('Notes', record.notes),
              Transform.rotate(
                  angle: -.035,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 9),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: status == VaccineStatus.overdue
                                  ? scheme.error
                                  : scheme.primary,
                              width: 1.5),
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(statusText,
                          style: TextStyle(
                              color: status == VaccineStatus.overdue
                                  ? scheme.error
                                  : scheme.primary,
                              fontSize: 11,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w700)))),
            ],
            const Divider(height: 32),
            Text('OWNER-ENTERED · PERSONAL CARE RECORD',
                style: TextStyle(
                    fontSize: 9,
                    letterSpacing: .7,
                    color: scheme.onSurfaceVariant)),
          ]));
    }
    return Column(children: [
      AnimatedSwitcher(
          duration: MediaQuery.of(context).disableAnimations
              ? Duration.zero
              : const Duration(milliseconds: 220),
          child: contents),
      if (page >= 0) ...[
        const SizedBox(height: 8),
        Row(children: [
          IconButton(
              tooltip: 'Previous passport page',
              onPressed: page > 0 ? () => _turn(page - 1) : null,
              icon: const Icon(Icons.chevron_left)),
          Expanded(
              child: Text('Page ${page + 1} of ${widget.vaccines.length + 1}',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: scheme.onSurfaceVariant, fontSize: 12))),
          IconButton(
              tooltip: 'Next passport page',
              onPressed:
                  page < widget.vaccines.length ? () => _turn(page + 1) : null,
              icon: const Icon(Icons.chevron_right)),
          IconButton(
              tooltip: 'Close passport',
              onPressed: () => _turn(-1),
              icon: const Icon(Icons.menu_book_outlined)),
        ]),
      ],
    ]);
  }
}
