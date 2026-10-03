import '../theme/pawly_palette.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/care_schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import '../models/models.dart';
import 'demo_data_seeder.dart';
import 'sample_data.dart';

class PawlyRepository extends ChangeNotifier {
  final AppDatabase _database = AppDatabase();
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  UserProfile _user = const UserProfile(
      id: 'local', name: 'Pet parent', email: 'On this device');
  ThemeMode _themeMode = ThemeMode.system;
  PawlyPalette _palette = PawlyPalette.monochrome;
  PawlyPalette get palette => _palette;

  Future<void> setPalette(PawlyPalette palette) async {
    await _prefs.setString('pawly_palette', palette.name);
    _palette = palette;
    notifyListeners();
  }

  bool _onboardingComplete = false;
  final Map<String, Map<String, String>> _completions = {};
  final Map<String, EmergencyCardData> _emergencyCards = {};
  ThemeMode get themeMode => _themeMode;
  bool get onboardingComplete => _onboardingComplete;

  Future<void> completeOnboarding() async {
    await _prefs.setBool('pawly_onboarded', true);
    _onboardingComplete = true;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString('pawly_theme', mode.name);
    _themeMode = mode;
    notifyListeners();
  }

  Future<void> updateUser(String name) async {
    final updated =
        UserProfile(id: _user.id, name: name.trim(), email: _user.email);
    await _prefs.setString('pawly_user', jsonEncode(updated.toJson()));
    _user = updated;
    notifyListeners();
  }

  List<Pet> _pets = [];
  String _selectedPetId = '';

  List<CareRoutine> _routines = [];
  List<Appointment> _appointments = [];
  List<HealthEvent> _healthEvents = [];
  List<WeightEntry> _weightHistory = [];
  List<VaccinationRecord> _vaccinations = [];
  List<Medication> _medications = [];
  List<MemoryEntry> _memories = [];
  final List<DocumentItem> _documents = [];
  final List<VetPrepItem> _vetPrepItems = [];
  final List<PetMilestone> _milestones = [];
  List<SymptomNote> _symptomNotes = [];
  final List<CareCircleMember> _careCircle = [];
  final WellnessSnapshot _wellnessSnapshot = SampleData.defaultWellness;
  final EmergencyCardData _emergencyCard = SampleData.defaultEmergency;

  bool _isLostPetModeEnabled = false;
  bool _isDemoMode = false;

  // Getters
  bool get isInitialized => _isInitialized;
  UserProfile get user => _user;
  List<Pet> get pets => List.unmodifiable(_pets);
  String get selectedPetId => _selectedPetId;
  bool get isDemoMode => _isDemoMode;

  /// Returns the currently active pet, or null if no pets exist.
  Pet? get selectedPet {
    if (_pets.isEmpty) return null;
    final found = _pets.where((p) => p.id == _selectedPetId).toList();
    return found.isNotEmpty ? found.first : _pets.first;
  }

  /// Backward-compatible getter: returns selectedPet or a fallback empty placeholder
  Pet get activePet {
    final pet = selectedPet;
    if (pet != null) return pet;
    return const Pet(
      id: 'placeholder',
      name: 'No Pet Added',
      animalType: 'Pet',
      breed: 'Companion',
      ageYears: 0,
      weightKg: 0,
      gender: '',
      imageUrl: '',
    );
  }

  List<CareRoutine> get allRoutines => List.unmodifiable(_routines);
  List<CareRoutine> get activePetRoutines =>
      routinesForDate(DateTime.now(), petId: _selectedPetId);

  List<Appointment> get allAppointments => List.unmodifiable(_appointments);
  List<Appointment> get activePetAppointments =>
      _appointments.where((a) => a.petId == _selectedPetId).toList();

  List<HealthEvent> get allHealthEvents => List.unmodifiable(_healthEvents);
  List<HealthEvent> get activePetHealthEvents =>
      _healthEvents.where((h) => h.petId == _selectedPetId).toList();

  List<WeightEntry> get activePetWeightHistory => activeWeights(_selectedPetId);

  List<WeightEntry> activeWeights(String petId) {
    final entries = _weightHistory.where((w) => w.petId == petId).toList();
    entries.sort((a, b) => (CareSchedule.parseDate(b.date) ?? DateTime(1900))
        .compareTo(CareSchedule.parseDate(a.date) ?? DateTime(1900)));
    return entries;
  }

  List<VaccinationRecord> get activePetVaccinations =>
      _vaccinations.where((v) => v.petId == _selectedPetId).toList();

  List<VaccinationRecord> vaccinationsForPet(String petId) =>
      _vaccinations.where((v) => v.petId == petId).toList();

  List<Medication> get activePetMedications =>
      _medications.where((m) => m.petId == _selectedPetId).toList();

  List<MemoryEntry> get activePetMemories =>
      _memories.where((m) => m.petId == _selectedPetId).toList();

  List<DocumentItem> get activePetDocuments =>
      _documents.where((d) => d.petId == _selectedPetId).toList();

  List<PetMilestone> get activePetMilestones =>
      _milestones.where((m) => m.petId == _selectedPetId).toList();

  List<SymptomNote> get activePetSymptomNotes =>
      _symptomNotes.where((s) => s.petId == _selectedPetId).toList();

  List<CareCircleMember> get careCircle => List.unmodifiable(_careCircle);

  WellnessSnapshot get activePetWellness => _wellnessSnapshot;

  List<VetPrepItem> get activeVetPrepItems => _vetPrepItems;

  List<Appointment> appointmentsForPet(String petId) =>
      _appointments.where((a) => a.petId == petId).toList();
  List<MemoryEntry> memoriesForPet(String petId) =>
      _memories.where((m) => m.petId == petId).toList();
  List<DocumentItem> documentsForPet(String petId) =>
      _documents.where((d) => d.petId == petId).toList();
  List<VetPrepItem> prepItemsForAppointment(String apptId) =>
      _vetPrepItems.where((i) => i.appointmentId == apptId).toList();
  List<AdoptionPet> get adoptionPets => SampleData.adoptionPets;

  EmergencyCardData get emergencyCard =>
      _emergencyCards[_selectedPetId] ??
      (_isDemoMode && _emergencyCard.petId == _selectedPetId
          ? _emergencyCard
          : EmergencyCardData(
              petId: _selectedPetId,
              emergencyContactName: '',
              emergencyPhone: '',
              preferredVetName: '',
              preferredVetPhone: '',
              preferredClinic: ''));
  bool get isLostPetModeEnabled => _isLostPetModeEnabled;

  // ───────────────────────────────────────────────────────────────────────────
  // INITIALIZATION
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _database.init();
    await _loadFromDatabase();
    await _refreshDemoIdentity();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _loadFromDatabase() async {
    _pets = await _database.getAllPets();
    _routines = await _database.getAllRoutines();
    _healthEvents = await _database.getAllHealthRecords();
    _weightHistory = await _database.getAllWeightEntries();
    _vaccinations = await _database.getAllVaccinations();
    _medications = await _database.getAllMedications();
    _appointments = await _database.getAllAppointments();
    _memories = await _database.getAllMemories();
    _symptomNotes = await _database.getAllDailyNotes();

    _palette = PawlyPalette.values.firstWhere(
        (palette) => palette.name == _prefs.getString('pawly_palette'),
        orElse: () => PawlyPalette.monochrome);
    _onboardingComplete = _prefs.getBool('pawly_onboarded') ?? false;
    _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.name == _prefs.getString('pawly_theme'),
        orElse: () => ThemeMode.system);
    final userJson = _prefs.getString('pawly_user');
    if (userJson != null) _user = UserProfile.fromJson(jsonDecode(userJson));
    _documents.clear();
    _vetPrepItems.clear();
    _careCircle.clear();
    _emergencyCards.clear();
    _completions.clear();
    _documents.addAll(_readExtras('documents', DocumentItem.fromJson));
    _vetPrepItems.addAll(_readExtras('prep', VetPrepItem.fromJson));
    _careCircle.addAll(_readExtras('circle', CareCircleMember.fromJson));
    for (final card in _readExtras('emergency', EmergencyCardData.fromJson)) {
      _emergencyCards[card.petId] = card;
    }
    final savedCompletions = _prefs.getString('pawly_completions');
    if (savedCompletions != null) {
      final decoded = jsonDecode(savedCompletions) as Map<String, dynamic>;
      for (final entry in decoded.entries) {
        _completions[entry.key] = Map<String, String>.from(entry.value);
      }
    }
    // Migrate legacy completion flags into dated history once.
    for (final routine in _routines.where((r) => r.isCompleted)) {
      _completions
          .putIfAbsent(routine.id, () => {})
          .putIfAbsent(routine.date, () => routine.completedAt);
    }
    _isDemoMode = _prefs.getBool('pawly_is_demo') ?? false;
    _isLostPetModeEnabled = _prefs.getBool('pawly_lost_pet_mode') ?? false;

    final savedPetId = _prefs.getString('pawly_selected_pet_id');
    if (savedPetId != null && _pets.any((p) => p.id == savedPetId)) {
      _selectedPetId = savedPetId;
    } else {
      _selectedPetId = _pets.isNotEmpty ? _pets.first.id : '';
    }
  }

  /// Refresh only untouched sample identities; keep stable record IDs and user edits.
  Future<void> _refreshDemoIdentity() async {
    if (!_isDemoMode || _prefs.getInt('pawly_demo_portraits') == 2) return;
    const oldNames = {
      'pet_mochi': 'Mochi',
      'pet_luna': 'Luna',
      'pet_milo': 'Milo'
    };
    for (final sample in SampleData.initialPets) {
      final index = _pets.indexWhere((pet) => pet.id == sample.id);
      if (index < 0) continue;
      final previous = _pets[index];
      if (previous.name != oldNames[sample.id] ||
          !previous.imageUrl.contains('images.unsplash.com')) continue;
      final refreshed = previous.copyWith(
          name: sample.name,
          imageUrl: sample.imageUrl,
          nickname: sample.nickname);
      await _database.updatePet(refreshed);
      _pets[index] = refreshed;
    }
    for (final sample in SampleData.initialMemories) {
      final index = _memories.indexWhere((memory) =>
          memory.id == sample.id &&
          memory.imageUrl.contains('images.unsplash.com'));
      if (index >= 0) {
        await _database.insertMemory(sample);
        _memories[index] = sample;
      }
    }
    await _prefs.setInt('pawly_demo_portraits', 2);
  }

  Future<void> setDemoMode(bool isDemo) async {
    _isDemoMode = isDemo;
    await _prefs.setBool('pawly_is_demo', isDemo);
    notifyListeners();
  }

  Future<void> seedDemoData() async {
    if (_pets.isNotEmpty) return;
    await DemoDataSeeder.seed(this);
    selectPet(SampleData.initialPets.first.id);
    await _prefs.setInt('pawly_demo_portraits', 2);
  }

  Future<void> clearAllData() async {
    await _database.clearAll();
    _pets.clear();
    _routines.clear();
    _appointments.clear();
    _healthEvents.clear();
    _weightHistory.clear();
    _vaccinations.clear();
    _medications.clear();
    _memories.clear();
    _documents.clear();
    _vetPrepItems.clear();
    _careCircle.clear();
    _emergencyCards.clear();
    _completions.clear();
    for (final key in ['documents', 'prep', 'circle', 'emergency']) {
      await _prefs.remove('pawly_extra_$key');
    }
    await _prefs.remove('pawly_completions');
    _isLostPetModeEnabled = false;
    await _prefs.remove('pawly_lost_pet_mode');
    _symptomNotes.clear();
    _selectedPetId = '';
    _isDemoMode = false;
    await _prefs.remove('pawly_is_demo');
    await _prefs.remove('pawly_selected_pet_id');
    notifyListeners();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // PETS CRUD
  // ───────────────────────────────────────────────────────────────────────────

  void selectPet(String petId) {
    if (_selectedPetId == petId || !_pets.any((p) => p.id == petId)) return;
    _selectedPetId = petId;
    _prefs.setString('pawly_selected_pet_id', petId);
    notifyListeners();
  }

  Future<void> addPet(Pet pet) async {
    await _database.insertPet(pet);
    _pets.insert(0, pet);
    _selectedPetId = pet.id;
    await _prefs.setString('pawly_selected_pet_id', pet.id);
    notifyListeners();
  }

  Future<void> updatePet(Pet pet) async {
    final idx = _pets.indexWhere((p) => p.id == pet.id);
    if (idx != -1) {
      await _database.updatePet(pet);
      _pets[idx] = pet;
      notifyListeners();
    }
  }

  Future<void> deletePet(String petId) async {
    final routineIds =
        _routines.where((r) => r.petId == petId).map((r) => r.id).toSet();
    final appointmentIds =
        _appointments.where((a) => a.petId == petId).map((a) => a.id).toSet();
    await _database.deletePet(petId);
    _completions.removeWhere((key, value) => routineIds.contains(key));
    _vetPrepItems
        .removeWhere((item) => appointmentIds.contains(item.appointmentId));
    await _saveExtras('prep', _vetPrepItems.map((item) => item.toJson()));
    await _prefs.setString('pawly_completions', jsonEncode(_completions));
    _pets.removeWhere((p) => p.id == petId);
    _routines.removeWhere((r) => r.petId == petId);
    _appointments.removeWhere((a) => a.petId == petId);
    _healthEvents.removeWhere((h) => h.petId == petId);
    _weightHistory.removeWhere((w) => w.petId == petId);
    _vaccinations.removeWhere((v) => v.petId == petId);
    _medications.removeWhere((m) => m.petId == petId);
    _memories.removeWhere((m) => m.petId == petId);
    _symptomNotes.removeWhere((s) => s.petId == petId);
    _documents.removeWhere((d) => d.petId == petId);
    _emergencyCards.remove(petId);
    await _saveExtras('documents', _documents.map((d) => d.toJson()));
    await _saveExtras(
        'emergency', _emergencyCards.values.map((d) => d.toJson()));

    if (_selectedPetId == petId) {
      _selectedPetId = _pets.isNotEmpty ? _pets.first.id : '';
      await _prefs.setString('pawly_selected_pet_id', _selectedPetId);
    }

    notifyListeners();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // CARE ROUTINES CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> addCareRoutine(CareRoutine routine) async {
    await _database.insertRoutine(routine);
    _routines.add(routine);
    notifyListeners();
  }

  Future<void> addRoutine(CareRoutine routine) => addCareRoutine(routine);

  Future<void> updateCareRoutine(CareRoutine routine) async {
    final idx = _routines.indexWhere((r) => r.id == routine.id);
    if (idx != -1) {
      _routines[idx] = routine;
      await _database.insertRoutine(routine);
      notifyListeners();
    }
  }

  Future<void> deleteRoutine(String routineId) async {
    await _database.deleteRoutine(routineId);
    _routines.removeWhere((r) => r.id == routineId);
    _completions.remove(routineId);
    await _prefs.setString('pawly_completions', jsonEncode(_completions));
    notifyListeners();
  }

  List<CareRoutine> routinesForDate(DateTime date, {String? petId}) {
    final key = CareSchedule.dayKey(date);
    final result = _routines
        .where((r) =>
            (petId == null || r.petId == petId) && CareSchedule.isDue(r, date))
        .map((r) {
      final completed = _completions[r.id]?[key];
      return r.copyWith(
          isCompleted: completed != null, completedAt: completed ?? '');
    }).toList();
    result.sort((a, b) =>
        CareSchedule.minutes(a.time).compareTo(CareSchedule.minutes(b.time)));
    return result;
  }

  Future<void> toggleRoutine(String routineId, {DateTime? date}) async {
    final day = date ?? DateTime.now();
    final key = CareSchedule.dayKey(day);
    final routine = _routines.where((r) => r.id == routineId).firstOrNull;
    if (routine == null ||
        !CareSchedule.isDue(routine, day) ||
        CareSchedule.day(day).isAfter(CareSchedule.day(DateTime.now()))) return;
    final history = Map<String, String>.from(_completions[routineId] ?? {});
    if (history.containsKey(key)) {
      history.remove(key);
    } else {
      history[key] = _formatTimeNow();
    }
    final updated = {..._completions, routineId: history};
    await _prefs.setString('pawly_completions', jsonEncode(updated));
    _completions[routineId] = history;
    // Completion belongs to a day; the routine template stays reusable.
    final index = _routines.indexOf(routine);
    _routines[index] = routine.copyWith(isCompleted: false, completedAt: '');
    await _database.insertRoutine(_routines[index]);
    notifyListeners();
  }

  List<T> _readExtras<T>(String key, T Function(Map<String, dynamic>) decode) {
    final raw = _prefs.getString('pawly_extra_$key');
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => decode(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> _saveExtras(String key, Iterable<Map<String, dynamic>> items) =>
      _prefs.setString('pawly_extra_$key', jsonEncode(items.toList()));

  Future<void> addCaregiver(CareCircleMember member) async {
    await _saveExtras(
        'circle', [..._careCircle.map((m) => m.toJson()), member.toJson()]);
    _careCircle.add(member);
    notifyListeners();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // HEALTH RECORDS CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> addHealthEvent(HealthEvent event) async {
    await _database.insertHealthRecord(event);
    _healthEvents.insert(0, event);
    notifyListeners();
  }

  Future<void> addHealthRecord(HealthEvent event) => addHealthEvent(event);

  Future<void> deleteHealthEvent(String eventId) async {
    _healthEvents.removeWhere((h) => h.id == eventId);
    await _database.deleteHealthRecord(eventId);
    notifyListeners();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // WEIGHT ENTRIES CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> addWeightRecord(WeightEntry entry) async {
    await _database.insertWeightEntry(entry);
    _weightHistory.insert(0, entry);

    // Also update pet's current weight
    final petIdx = _pets.indexWhere((p) => p.id == entry.petId);
    if (petIdx != -1) {
      final latest = activeWeights(entry.petId).first;
      final updatedPet = _pets[petIdx].copyWith(weightKg: latest.weightKg);
      _pets[petIdx] = updatedPet;
      await _database.updatePet(updatedPet);
    }

    notifyListeners();
  }

  Future<void> addWeightEntry(WeightEntry entry) => addWeightRecord(entry);

  // ───────────────────────────────────────────────────────────────────────────
  // VACCINATIONS CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> addVaccination(VaccinationRecord vac) async {
    await _database.insertVaccination(vac);
    _vaccinations.insert(0, vac);
    notifyListeners();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // MEDICATIONS CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> addMedication(Medication med) async {
    await _database.insertMedication(med);
    _medications.insert(0, med);
    notifyListeners();
  }

  Future<void> updateMedication(Medication med) async {
    final idx = _medications.indexWhere((m) => m.id == med.id);
    if (idx != -1) {
      _medications[idx] = med;
      await _database.insertMedication(med);
      notifyListeners();
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // APPOINTMENTS CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> addAppointment(Appointment appt) async {
    await _database.insertAppointment(appt);
    _appointments.add(appt);
    notifyListeners();
  }

  Future<void> updateAppointment(Appointment appt) async {
    final idx = _appointments.indexWhere((a) => a.id == appt.id);
    if (idx != -1) {
      _appointments[idx] = appt;
      await _database.insertAppointment(appt);
      notifyListeners();
    }
  }

  Future<void> deleteAppointment(String apptId) async {
    await _database.deleteAppointment(apptId);
    _appointments.removeWhere((a) => a.id == apptId);
    _vetPrepItems.removeWhere((item) => item.appointmentId == apptId);
    await _saveExtras('prep', _vetPrepItems.map((item) => item.toJson()));
    notifyListeners();
  }

  Future<void> toggleAppointmentCompleted(String apptId) async {
    final idx = _appointments.indexWhere((a) => a.id == apptId);
    if (idx != -1) {
      final updated = _appointments[idx].copyWith(
        isCompleted: !_appointments[idx].isCompleted,
      );
      _appointments[idx] = updated;
      await _database.insertAppointment(updated);
      notifyListeners();
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // MEMORIES CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> addMemory(MemoryEntry memory) async {
    await _database.insertMemory(memory);
    _memories.insert(0, memory);
    notifyListeners();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // DAILY NOTES CRUD (Owner Wellness Observations)
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> addSymptomNote(SymptomNote note) async {
    await _database.insertDailyNote(note);
    _symptomNotes.insert(0, note);
    notifyListeners();
  }

  Future<void> addDailyNote(SymptomNote note) => addSymptomNote(note);

  // ───────────────────────────────────────────────────────────────────────────
  // EMERGENCY & LOST PET
  // ───────────────────────────────────────────────────────────────────────────

  void toggleLostPetMode(bool enabled) {
    _isLostPetModeEnabled = enabled;
    _prefs.setBool('pawly_lost_pet_mode', enabled);
    notifyListeners();
  }

  Future<void> updateEmergencyCard(EmergencyCardData data) async {
    final updated = {..._emergencyCards, data.petId: data};
    await _saveExtras('emergency', updated.values.map((d) => d.toJson()));
    _emergencyCards[data.petId] = data;
    notifyListeners();
  }

  Future<void> addDocument(DocumentItem doc) async {
    await _saveExtras(
        'documents', [doc.toJson(), ..._documents.map((d) => d.toJson())]);
    _documents.insert(0, doc);
    notifyListeners();
  }

  Future<void> toggleVetPrepItem(String itemId) async {
    final idx = _vetPrepItems.indexWhere((i) => i.id == itemId);
    if (idx != -1) {
      final item = _vetPrepItems[idx];
      final updated = [..._vetPrepItems];
      updated[idx] = item.copyWith(isChecked: !item.isChecked);
      await _saveExtras('prep', updated.map((d) => d.toJson()));
      _vetPrepItems[idx] = updated[idx];
      notifyListeners();
    }
  }

  Future<void> addVetPrepItem(VetPrepItem item) async {
    await _saveExtras(
        'prep', [..._vetPrepItems.map((d) => d.toJson()), item.toJson()]);
    _vetPrepItems.add(item);
    notifyListeners();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // UNIVERSAL SEARCH
  // ───────────────────────────────────────────────────────────────────────────

  List<SearchResultItem> search(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.trim().toLowerCase();
    final results = <SearchResultItem>[];

    // 1. Pets
    for (final pet in _pets) {
      if (pet.name.toLowerCase().contains(q) ||
          pet.breed.toLowerCase().contains(q) ||
          pet.animalType.toLowerCase().contains(q)) {
        results.add(SearchResultItem(
          title: pet.name,
          subtitle: '${pet.animalType} • ${pet.breed} • ${pet.weightKg} kg',
          category: 'Pet',
          petName: pet.name,
          originalObject: pet,
        ));
      }
    }

    // 2. Care Routines
    for (final routine in _routines) {
      if (routine.title.toLowerCase().contains(q) ||
          routine.notes.toLowerCase().contains(q) ||
          routine.category.name.toLowerCase().contains(q)) {
        final pet = _pets.firstWhere((p) => p.id == routine.petId,
            orElse: () => activePet);
        results.add(SearchResultItem(
          title: routine.title,
          subtitle:
              '${routine.time} • ${routine.category.displayName} • ${routine.recurrence}',
          category: 'Care',
          petName: pet.name,
          originalObject: routine,
        ));
      }
    }

    // 3. Health Records
    for (final event in _healthEvents) {
      if (event.title.toLowerCase().contains(q) ||
          event.notes.toLowerCase().contains(q) ||
          event.type.toLowerCase().contains(q) ||
          event.clinic.toLowerCase().contains(q) ||
          event.veterinarian.toLowerCase().contains(q)) {
        final pet = _pets.firstWhere((p) => p.id == event.petId,
            orElse: () => activePet);
        results.add(SearchResultItem(
          title: event.title,
          subtitle: '${event.date} • ${event.type} • ${event.clinic}',
          category: 'Health',
          petName: pet.name,
          originalObject: event,
        ));
      }
    }

    // 4. Medications
    for (final med in _medications) {
      if (med.name.toLowerCase().contains(q) ||
          med.dosage.toLowerCase().contains(q) ||
          med.frequency.toLowerCase().contains(q) ||
          med.instructions.toLowerCase().contains(q)) {
        final pet =
            _pets.firstWhere((p) => p.id == med.petId, orElse: () => activePet);
        results.add(SearchResultItem(
          title: med.name,
          subtitle:
              '${med.dosage} • ${med.frequency} • ${med.isActive ? 'Active' : 'Paused'}',
          category: 'Medication',
          petName: pet.name,
          originalObject: med,
        ));
      }
    }

    // 5. Vaccinations
    for (final vac in _vaccinations) {
      if (vac.vaccineName.toLowerCase().contains(q) ||
          vac.clinic.toLowerCase().contains(q) ||
          vac.veterinarian.toLowerCase().contains(q)) {
        final pet =
            _pets.firstWhere((p) => p.id == vac.petId, orElse: () => activePet);
        results.add(SearchResultItem(
          title: vac.vaccineName,
          subtitle: 'Given: ${vac.dateAdministered} • Due: ${vac.nextDueDate}',
          category: 'Vaccination',
          petName: pet.name,
          originalObject: vac,
        ));
      }
    }

    // 6. Appointments
    for (final appt in _appointments) {
      if (appt.purpose.toLowerCase().contains(q) ||
          appt.clinic.toLowerCase().contains(q) ||
          appt.vetName.toLowerCase().contains(q) ||
          appt.notes.toLowerCase().contains(q)) {
        final pet = _pets.firstWhere((p) => p.id == appt.petId,
            orElse: () => activePet);
        results.add(SearchResultItem(
          title: appt.purpose,
          subtitle: '${appt.date} at ${appt.time} • ${appt.clinic}',
          category: 'Appointment',
          petName: pet.name,
          originalObject: appt,
        ));
      }
    }

    // 7. Memories
    for (final memory in _memories) {
      if (memory.title.toLowerCase().contains(q) ||
          memory.caption.toLowerCase().contains(q)) {
        final pet = _pets.firstWhere((p) => p.id == memory.petId,
            orElse: () => activePet);
        results.add(SearchResultItem(
          title: memory.title,
          subtitle: '${memory.date} • ${memory.caption}',
          category: 'Memory',
          petName: pet.name,
          originalObject: memory,
        ));
      }
    }

    // 8. Daily Notes
    for (final note in _symptomNotes) {
      if (note.notes.toLowerCase().contains(q) ||
          note.appetite.toLowerCase().contains(q) ||
          note.energy.toLowerCase().contains(q)) {
        final pet = _pets.firstWhere((p) => p.id == note.petId,
            orElse: () => activePet);
        results.add(SearchResultItem(
          title: 'Daily Note • ${note.date}',
          subtitle: 'Appetite: ${note.appetite} • Energy: ${note.energy}',
          category: 'Daily Note',
          petName: pet.name,
          originalObject: note,
        ));
      }
    }

    return results;
  }

  String _formatTimeNow() {
    final now = DateTime.now();
    final hour =
        now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final min = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$min $ampm';
  }
}
