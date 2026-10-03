import 'dart:io';
import 'image_test_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pawly/main.dart';
import 'package:pawly/repositories/pawly_repository.dart';
import 'package:pawly/theme/pawly_colors.dart';
import 'package:pawly/theme/app_tokens.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
  });

  testWidgets(
      'Pawly complete user flow: Splash -> Onboarding -> Login -> Home -> Tabs navigation',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final repository = PawlyRepository();
    await repository.init();

    await tester.pumpWidget(PawlyApp(repository: repository));

    // Initially at splash screen
    expect(find.text('Pawly'), findsWidgets);

    // Advance past splash screen timer (1400ms)
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump(const Duration(milliseconds: 300));

    // 1. Verify Onboarding
    expect(find.textContaining('Everything about them.'), findsOneWidget);

    // Tap "Skip" on Onboarding to proceed to Login
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    // 2. Verify Login Screen
    expect(find.textContaining('Welcome\nback to Pawly'), findsOneWidget);
    expect(find.text('Demo Enter'), findsOneWidget);

    // Tap "Demo Enter" to log in
    await tester.ensureVisible(find.text('Demo Enter'));
    await tester.tap(find.text('Demo Enter'));
    await tester.pumpAndSettle();

    // 3. Verify Home Screen is active with pet Maple and care items
    expect(find.text('Maple'), findsWidgets);
    expect(find.textContaining('Care'), findsWidgets);

    // 4. Verify Bottom Nav destinations
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Pets'), findsOneWidget);
    expect(find.text('Care'), findsOneWidget);
    expect(find.text('Health'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);

    // 5. Navigate to Pets tab
    await tester.tap(find.text('Pets'));
    await tester.pumpAndSettle();
    expect(find.text('My Pets'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Cleo'), 250,
        scrollable: find.byType(Scrollable).last);
    expect(find.text('Cleo'), findsWidgets);

    // 6. Navigate to Care tab
    await tester.tap(find.text('Care'));
    await tester.pumpAndSettle();
    expect(find.text('Care'), findsWidgets);
    expect(find.text('+ Add Care'), findsOneWidget);

    // 7. Navigate to Health tab
    await tester.tap(find.text('Health'));
    await tester.pumpAndSettle();
    expect(find.text('Health Records'), findsWidgets);
    expect(find.text('Daily Notes'), findsOneWidget);

    // 8. Navigate to More / Settings tab
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    expect(find.text('Settings & More'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Universal Search'), 200,
        scrollable: find.byType(Scrollable).last);
    expect(find.text('Universal Search'), findsOneWidget);
    expect(find.text('Unified Pet Calendar'), findsOneWidget);
    await tester.scrollUntilVisible(
        find.text('Digital Emergency Pet Card'), 200,
        scrollable: find.byType(Scrollable).last);
    expect(find.text('Digital Emergency Pet Card'), findsOneWidget);
    expect(find.text('Lost Pet Mode'), findsOneWidget);
    expect(find.text('Adopt & Foster Discovery'), findsOneWidget);

    // 9. Open Universal Search, verify PawlyAppBar, and navigate back
    await tester.scrollUntilVisible(find.text('Universal Search'), -200,
        scrollable: find.byType(Scrollable).last);
    await tester.ensureVisible(find.text('Universal Search'));
    await tester.tap(find.text('Universal Search'));
    await tester.pumpAndSettle();
    expect(find.text('Universal Search'), findsWidgets);
    await tester.tap(find.byType(IconButton).first); // Back button
    await tester.pumpAndSettle();
    expect(find.text('Settings & More'), findsOneWidget);
  });

  testWidgets('Pawly Repository Universal Search returns matching entities',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final repository = PawlyRepository();
    await repository.init();
    await repository.seedDemoData();

    // Search for medication
    final medResults = repository.search('Apoquel');
    expect(medResults.isNotEmpty, isTrue);
    expect(medResults.first.title, contains('Apoquel'));

    // Search for pet Maple
    final petResults = repository.search('Maple');
    expect(petResults.isNotEmpty, isTrue);
    expect(petResults.any((r) => r.category == 'Pet'), isTrue);

    // Search for care routine walk
    final careResults = repository.search('Walk');
    expect(careResults.isNotEmpty, isTrue);
  });

  testWidgets('Pawly Theme Tokens & Palette verification',
      (WidgetTester tester) async {
    // Verify standard radius tokens (new design system: 6, 10, 14, 18, 24)
    expect(AppTokens.xs, 6.0);
    expect(AppTokens.sm, 10.0);
    expect(AppTokens.md, 14.0);
    expect(AppTokens.lg, 18.0);
    expect(AppTokens.xl, 24.0);

    // Verify colors are purely black, white, charcoal, neutrals, not green
    expect(PawlyColors.black, const Color(0xFF171717));
    expect(PawlyColors.background, const Color(0xFFFAFAFA));
    expect(PawlyColors.surface, const Color(0xFFFFFFFF));
    expect(PawlyColors.charcoal, const Color(0xFF262626));
  });

  testWidgets(
      'Pawly responsive viewports (320px narrow and 430px wide) without RenderFlex overflow',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final repository = PawlyRepository();
    await repository.init();

    // Test 320px narrow viewport
    tester.view.physicalSize = const Size(320 * 2, 600 * 2);
    tester.view.devicePixelRatio = 2.0;

    await tester.pumpWidget(PawlyApp(repository: repository));
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Demo Enter'));
    await tester.tap(find.text('Demo Enter'));
    await tester.pumpAndSettle();

    // Verify Home Screen on 320px without crash or overflow
    expect(find.text('Maple'), findsWidgets);

    // Test 430px wide viewport (iPhone 14/15 Pro Max)
    tester.view.physicalSize = const Size(430 * 3, 932 * 3);
    tester.view.devicePixelRatio = 3.0;
    await tester.pumpAndSettle();
    expect(find.text('Maple'), findsWidgets);

    // Reset view
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}
