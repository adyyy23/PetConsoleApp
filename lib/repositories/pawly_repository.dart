import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import '../models/models.dart';
import 'demo_data_seeder.dart';
import 'sample_data.dart';

class PawlyRepository extends ChangeNotifier {
  final AppDatabase _database = AppDatabase();
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  final UserProfile _user = SampleData.defaultUser;
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
  EmergencyCardData _emergencyCard = SampleData.defaultEmergency;

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
      _routines.where((r) => r.petId == _selectedPetId).toList();

  List<Appointment> get allAppointments => List.unmodifiable(_appointments);
  List<Appointment> get activePetAppointments =>
      _appointments.where((a) => a.petId == _selectedPetId).toList();

  List<HealthEvent> get allHealthEvents => List.unmodifiable(_healthEvents);
  List<HealthEvent> get activePetHealthEvents =>
      _healthEvents.where((h) => h.petId == _selectedPetId).toList();

  List<WeightEntry> get activePetWeightHistory =>
      _weightHistory.where((w) => w.petId == _selectedPetId).toList();

  List<VaccinationRecord> get activePetVaccinations =>
      _vaccinations.where((v) => v.petId == _selectedPetId).toList();

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

  EmergencyCardData get emergencyCard => _emergencyCard;
  bool get isLostPetModeEnabled => _isLostPetModeEnabled;

  // ───────────────────────────────────────────────────────────────────────────
  // INITIALIZATION
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _database.init();
    await _loadFromDatabase();
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

    _isDemoMode = _prefs.getBool('pawly_is_demo') ?? false;
    _isLostPetModeEnabled = _prefs.getBool('pawly_lost_pet_mode') ?? false;

    final savedPetId = _prefs.getString('pawly_selected_pet_id');
    if (savedPetId != null && _pets.any((p) => p.id == savedPetId)) {
      _selectedPetId = savedPetId;
    } else {
      _selectedPetId = _pets.isNotEmpty ? _pets.first.id : '';
    }
  }

  Future<void> setDemoMode(bool isDemo) async {
    _isDemoMode = isDemo;
    await _prefs.setBool('pawly_is_demo', isDemo);
    notifyListeners();
  }

  Future<void> seedDemoData() async {
    await clearAllData();
    await DemoDataSeeder.seed(this);
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
    if (_selectedPetId == petId) return;
    _selectedPetId = petId;
    _prefs.setString('pawly_selected_pet_id', petId);
    notifyListeners();
  }

  Future<void> addPet(Pet pet) async {
    _pets.insert(0, pet);
    _selectedPetId = pet.id;
    await _prefs.setString('pawly_selected_pet_id', pet.id);
    await _database.insertPet(pet);
    notifyListeners();
  }

  Future<void> updatePet(Pet pet) async {
    final idx = _pets.indexWhere((p) => p.id == pet.id);
    if (idx != -1) {
      _pets[idx] = pet;
      await _database.updatePet(pet);
      notifyListeners();
    }
  }

  Future<void> deletePet(String petId) async {
    _pets.removeWhere((p) => p.id == petId);
    _routines.removeWhere((r) => r.petId == petId);
    _appointments.removeWhere((a) => a.petId == petId);
    _healthEvents.removeWhere((h) => h.petId == petId);
    _weightHistory.removeWhere((w) => w.petId == petId);
    _vaccinations.removeWhere((v) => v.petId == petId);
    _medications.removeWhere((m) => m.petId == petId);
    _memories.removeWhere((m) => m.petId == petId);
    _symptomNotes.removeWhere((s) => s.petId == petId);

    if (_selectedPetId == petId) {
      _selectedPetId = _pets.isNotEmpty ? _pets.first.id : '';
      await _prefs.setString('pawly_selected_pet_id', _selectedPetId);
    }

    await _database.deletePet(petId);
    notifyListeners();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // CARE ROUTINES CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> addCareRoutine(CareRoutine routine) async {
    _routines.add(routine);
    await _database.insertRoutine(routine);
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
    _routines.removeWhere((r) => r.id == routineId);
    await _database.deleteRoutine(routineId);
    notifyListeners();
  }

  Future<void> toggleRoutine(String routineId) async {
    final idx = _routines.indexWhere((r) => r.id == routineId);
    if (idx != -1) {
      final current = _routines[idx];
      final newStatus = !current.isCompleted;
      final updated = current.copyWith(
        isCompleted: newStatus,
        completedAt: newStatus ? _formatTimeNow() : '',
      );
      _routines[idx] = updated;
      await _database.insertRoutine(updated);
      notifyListeners();
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // HEALTH RECORDS CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> addHealthEvent(HealthEvent event) async {
    _healthEvents.insert(0, event);
    await _database.insertHealthRecord(event);
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
    _weightHistory.insert(0, entry);
    await _database.insertWeightEntry(entry);

    // Also update pet's current weight
    final petIdx = _pets.indexWhere((p) => p.id == entry.petId);
    if (petIdx != -1) {
      final updatedPet = _pets[petIdx].copyWith(weightKg: entry.weightKg);
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
    _vaccinations.insert(0, vac);
    await _database.insertVaccination(vac);
    notifyListeners();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // MEDICATIONS CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> addMedication(Medication med) async {
    _medications.insert(0, med);
    await _database.insertMedication(med);
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
    _appointments.add(appt);
    await _database.insertAppointment(appt);
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
    _appointments.removeWhere((a) => a.id == apptId);
    await _database.deleteAppointment(apptId);
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
    _memories.insert(0, memory);
    await _database.insertMemory(memory);
    notifyListeners();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // DAILY NOTES CRUD (Owner Wellness Observations)
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> addSymptomNote(SymptomNote note) async {
    _symptomNotes.insert(0, note);
    await _database.insertDailyNote(note);
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

  void updateEmergencyCard(EmergencyCardData data) {
    _emergencyCard = data;
    notifyListeners();
  }

  void addDocument(DocumentItem doc) {
    _documents.insert(0, doc);
    notifyListeners();
  }

  void toggleVetPrepItem(String itemId) {
    final idx = _vetPrepItems.indexWhere((i) => i.id == itemId);
    if (idx != -1) {
      final item = _vetPrepItems[idx];
      _vetPrepItems[idx] = item.copyWith(isChecked: !item.isChecked);
      notifyListeners();
    }
  }

  void addVetPrepItem(VetPrepItem item) {
    _vetPrepItems.add(item);
    notifyListeners();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // UNIVERSAL SEARCH
  // ───────────────────────────────────────────────────────────────────────────

  List<SearchResultItem> search(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase();
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
        final pet = _pets.firstWhere((p) => p.id == routine.petId, orElse: () => activePet);
        results.add(SearchResultItem(
          title: routine.title,
          subtitle: '${routine.time} • ${routine.category.displayName} • ${routine.recurrence}',
          category: 'Care Routine',
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
        final pet = _pets.firstWhere((p) => p.id == event.petId, orElse: () => activePet);
        results.add(SearchResultItem(
          title: event.title,
          subtitle: '${event.date} • ${event.type} • ${event.clinic}',
          category: 'Health Record',
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
        final pet = _pets.firstWhere((p) => p.id == med.petId, orElse: () => activePet);
        results.add(SearchResultItem(
          title: med.name,
          subtitle: '${med.dosage} • ${med.frequency} • ${med.isActive ? 'Active' : 'Paused'}',
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
        final pet = _pets.firstWhere((p) => p.id == vac.petId, orElse: () => activePet);
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
        final pet = _pets.firstWhere((p) => p.id == appt.petId, orElse: () => activePet);
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
        final pet = _pets.firstWhere((p) => p.id == memory.petId, orElse: () => activePet);
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
        final pet = _pets.firstWhere((p) => p.id == note.petId, orElse: () => activePet);
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
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final min = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$min $ampm';
  }
}
