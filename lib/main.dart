import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'navigation/bottom_nav_bar.dart';
import 'repositories/pawly_repository.dart';
import 'screens/appointments/appointments_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/care/add_care_screen.dart';
import 'screens/care/care_screen.dart';
import 'screens/documents/documents_screen.dart';
import 'screens/emergency/emergency_card_screen.dart';
import 'screens/growth/weight_growth_screen.dart';
import 'screens/health/add_health_event_screen.dart';
import 'screens/health/health_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/medication/medication_screen.dart';
import 'screens/memories/memories_screen.dart';
import 'screens/pets/add_first_pet_screen.dart';
import 'screens/pets/my_pets_screen.dart';
import 'screens/pets/pet_space_screen.dart';
import 'screens/profile/profile_settings_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/vaccination/vaccination_passport_screen.dart';
import 'screens/calendar/pet_calendar_screen.dart';
import 'screens/search/universal_search_screen.dart';
import 'theme/pawly_colors.dart';
import 'theme/pawly_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set immersive mobile status bar styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: PawlyColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final repository = PawlyRepository();
  runApp(PawlyBootstrap(repository: repository));
}

/// Render immediately while local storage opens; retry leaves user data intact.
class PawlyBootstrap extends StatefulWidget {
  final PawlyRepository repository;
  const PawlyBootstrap({super.key, required this.repository});
  @override
  State<PawlyBootstrap> createState() => _PawlyBootstrapState();
}

class _PawlyBootstrapState extends State<PawlyBootstrap> {
  late Future<void> _initialization = widget.repository.init();
  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError) {
            return PawlyApp(repository: widget.repository);
          }
          return MaterialApp(
              theme: PawlyTheme.lightTheme,
              darkTheme: PawlyTheme.darkTheme,
              debugShowCheckedModeBanner: false,
              home: snapshot.hasError
                  ? Scaffold(
                      body: SafeArea(
                          child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.pets, size: 40),
                                        const SizedBox(height: 16),
                                        const Text(
                                            'We couldn’t open your pet records.',
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 8),
                                        const Text(
                                            'Try opening Pawly again. Your saved records will stay on this device.'),
                                        const SizedBox(height: 20),
                                        FilledButton(
                                            onPressed: () => setState(() {
                                                  _initialization =
                                                      widget.repository.init();
                                                }),
                                            child: const Text('Try again')),
                                      ])))))
                  : SplashScreen(onFinish: () {}));
        },
      );
}

enum AppFlowState { splash, login, signup, forgotPassword, addFirstPet, main }

class PawlyApp extends StatefulWidget {
  final PawlyRepository repository;

  const PawlyApp({super.key, required this.repository});

  @override
  State<PawlyApp> createState() => _PawlyAppState();
}

class _PawlyAppState extends State<PawlyApp> {
  AppFlowState _flowState = AppFlowState.splash;

  void _goTo(AppFlowState state) {
    setState(() => _flowState = state);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: widget.repository,
        builder: (context, _) => MaterialApp(
              title: 'Pawly',
              debugShowCheckedModeBanner: false,
              theme: PawlyTheme.forPalette(
                  widget.repository.palette, Brightness.light),
              darkTheme: PawlyTheme.forPalette(
                  widget.repository.palette, Brightness.dark),
              themeMode: widget.repository.themeMode,
              builder: (context, child) => Center(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: child!)),
              home: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  child: KeyedSubtree(
                      key: ValueKey(_flowState), child: _buildCurrentScreen())),
            ));
  }

  Widget _buildCurrentScreen() {
    switch (_flowState) {
      case AppFlowState.splash:
        return SplashScreen(
          onFinish: () => _goTo(widget.repository.pets.isEmpty
              ? AppFlowState.login
              : AppFlowState.main),
        );

      case AppFlowState.login:
        return LoginScreen(
          repository: widget.repository,
          onLoginSuccess: () {
            if (widget.repository.pets.isEmpty) {
              _goTo(AppFlowState.addFirstPet);
            } else {
              _goTo(AppFlowState.main);
            }
          },
          onExploreDemo: () async {
            await widget.repository.seedDemoData();
            if (mounted) _goTo(AppFlowState.main);
          },
          onNavigateToSignup: () => _goTo(AppFlowState.signup),
          onNavigateToForgotPassword: () => _goTo(AppFlowState.forgotPassword),
        );

      case AppFlowState.signup:
        return SignupScreen(
          repository: widget.repository,
          onSignupSuccess: () => _goTo(AppFlowState.addFirstPet),
          onNavigateToLogin: () => _goTo(AppFlowState.login),
        );

      case AppFlowState.forgotPassword:
        return ForgotPasswordScreen(
          onBackToLogin: () => _goTo(AppFlowState.login),
        );

      case AppFlowState.addFirstPet:
        return AddFirstPetScreen(
          onBack: () => _goTo(AppFlowState.login),
          onPetCreated: (newPet) async {
            await widget.repository.addPet(newPet);
            if (mounted) _goTo(AppFlowState.main);
          },
        );

      case AppFlowState.main:
        return PawlyMainScaffold(
          repository: widget.repository,
          onLogout: () => _goTo(AppFlowState.login),
        );
    }
  }
}

class PawlyMainScaffold extends StatefulWidget {
  final PawlyRepository repository;
  final VoidCallback onLogout;

  const PawlyMainScaffold({
    super.key,
    required this.repository,
    required this.onLogout,
  });

  @override
  State<PawlyMainScaffold> createState() => _PawlyMainScaffoldState();
}

class _PawlyMainScaffoldState extends State<PawlyMainScaffold> {
  PawlyNavDestination _currentDestination = PawlyNavDestination.home;

  void _push(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => ListenableBuilder(
              listenable: widget.repository, builder: (_, __) => screen)),
    );
  }

  void _openPetSpace(String petId) {
    widget.repository.selectPet(petId);
    _push(
      PetSpaceScreen(
        petId: petId,
        repository: widget.repository,
        onBack: () => Navigator.pop(context),
        onOpenAddCare: () => _push(AddCareScreen(
          repository: widget.repository,
          onSaved: () => Navigator.pop(context),
        )),
        onOpenAddHealth: () => _push(AddHealthEventScreen(
          repository: widget.repository,
          onSaved: () => Navigator.pop(context),
        )),
        onOpenWeight: () =>
            _push(WeightGrowthScreen(repository: widget.repository)),
        onOpenVaccination: () =>
            _push(VaccinationPassportScreen(repository: widget.repository)),
        onOpenMedication: () =>
            _push(MedicationScreen(repository: widget.repository)),
        onOpenAppointments: () =>
            _push(AppointmentsScreen(repository: widget.repository)),
        onOpenMemories: () =>
            _push(MemoriesScreen(repository: widget.repository)),
        onOpenDocuments: () =>
            _push(DocumentsScreen(repository: widget.repository)),
        onOpenEmergencyCard: () =>
            _push(EmergencyCardScreen(repository: widget.repository)),
      ),
    );
  }

  void _openAddPet() {
    _push(
      AddFirstPetScreen(
        onPetCreated: (pet) async {
          await widget.repository.addPet(pet);
          if (mounted) Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.repository,
      builder: (context, _) {
        return Scaffold(
          body: IndexedStack(
            index: _currentDestination.index,
            children: [
              // 0: HOME
              HomeScreen(
                repository: widget.repository,
                onOpenAddPet: _openAddPet,
                onOpenAddCare: () => _push(AddCareScreen(
                  repository: widget.repository,
                  onSaved: () => Navigator.pop(context),
                )),
                onOpenCareTab: () => setState(
                    () => _currentDestination = PawlyNavDestination.care),
                onOpenHealthTab: () => setState(
                    () => _currentDestination = PawlyNavDestination.health),
                onOpenPetSpace: _openPetSpace,
                onOpenAppointments: () =>
                    _push(AppointmentsScreen(repository: widget.repository)),
                onOpenWeight: () =>
                    _push(WeightGrowthScreen(repository: widget.repository)),
                onOpenSearch: () =>
                    _push(UniversalSearchScreen(repository: widget.repository)),
                onOpenCalendar: () =>
                    _push(PetCalendarScreen(repository: widget.repository)),
              ),

              // 1: PETS
              MyPetsScreen(
                repository: widget.repository,
                onOpenPetSpace: _openPetSpace,
                onOpenAddPet: _openAddPet,
              ),

              // 2: CARE
              CareScreen(
                repository: widget.repository,
                onOpenAddCare: () => _push(AddCareScreen(
                  repository: widget.repository,
                  onSaved: () => Navigator.pop(context),
                )),
              ),

              // 3: HEALTH
              HealthScreen(
                repository: widget.repository,
                onOpenAddHealthEvent: () => _push(AddHealthEventScreen(
                  repository: widget.repository,
                  onSaved: () => Navigator.pop(context),
                )),
                onOpenWeight: () =>
                    _push(WeightGrowthScreen(repository: widget.repository)),
                onOpenVaccination: () => _push(
                    VaccinationPassportScreen(repository: widget.repository)),
                onOpenMedication: () =>
                    _push(MedicationScreen(repository: widget.repository)),
              ),

              // 4: MORE / SETTINGS
              ProfileSettingsScreen(
                repository: widget.repository,
                onLogout: widget.onLogout,
              ),
            ],
          ),
          bottomNavigationBar: PawlyBottomNavBar(
            currentDestination: _currentDestination,
            onDestinationSelected: (dest) {
              setState(() => _currentDestination = dest);
            },
          ),
        );
      },
    );
  }
}
