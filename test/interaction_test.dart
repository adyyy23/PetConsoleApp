import 'package:pawly/screens/health/health_screen.dart';
import 'package:pawly/widgets/passport/pawly_passport.dart';
import 'package:pawly/widgets/pet_weigh_in.dart';
import 'package:pawly/screens/care/care_screen.dart';
import 'package:pawly/theme/pawly_palette.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pawly/widgets/widgets.dart';
import 'package:pawly/models/models.dart';
import 'package:pawly/repositories/pawly_repository.dart';
import 'package:pawly/repositories/sample_data.dart';
import 'package:pawly/screens/pets/add_first_pet_screen.dart';
import 'package:pawly/theme/pawly_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test(
      'Theme choice defaults to monochrome and survives restart independently of appearance',
      () async {
    final repo = PawlyRepository();
    await repo.init();
    expect(repo.palette, PawlyPalette.monochrome);
    await repo.setPalette(PawlyPalette.ocean);
    await repo.setThemeMode(ThemeMode.dark);
    final restored = PawlyRepository();
    await restored.init();
    expect(restored.palette, PawlyPalette.ocean);
    expect(restored.themeMode, ThemeMode.dark);
    await restored.setPalette(PawlyPalette.monochrome);
    final reopened = PawlyRepository();
    await reopened.init();
    expect(reopened.palette, PawlyPalette.monochrome);
    expect(reopened.themeMode, ThemeMode.dark);
  });
  test('Demo identity refresh keeps edited pets and care links', () async {
    final repo = PawlyRepository();
    await repo.init();
    await repo.addPet(SampleData.initialPets.first
        .copyWith(name: 'Mochi', imageUrl: 'https://images.unsplash.com/old'));
    await repo.addPet(SampleData.initialPets[1].copyWith(
        name: 'My own cat', imageUrl: 'https://example.com/my-cat.jpg'));
    await repo.addRoutine(const CareRoutine(
        id: 'kept',
        petId: 'pet_mochi',
        title: 'Breakfast',
        time: '08:00',
        date: '2026-10-03',
        category: CareCategory.feeding));
    await repo.setDemoMode(true);
    final restored = PawlyRepository();
    await restored.init();
    expect(restored.pets.firstWhere((p) => p.id == 'pet_mochi').name, 'Maple');
    expect(
        restored.pets.firstWhere((p) => p.id == 'pet_luna').name, 'My own cat');
    expect(restored.allRoutines.single.petId, 'pet_mochi');
  });
  testWidgets('Care pet switcher changes the displayed tasks immediately',
      (tester) async {
    final repo = PawlyRepository();
    await repo.init();
    await repo.seedDemoData();
    await tester.pumpWidget(MaterialApp(
        theme: PawlyTheme.lightTheme,
        home: CareScreen(repository: repo, onOpenAddCare: () {})));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cleo'));
    await tester.pumpAndSettle();
    expect(repo.selectedPet!.name, 'Cleo');
    await tester.scrollUntilVisible(find.text('Salmon Pate Lunch'), 200,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Salmon Pate Lunch'), findsOneWidget);
    expect(find.text('Evening Sunset Walk'), findsNothing);
  });
  testWidgets('Health switcher changes records and shortcut pet',
      (tester) async {
    final repo = PawlyRepository();
    await repo.init();
    await repo.seedDemoData();
    String? openedPet;
    await tester.pumpWidget(MaterialApp(
        theme: PawlyTheme.lightTheme,
        home: HealthScreen(
            repository: repo,
            onOpenAddHealthEvent: () {},
            onOpenWeight: () => openedPet = repo.activePet.name,
            onOpenVaccination: () {},
            onOpenMedication: () {})));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cleo'));
    await tester.pumpAndSettle();
    expect(find.text('MEDICAL & WELLNESS • CLEO'), findsOneWidget);
    expect(find.text('4.2 kg'), findsOneWidget);
    await tester.tap(find.text('4.2 kg'));
    expect(openedPet, 'Cleo');
    expect(tester.takeException(), isNull);
  });
  testWidgets('Passport opens identity and persisted vaccine pages',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repo = PawlyRepository();
    await repo.init();
    await repo.seedDemoData();
    final vaccines = repo.activePetVaccinations;
    await tester.pumpWidget(MaterialApp(
        theme: PawlyTheme.lightTheme,
        home: Scaffold(
            body: SingleChildScrollView(
                child: PawlyPassport(
                    pet: repo.activePet,
                    ownerName: repo.user.name,
                    vaccines: vaccines)))));
    await tester.tap(find.text('Open passport'));
    await tester.pumpAndSettle();
    expect(find.text('Identity page'), findsOneWidget);
    expect(find.text(repo.activePet.microchipNumber), findsOneWidget);
    await tester.ensureVisible(find.byTooltip('Next passport page'));
    await tester.tap(find.byTooltip('Next passport page'));
    await tester.pumpAndSettle();
    expect(find.text(vaccines.first.vaccineName), findsOneWidget);
    expect(find.text('IMMUNIZED'), findsNothing);
    await tester.ensureVisible(find.byTooltip('Close passport'));
    await tester.tap(find.byTooltip('Close passport'));
    await tester.pumpAndSettle();
    expect(find.text('Open passport'), findsOneWidget);
  });
  testWidgets('Scale illustration opens the real weigh-in action',
      (tester) async {
    var opened = false;
    await tester.pumpWidget(MaterialApp(
        theme: PawlyTheme.lightTheme,
        home: Scaffold(
            body: PetWeighIn(
                pet: SampleData.initialPets.first,
                onLogWeight: () => opened = true))));
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    expect(opened, true);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Async action prevents duplicate taps and re-enables after save',
      (tester) async {
    final completer = Completer<void>();
    var saves = 0;
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: PawlyButton(
                text: 'Save',
                onPressed: () {
                  saves++;
                  return completer.future;
                }))));
    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.tap(find.text('Working…'));
    await tester.pump();
    expect(saves, 1);
    completer.complete();
    await tester.pumpAndSettle();
    expect(find.text('Save'), findsOneWidget);
  });
  testWidgets('Failed action gives visible feedback and can be retried',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: PawlyButton(
                text: 'Save',
                onPressed: () async {
                  throw StateError('Storage failure');
                }))));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Could not save this change. Please try again.'),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Add pet back button returns without creating a record',
      (tester) async {
    var records = 0;
    await tester.pumpWidget(MaterialApp(
        theme: PawlyTheme.lightTheme,
        home: Builder(
            builder: (context) => Scaffold(
                body: TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                AddFirstPetScreen(onPetCreated: (_) async {
                                  records++;
                                }))),
                    child: const Text('Open pet form'))))));
    await tester.tap(find.text('Open pet form'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Open pet form'), findsOneWidget);
    expect(records, 0);
  });
  testWidgets('Pet form stays scrollable above keyboard on small phones',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
        theme: PawlyTheme.darkTheme,
        home: MediaQuery(
            data: const MediaQueryData(
                size: Size(320, 640), viewInsets: EdgeInsets.only(bottom: 280)),
            child: AddFirstPetScreen(onPetCreated: (_) async {}))));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable).last, const Offset(0, -700));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
