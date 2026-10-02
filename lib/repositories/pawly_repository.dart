import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'sample_data.dart';

class PawlyRepository extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  UserProfile _user = SampleData.defaultUser;
  List<Pet> _pets = [];
  String _selectedPetId = 'pet_mochi';

  List<CareRoutine> _routines = [];
  List<Appointment> _appointments = [];
  List<HealthEvent> _healthEvents = [];
  List<WeightEntry> _weightHistory = [];
  List<VaccinationRecord> _vaccinations = [];
  List<Medication> _medications = [];
  List<MemoryEntry> _memories = [];
  List<DocumentItem> _documents = [];
  List<VetPrepItem> _vetPrepItems = [];
  List<PetMilestone> _milestones = [];
  List<SymptomNote> _symptomNotes = [];
  List<CareCircleMember> _careCircle = [];
  WellnessSnapshot _wellnessSnapshot = SampleData.defaultWellness;
  EmergencyCardData _emergencyCard = SampleData.defaultEmergency;

  bool _isLostPetModeEnabled = false;

  // Getters
  bool get isInitialized => _isInitialized;
  UserProfile get user => _user;
  List<Pet> get pets => List.unmodifiable(_pets);
  String get selectedPetId => _selectedPetId;

  Pet get activePet {
    return _pets.firstWhere(
      (p) => p.id == _selectedPetId,
      orElse: () => _pets.isNotEmpty ? _pets.first : SampleData.initialPets.first,
    );
  }

  List<CareRoutine> get allRoutines => List.unmodifiable(_routines);
  List<CareRoutine> get activePetRoutines =>
      _routines.where((r) => r.petId == _selectedPetId).toList();

  List<Appointment> get allAppointments => List.unmodifiable(_appointments);
  List<Appointment> get activePetAppointments =>
      _appointments.where((a) => a.petId == _selectedPetId).toList();

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

  Pet? get selectedPet => activePet;
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

  // Initialization
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadFromStorage();
    _isInitialized = true;
    notifyListeners();
  }

  void _loadFromStorage() {
    // Pets
    final petsJson = _prefs.getString('pawly_pets');
    if (petsJson != null) {
      try {
        final List list = jsonDecode(petsJson);
        _pets = list.map((e) => Pet.fromJson(e)).toList();
      } catch (_) {
        _pets = List.from(SampleData.initialPets);
      }
    } else {
      _pets = List.from(SampleData.initialPets);
    }

    // Selected Pet ID
    _selectedPetId = _prefs.getString('pawly_selected_pet_id') ??
        (_pets.isNotEmpty ? _pets.first.id : 'pet_mochi');

    // Routines
    final routinesJson = _prefs.getString('pawly_routines');
    if (routinesJson != null) {
      try {
        final List list = jsonDecode(routinesJson);
        _routines = list.map((e) => CareRoutine.fromJson(e)).toList();
      } catch (_) {
        _routines = List.from(SampleData.initialRoutines);
      }
    } else {
      _routines = List.from(SampleData.initialRoutines);
    }

    // Appointments
    final apptsJson = _prefs.getString('pawly_appointments');
    if (apptsJson != null) {
      try {
        final List list = jsonDecode(apptsJson);
        _appointments = list.map((e) => Appointment.fromJson(e)).toList();
      } catch (_) {
        _appointments = List.from(SampleData.initialAppointments);
      }
    } else {
      _appointments = List.from(SampleData.initialAppointments);
    }

    // Other entities initialized with rich defaults
    _healthEvents = List.from(SampleData.initialHealthEvents);
    _weightHistory = List.from(SampleData.initialWeightHistory);
    _vaccinations = List.from(SampleData.initialVaccinations);
    _medications = List.from(SampleData.initialMedications);
    _memories = List.from(SampleData.initialMemories);
    _documents = List.from(SampleData.initialDocuments);
    _vetPrepItems = List.from(SampleData.initialVetPrep);
    _milestones = List.from(SampleData.initialMilestones);
    _symptomNotes = List.from(SampleData.initialSymptomNotes);
    _careCircle = List.from(SampleData.initialCareCircle);
    _wellnessSnapshot = SampleData.defaultWellness;
    _emergencyCard = SampleData.defaultEmergency;
    _isLostPetModeEnabled = _prefs.getBool('pawly_lost_pet_mode') ?? false;
  }

  // --- ACTIONS ---

  void selectPet(String petId) {
    _selectedPetId = petId;
    _prefs.setString('pawly_selected_pet_id', petId);
    notifyListeners();
  }

  void addPet(Pet pet) {
    _pets.insert(0, pet);
    _selectedPetId = pet.id;
    _savePets();
    notifyListeners();
  }

  void updatePet(Pet pet) {
    final idx = _pets.indexWhere((p) => p.id == pet.id);
    if (idx != -1) {
      _pets[idx] = pet;
      _savePets();
      notifyListeners();
    }
  }

  void deletePet(String petId) {
    _pets.removeWhere((p) => p.id == petId);
    _routines.removeWhere((r) => r.petId == petId);
    _appointments.removeWhere((a) => a.petId == petId);
    if (_selectedPetId == petId && _pets.isNotEmpty) {
      _selectedPetId = _pets.first.id;
    }
    _savePets();
    _saveRoutines();
    notifyListeners();
  }

  // Care Routine Actions
  void toggleRoutine(String id) {
    final idx = _routines.indexWhere((r) => r.id == id);
    if (idx != -1) {
      final item = _routines[idx];
      _routines[idx] = item.copyWith(isCompleted: !item.isCompleted);
      _saveRoutines();
      notifyListeners();
    }
  }

  void addRoutine(CareRoutine routine) {
    _routines.insert(0, routine);
    _saveRoutines();
    notifyListeners();
  }

  void deleteRoutine(String id) {
    _routines.removeWhere((r) => r.id == id);
    _saveRoutines();
    notifyListeners();
  }

  // Appointments
  void addAppointment(Appointment appt) {
    _appointments.insert(0, appt);
    _saveAppointments();
    notifyListeners();
  }

  void toggleAppointmentCompleted(String id) {
    final idx = _appointments.indexWhere((a) => a.id == id);
    if (idx != -1) {
      final appt = _appointments[idx];
      _appointments[idx] = appt.copyWith(isCompleted: !appt.isCompleted);
      _saveAppointments();
      notifyListeners();
    }
  }

  // Health
  void addHealthEvent(HealthEvent event) {
    _healthEvents.insert(0, event);
    notifyListeners();
  }

  // Weight & Growth
  void addWeightEntry(WeightEntry entry) {
    _weightHistory.insert(0, entry);
    // Also update pet's current weight
    final idx = _pets.indexWhere((p) => p.id == entry.petId);
    if (idx != -1) {
      _pets[idx] = _pets[idx].copyWith(weightKg: entry.weightKg);
      _savePets();
    }
    notifyListeners();
  }

  // Vaccination
  void addVaccination(VaccinationRecord record) {
    _vaccinations.insert(0, record);
    notifyListeners();
  }

  // Medication
  void addMedication(Medication med) {
    _medications.insert(0, med);
    notifyListeners();
  }

  // Memories
  void addMemory(MemoryEntry memory) {
    _memories.insert(0, memory);
    notifyListeners();
  }

  // Documents
  void addDocument(DocumentItem doc) {
    _documents.insert(0, doc);
    notifyListeners();
  }

  // Vet Prep Item Toggle
  void toggleVetPrepItem(String id) {
    final idx = _vetPrepItems.indexWhere((item) => item.id == id);
    if (idx != -1) {
      _vetPrepItems[idx] = _vetPrepItems[idx].copyWith(
        isChecked: !_vetPrepItems[idx].isChecked,
      );
      notifyListeners();
    }
  }

  void addVetPrepItem(VetPrepItem item) {
    _vetPrepItems.add(item);
    notifyListeners();
  }

  // Emergency Card
  void updateEmergencyCard(EmergencyCardData card) {
    _emergencyCard = card;
    notifyListeners();
  }

  void toggleLostPetMode() {
    _isLostPetModeEnabled = !_isLostPetModeEnabled;
    _prefs.setBool('pawly_lost_pet_mode', _isLostPetModeEnabled);
    notifyListeners();
  }

  // Milestones
  void addMilestone(PetMilestone milestone) {
    _milestones.insert(0, milestone);
    notifyListeners();
  }

  // Symptom / Observation notes
  void addSymptomNote(SymptomNote note) {
    _symptomNotes.insert(0, note);
    notifyListeners();
  }

  // Care Circle
  void addCareCircleMember(CareCircleMember member) {
    _careCircle.add(member);
    notifyListeners();
  }

  void removeCareCircleMember(String id) {
    _careCircle.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  // Wellness Snapshot
  void updateWellnessSnapshot(WellnessSnapshot snapshot) {
    _wellnessSnapshot = snapshot;
    notifyListeners();
  }

  // Universal Search
  List<SearchResultItem> search(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase().trim();
    final List<SearchResultItem> results = [];

    // Search Pets
    for (final pet in _pets) {
      if (pet.name.toLowerCase().contains(q) ||
          pet.breed.toLowerCase().contains(q) ||
          pet.species.toLowerCase().contains(q) ||
          pet.nickname.toLowerCase().contains(q) ||
          pet.temperament.toLowerCase().contains(q)) {
        results.add(SearchResultItem(
          title: pet.name,
          subtitle: '${pet.breed} • ${pet.ageYears} yrs',
          category: 'Pet',
          petName: pet.name,
          originalObject: pet,
        ));
      }
    }

    // Search Care Routines
    for (final routine in _routines) {
      if (routine.title.toLowerCase().contains(q) ||
          routine.notes.toLowerCase().contains(q) ||
          routine.category.name.toLowerCase().contains(q)) {
        final pet = _pets.firstWhere((p) => p.id == routine.petId, orElse: () => activePet);
        results.add(SearchResultItem(
          title: routine.title,
          subtitle: '${routine.time} • ${routine.recurrence} • ${routine.notes}',
          category: 'Care',
          date: routine.date,
          petName: pet.name,
          originalObject: routine,
        ));
      }
    }

    // Search Appointments
    for (final appt in _appointments) {
      if (appt.purpose.toLowerCase().contains(q) ||
          appt.clinic.toLowerCase().contains(q) ||
          appt.vetName.toLowerCase().contains(q) ||
          appt.notes.toLowerCase().contains(q)) {
        final pet = _pets.firstWhere((p) => p.id == appt.petId, orElse: () => activePet);
        results.add(SearchResultItem(
          title: appt.purpose,
          subtitle: '${appt.clinic} • ${appt.vetName}',
          category: 'Appointment',
          date: appt.date,
          petName: pet.name,
          originalObject: appt,
        ));
      }
    }

    // Search Medications
    for (final med in _medications) {
      if (med.name.toLowerCase().contains(q) ||
          med.dosage.toLowerCase().contains(q) ||
          med.frequency.toLowerCase().contains(q) ||
          med.instructions.toLowerCase().contains(q)) {
        final pet = _pets.firstWhere((p) => p.id == med.petId, orElse: () => activePet);
        results.add(SearchResultItem(
          title: med.name,
          subtitle: '${med.dosage} • ${med.frequency}',
          category: 'Medication',
          date: med.startDate,
          petName: pet.name,
          originalObject: med,
        ));
      }
    }

    // Search Health Events
    for (final ev in _healthEvents) {
      if (ev.title.toLowerCase().contains(q) ||
          ev.type.toLowerCase().contains(q) ||
          ev.notes.toLowerCase().contains(q) ||
          ev.clinic.toLowerCase().contains(q)) {
        final pet = _pets.firstWhere((p) => p.id == ev.petId, orElse: () => activePet);
        results.add(SearchResultItem(
          title: ev.title,
          subtitle: '${ev.type} • ${ev.clinic}',
          category: 'Health',
          date: ev.date,
          petName: pet.name,
          originalObject: ev,
        ));
      }
    }

    // Search Memories
    for (final mem in _memories) {
      if (mem.title.toLowerCase().contains(q) ||
          mem.caption.toLowerCase().contains(q) ||
          mem.milestoneType.toLowerCase().contains(q)) {
        final pet = _pets.firstWhere((p) => p.id == mem.petId, orElse: () => activePet);
        results.add(SearchResultItem(
          title: mem.title,
          subtitle: mem.caption,
          category: 'Memory',
          date: mem.date,
          petName: pet.name,
          originalObject: mem,
        ));
      }
    }

    // Search Documents
    for (final doc in _documents) {
      if (doc.title.toLowerCase().contains(q) ||
          doc.category.toLowerCase().contains(q)) {
        final pet = _pets.firstWhere((p) => p.id == doc.petId, orElse: () => activePet);
        results.add(SearchResultItem(
          title: doc.title,
          subtitle: '${doc.category} • ${doc.fileType}',
          category: 'Document',
          date: doc.dateAdded,
          petName: pet.name,
          originalObject: doc,
        ));
      }
    }

    return results;
  }

  // Profile
  void updateUserProfile(UserProfile profile) {
    _user = profile;
    notifyListeners();
  }

  // Storage helpers
  void _savePets() {
    _prefs.setString(
      'pawly_pets',
      jsonEncode(_pets.map((p) => p.toJson()).toList()),
    );
  }

  void _saveRoutines() {
    _prefs.setString(
      'pawly_routines',
      jsonEncode(_routines.map((r) => r.toJson()).toList()),
    );
  }

  void _saveAppointments() {
    _prefs.setString(
      'pawly_appointments',
      jsonEncode(_appointments.map((a) => a.toJson()).toList()),
    );
  }
}
