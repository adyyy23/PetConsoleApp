import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
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
    HttpOverrides.global = _MockHttpOverrides();
  });

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

    // 3. Verify Home Screen is active with pet Mochi and care items
    expect(find.text('Mochi'), findsWidgets);
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

    // 9. Open Universal Search, verify PawlyAppBar, and navigate back
    await tester.tap(find.text('Universal Search'));
    await tester.pumpAndSettle();
    expect(find.text('Universal Search'), findsWidgets);
    await tester.tap(find.byType(IconButton).first); // Back button
    await tester.pumpAndSettle();
    expect(find.text('Settings & More'), findsOneWidget);
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

  testWidgets('Pawly Theme Tokens & Palette verification', (WidgetTester tester) async {
    // Verify standard radius tokens
    expect(AppRadius.xs, 4.0);
    expect(AppRadius.sm, 6.0);
    expect(AppRadius.md, 8.0);
    expect(AppRadius.lg, 10.0);
    expect(AppRadius.xl, 12.0);

    // Verify colors are purely black, white, charcoal, neutrals, not green
    expect(PawlyColors.black, const Color(0xFF111111));
    expect(PawlyColors.background, const Color(0xFFFAF9F6));
    expect(PawlyColors.surface, const Color(0xFFFFFFFF));
    expect(PawlyColors.charcoal, const Color(0xFF222222));
  });

  testWidgets('Pawly responsive viewports (320px narrow and 430px wide) without RenderFlex overflow', (WidgetTester tester) async {
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
    await tester.tap(find.text('Demo Enter'));
    await tester.pumpAndSettle();

    // Verify Home Screen on 320px without crash or overflow
    expect(find.text('Mochi'), findsWidgets);

    // Test 430px wide viewport (iPhone 14/15 Pro Max)
    tester.view.physicalSize = const Size(430 * 3, 932 * 3);
    tester.view.devicePixelRatio = 3.0;
    await tester.pumpAndSettle();
    expect(find.text('Mochi'), findsWidgets);

    // Reset view
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}

final Uint8List _transparentPng = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

class _MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  bool autoUncompress = true;
  @override
  Duration? connectionTimeout;
  @override
  Duration idleTimeout = const Duration(seconds: 15);
  @override
  int? maxConnectionsPerHost;
  @override
  String? userAgent;

  @override
  void addCredentials(Uri url, String realm, HttpClientCredentials credentials) {}
  @override
  void addProxyCredentials(String host, int port, String realm, HttpClientCredentials credentials) {}
  @override
  void close({bool force = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #getUrl ||
        invocation.memberName == #openUrl ||
        invocation.memberName == #postUrl ||
        invocation.memberName == #get) {
      return Future.value(_MockHttpClientRequest());
    }
    return super.noSuchMethod(invocation);
  }
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #close) {
      return Future.value(_MockHttpClientResponse());
    }
    return super.noSuchMethod(invocation);
  }
}

class _MockHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  @override
  int get statusCode => 200;
  @override
  int get contentLength => _transparentPng.length;
  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_transparentPng]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
