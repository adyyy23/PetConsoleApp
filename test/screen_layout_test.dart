import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pawly/repositories/pawly_repository.dart';
import 'package:pawly/theme/pawly_theme.dart';
import 'image_test_support.dart';
import 'package:pawly/screens/home/home_screen.dart';
import 'package:pawly/screens/splash/splash_screen.dart';
import 'package:pawly/screens/calendar/pet_calendar_screen.dart';
import 'package:pawly/screens/care/add_care_screen.dart';
import 'package:pawly/screens/care/care_screen.dart';
import 'package:pawly/screens/appointments/vet_visit_prep_screen.dart';
import 'package:pawly/screens/appointments/add_appointment_screen.dart';
import 'package:pawly/screens/appointments/appointments_screen.dart';
import 'package:pawly/screens/auth/signup_screen.dart';
import 'package:pawly/screens/auth/login_screen.dart';
import 'package:pawly/screens/auth/forgot_password_screen.dart';
import 'package:pawly/screens/pets/my_pets_screen.dart';
import 'package:pawly/screens/pets/add_first_pet_screen.dart';
import 'package:pawly/screens/pets/pet_space_screen.dart';
import 'package:pawly/screens/health/add_health_event_screen.dart';
import 'package:pawly/screens/health/health_screen.dart';
import 'package:pawly/screens/emergency/emergency_card_screen.dart';
import 'package:pawly/screens/emergency/lost_pet_mode_screen.dart';
import 'package:pawly/screens/adoption/adoption_discovery_screen.dart';
import 'package:pawly/screens/growth/weight_growth_screen.dart';
import 'package:pawly/screens/search/universal_search_screen.dart';
import 'package:pawly/screens/profile/profile_settings_screen.dart';
import 'package:pawly/screens/vaccination/vaccination_passport_screen.dart';
import 'package:pawly/screens/documents/documents_screen.dart';
import 'package:pawly/screens/medication/medication_screen.dart';
import 'package:pawly/screens/timeline/pet_timeline_screen.dart';
import 'package:pawly/screens/memories/memories_screen.dart';
import 'package:pawly/screens/reminders/reminders_screen.dart';
import 'package:pawly/screens/onboarding/onboarding_screen.dart';

void noop() {}
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => HttpOverrides.global = MockHttpOverrides());
  final screens = <String, Widget Function(PawlyRepository)>{
    'Home': (r) => HomeScreen(
        repository: r,
        onOpenAddPet: noop,
        onOpenAddCare: noop,
        onOpenCareTab: noop,
        onOpenHealthTab: noop,
        onOpenPetSpace: (_) {},
        onOpenAppointments: noop,
        onOpenWeight: noop),
    'Pets': (r) =>
        MyPetsScreen(repository: r, onOpenPetSpace: (_) {}, onOpenAddPet: noop),
    'Pet profile': (r) => PetSpaceScreen(
        repository: r,
        petId: r.selectedPetId,
        onBack: noop,
        onOpenAddCare: noop,
        onOpenAddHealth: noop,
        onOpenWeight: noop,
        onOpenVaccination: noop,
        onOpenMedication: noop,
        onOpenAppointments: noop,
        onOpenMemories: noop,
        onOpenDocuments: noop,
        onOpenEmergencyCard: noop),
    'Add pet': (r) => AddFirstPetScreen(onPetCreated: (_) async {}),
    'Care': (r) => CareScreen(repository: r, onOpenAddCare: noop),
    'Add care': (r) => AddCareScreen(repository: r, onSaved: noop),
    'Health': (r) => HealthScreen(
        repository: r,
        onOpenAddHealthEvent: noop,
        onOpenWeight: noop,
        onOpenVaccination: noop,
        onOpenMedication: noop),
    'Add health': (r) => AddHealthEventScreen(repository: r, onSaved: noop),
    'Appointments': (r) => AppointmentsScreen(repository: r),
    'Add appointment': (r) => AddAppointmentScreen(repository: r),
    'Visit prep': (r) =>
        VetVisitPrepScreen(repository: r, appointment: r.allAppointments.first),
    'Medication': (r) => MedicationScreen(repository: r),
    'Vaccinations': (r) => VaccinationPassportScreen(repository: r),
    'Growth': (r) => WeightGrowthScreen(repository: r),
    'Memories': (r) => MemoriesScreen(repository: r),
    'Documents': (r) => DocumentsScreen(repository: r),
    'Emergency': (r) => EmergencyCardScreen(repository: r),
    'Lost pet': (r) => LostPetModeScreen(repository: r),
    'Adoption': (r) => AdoptionDiscoveryScreen(repository: r),
    'Calendar': (r) => PetCalendarScreen(repository: r),
    'Search': (r) => UniversalSearchScreen(repository: r),
    'Settings': (r) => ProfileSettingsScreen(repository: r, onLogout: noop),
    'Onboarding': (r) => const OnboardingScreen(onFinish: noop),
    'Splash': (r) => const SplashScreen(onFinish: noop),
    'Local profile': (r) => LoginScreen(
        repository: r,
        onLoginSuccess: noop,
        onNavigateToSignup: noop,
        onNavigateToForgotPassword: noop),
    'Create profile': (r) => SignupScreen(
        repository: r, onSignupSuccess: noop, onNavigateToLogin: noop),
    'Profile recovery': (r) => const ForgotPasswordScreen(onBackToLogin: noop),
    'Timeline': (r) => PetTimelineScreen(repository: r),
    'Reminders': (r) => RemindersScreen(repository: r),
  };
  for (final entry in screens.entries) {
    for (final dark in [false, true]) {
      testWidgets(
          '${entry.key} fits a 320px phone in ${dark ? "dark" : "light"} mode',
          (tester) async {
        SharedPreferences.setMockInitialValues({});
        final repo = PawlyRepository();
        await repo.init();
        await repo.seedDemoData();
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(MaterialApp(
            theme: dark ? PawlyTheme.darkTheme : PawlyTheme.lightTheme,
            home: entry.value(repo)));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        // Exercise scrolling so lower content is also laid out.
        final scrolling = find.byType(Scrollable);
        if (scrolling.evaluate().isNotEmpty) {
          await tester.drag(scrolling.first, const Offset(0, -400));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();
      });
    }
  }
}
