import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pawly/main.dart';
import 'package:pawly/repositories/pawly_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Pawly complete user flow: Splash -> Onboarding -> Login -> Home -> Tabs navigation', (WidgetTester tester) async {
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
    expect(find.textContaining('Their whole world'), findsOneWidget);

    // Tap "Skip" on Onboarding to proceed to Login
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    // 2. Verify Login Screen
    expect(find.textContaining('Welcome\nback to Pawly'), findsOneWidget);
    expect(find.text('Demo Enter'), findsOneWidget);

    // Tap "Demo Enter" to log in
    await tester.tap(find.text('Demo Enter'));
    await tester.pumpAndSettle();

    // 3. Verify Home Screen is active with pet Mochi, wellness, and Care routine
    expect(find.text('Mochi'), findsWidgets);
    expect(find.textContaining('Care Routine'), findsWidgets);
    expect(find.text('WATER'), findsOneWidget);
    expect(find.text('MEALS'), findsOneWidget);

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
    expect(find.text('Luna'), findsWidgets);

    // 6. Navigate to Care tab
    await tester.tap(find.text('Care'));
    await tester.pumpAndSettle();
    expect(find.text('Care Agenda'), findsOneWidget);
    expect(find.textContaining('Care Consistency'), findsOneWidget);

    // 7. Navigate to Health tab
    await tester.tap(find.text('Health'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Health Story'), findsOneWidget);
    expect(find.text('Daily Observations & Symptoms'), findsOneWidget);

    // 8. Navigate to More / Settings tab
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    expect(find.text('Settings & More'), findsOneWidget);
    expect(find.text('Universal Search'), findsOneWidget);
    expect(find.text('Unified Pet Calendar'), findsOneWidget);
    expect(find.text('Digital Emergency Pet Card'), findsOneWidget);
    expect(find.text('Lost Pet Mode'), findsOneWidget);
    expect(find.text('Adopt & Foster Discovery'), findsOneWidget);
  });

  testWidgets('Pawly Repository Universal Search returns matching entities', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final repository = PawlyRepository();
    await repository.init();

    // Search for medication
    final medResults = repository.search('Apoquel');
    expect(medResults.isNotEmpty, isTrue);
    expect(medResults.first.title, contains('Apoquel'));

    // Search for pet Mochi
    final petResults = repository.search('Mochi');
    expect(petResults.isNotEmpty, isTrue);
    expect(petResults.any((r) => r.category == 'Pet'), isTrue);

    // Search for care routine walk
    final careResults = repository.search('Walk');
    expect(careResults.isNotEmpty, isTrue);
  });
}
