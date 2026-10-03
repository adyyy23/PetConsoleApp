import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as p;

import '../models/models.dart';

/// Database abstraction for Pawly.
/// Uses native SQLite on mobile/desktop, with seamless persistence fallback
/// for Web and test environments.
class AppDatabase {
  static const String _dbName = 'pawly_local_v1.db';
  static const int _dbVersion = 1;

  sql.Database? _sqliteDb;
  SharedPreferences? _prefs;
  bool _useSqlite = false;

  bool get isSqlite => _useSqlite;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    // Check if SQLite can be opened in the current environment
    if (!kIsWeb) {
      try {
        final databasesPath = await sql.getDatabasesPath();
        final dbPath = p.join(databasesPath, _dbName);

        _sqliteDb = await sql.openDatabase(
          dbPath,
          version: _dbVersion,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
        );
        _useSqlite = true;
      } catch (e) {
        debugPrint(
            '[AppDatabase] SQLite unavailable, using persistent key-value store: $e');
        _useSqlite = false;
      }
    } else {
      _useSqlite = false;
    }
  }

  Future<void> _onCreate(sql.Database db, int version) async {
    // 1. Pets table
    await db.execute('''
      CREATE TABLE pets (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        animalType TEXT NOT NULL,
        breed TEXT NOT NULL,
        ageYears REAL NOT NULL,
        weightKg REAL NOT NULL,
        gender TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        notes TEXT,
        allergies TEXT,
        microchipNumber TEXT,
        birthday TEXT,
        category TEXT,
        nickname TEXT,
        favoriteFood TEXT,
        favoriteToy TEXT,
        favoriteActivity TEXT,
        temperament TEXT,
        likes TEXT,
        dislikes TEXT,
        funFact TEXT,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');

    // 2. Care Routines table
    await db.execute('''
      CREATE TABLE care_routines (
        id TEXT PRIMARY KEY,
        petId TEXT NOT NULL,
        title TEXT NOT NULL,
        time TEXT NOT NULL,
        date TEXT NOT NULL,
        category TEXT NOT NULL,
        priority TEXT NOT NULL,
        isCompleted INTEGER NOT NULL,
        notes TEXT,
        recurrence TEXT NOT NULL,
        assignedTo TEXT,
        completedAt TEXT
      )
    ''');

    // 3. Care Completions log
    await db.execute('''
      CREATE TABLE care_completions (
        id TEXT PRIMARY KEY,
        routineId TEXT NOT NULL,
        petId TEXT NOT NULL,
        date TEXT NOT NULL,
        completedAt TEXT NOT NULL
      )
    ''');

    // 4. Health Records table
    await db.execute('''
      CREATE TABLE health_records (
        id TEXT PRIMARY KEY,
        petId TEXT NOT NULL,
        date TEXT NOT NULL,
        title TEXT NOT NULL,
        type TEXT NOT NULL,
        notes TEXT,
        veterinarian TEXT,
        clinic TEXT
      )
    ''');

    // 5. Weight Entries table
    await db.execute('''
      CREATE TABLE weight_entries (
        id TEXT PRIMARY KEY,
        petId TEXT NOT NULL,
        date TEXT NOT NULL,
        weightKg REAL NOT NULL,
        note TEXT
      )
    ''');

    // 6. Vaccinations table
    await db.execute('''
      CREATE TABLE vaccinations (
        id TEXT PRIMARY KEY,
        petId TEXT NOT NULL,
        vaccineName TEXT NOT NULL,
        dateAdministered TEXT NOT NULL,
        nextDueDate TEXT NOT NULL,
        veterinarian TEXT,
        clinic TEXT,
        notes TEXT,
        status TEXT NOT NULL
      )
    ''');

    // 7. Medications table
    await db.execute('''
      CREATE TABLE medications (
        id TEXT PRIMARY KEY,
        petId TEXT NOT NULL,
        name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        frequency TEXT NOT NULL,
        instructions TEXT,
        startDate TEXT NOT NULL,
        endDate TEXT,
        isActive INTEGER NOT NULL
      )
    ''');

    // 8. Appointments table
    await db.execute('''
      CREATE TABLE appointments (
        id TEXT PRIMARY KEY,
        petId TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        purpose TEXT NOT NULL,
        clinic TEXT NOT NULL,
        vetName TEXT NOT NULL,
        notes TEXT,
        isCompleted INTEGER NOT NULL
      )
    ''');

    // 9. Memories table
    await db.execute('''
      CREATE TABLE memories (
        id TEXT PRIMARY KEY,
        petId TEXT NOT NULL,
        date TEXT NOT NULL,
        title TEXT NOT NULL,
        caption TEXT,
        imageUrl TEXT NOT NULL,
        milestoneType TEXT
      )
    ''');

    // 10. Daily Notes table (Owner wellness observations)
    await db.execute('''
      CREATE TABLE daily_notes (
        id TEXT PRIMARY KEY,
        petId TEXT NOT NULL,
        date TEXT NOT NULL,
        appetite TEXT NOT NULL,
        energy TEXT NOT NULL,
        stool TEXT,
        skin TEXT,
        notes TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(
      sql.Database db, int oldVersion, int newVersion) async {
    // Versioned migration logic placeholder for future schema bumps
  }

  // ───────────────────────────────────────────────────────────────────────────
  // PETS CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<List<Pet>> getAllPets() async {
    if (_useSqlite && _sqliteDb != null) {
      final rows = await _sqliteDb!.query('pets', orderBy: 'name ASC');
      return rows
          .map((r) => Pet(
                id: r['id'] as String,
                name: r['name'] as String,
                animalType: r['animalType'] as String? ?? 'Dog',
                breed: r['breed'] as String? ?? '',
                ageYears: (r['ageYears'] as num?)?.toDouble() ?? 1.0,
                weightKg: (r['weightKg'] as num?)?.toDouble() ?? 5.0,
                gender: r['gender'] as String? ?? 'Male',
                imageUrl: r['imageUrl'] as String? ?? '',
                notes: r['notes'] as String? ?? '',
                allergies: r['allergies'] as String? ?? 'None reported',
                microchipNumber: r['microchipNumber'] as String? ?? '',
                birthday: r['birthday'] as String? ?? '',
                category: r['category'] as String? ?? 'Companion',
                nickname: r['nickname'] as String? ?? '',
                favoriteFood: r['favoriteFood'] as String? ?? '',
                favoriteToy: r['favoriteToy'] as String? ?? '',
                favoriteActivity: r['favoriteActivity'] as String? ?? '',
                temperament: r['temperament'] as String? ?? 'Gentle & curious',
                likes: (r['likes'] as String?)?.isNotEmpty == true
                    ? (r['likes'] as String).split(';')
                    : const [],
                dislikes: (r['dislikes'] as String?)?.isNotEmpty == true
                    ? (r['dislikes'] as String).split(';')
                    : const [],
                funFact: r['funFact'] as String? ?? '',
              ))
          .toList();
    } else {
      final raw = _prefs?.getString('db_pets');
      if (raw == null) return [];
      try {
        final List list = jsonDecode(raw);
        return list.map((e) => Pet.fromJson(e)).toList();
      } catch (_) {
        return [];
      }
    }
  }

  Future<void> insertPet(Pet pet) async {
    if (_useSqlite && _sqliteDb != null) {
      await _sqliteDb!.insert(
        'pets',
        {
          'id': pet.id,
          'name': pet.name,
          'animalType': pet.animalType,
          'breed': pet.breed,
          'ageYears': pet.ageYears,
          'weightKg': pet.weightKg,
          'gender': pet.gender,
          'imageUrl': pet.imageUrl,
          'notes': pet.notes,
          'allergies': pet.allergies,
          'microchipNumber': pet.microchipNumber,
          'birthday': pet.birthday,
          'category': pet.category,
          'nickname': pet.nickname,
          'favoriteFood': pet.favoriteFood,
          'favoriteToy': pet.favoriteToy,
          'favoriteActivity': pet.favoriteActivity,
          'temperament': pet.temperament,
          'likes': pet.likes.join(';'),
          'dislikes': pet.dislikes.join(';'),
          'funFact': pet.funFact,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    } else {
      final pets = await getAllPets();
      pets.removeWhere((p) => p.id == pet.id);
      pets.add(pet);
      await _saveJsonList('db_pets', pets.map((p) => p.toJson()).toList());
    }
  }

  Future<void> updatePet(Pet pet) async {
    await insertPet(pet);
  }

  Future<void> deletePet(String petId) async {
    if (_useSqlite && _sqliteDb != null) {
      await _sqliteDb!.delete('pets', where: 'id = ?', whereArgs: [petId]);
      await _sqliteDb!
          .delete('care_routines', where: 'petId = ?', whereArgs: [petId]);
      await _sqliteDb!
          .delete('health_records', where: 'petId = ?', whereArgs: [petId]);
      await _sqliteDb!
          .delete('weight_entries', where: 'petId = ?', whereArgs: [petId]);
      await _sqliteDb!
          .delete('vaccinations', where: 'petId = ?', whereArgs: [petId]);
      await _sqliteDb!
          .delete('medications', where: 'petId = ?', whereArgs: [petId]);
      await _sqliteDb!
          .delete('appointments', where: 'petId = ?', whereArgs: [petId]);
      await _sqliteDb!
          .delete('memories', where: 'petId = ?', whereArgs: [petId]);
      await _sqliteDb!
          .delete('daily_notes', where: 'petId = ?', whereArgs: [petId]);
    } else {
      final pets = await getAllPets();
      pets.removeWhere((p) => p.id == petId);
      await _saveJsonList('db_pets', pets.map((p) => p.toJson()).toList());

      // Cascade delete child entities
      final routines = (await getAllRoutines())
        ..removeWhere((r) => r.petId == petId);
      await _saveJsonList(
          'db_care_routines', routines.map((r) => r.toJson()).toList());

      final health = (await getAllHealthRecords())
        ..removeWhere((h) => h.petId == petId);
      await _saveJsonList(
          'db_health_records', health.map((h) => h.toJson()).toList());

      final weights = (await getAllWeightEntries())
        ..removeWhere((w) => w.petId == petId);
      await _saveJsonList(
          'db_weight_entries', weights.map((w) => w.toJson()).toList());

      final appts = (await getAllAppointments())
        ..removeWhere((a) => a.petId == petId);
      await _saveJsonList(
          'db_appointments', appts.map((a) => a.toJson()).toList());

      final memories = (await getAllMemories())
        ..removeWhere((m) => m.petId == petId);
      await _saveJsonList(
          'db_memories', memories.map((m) => m.toJson()).toList());

      final meds = (await getAllMedications())
        ..removeWhere((m) => m.petId == petId);
      await _saveJsonList(
          'db_medications', meds.map((m) => m.toJson()).toList());

      final vaccs = (await getAllVaccinations())
        ..removeWhere((v) => v.petId == petId);
      await _saveJsonList(
          'db_vaccinations', vaccs.map((v) => v.toJson()).toList());

      final notes = (await getAllDailyNotes())
        ..removeWhere((n) => n.petId == petId);
      await _saveJsonList(
          'db_daily_notes', notes.map((n) => n.toJson()).toList());
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // CARE ROUTINES CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<List<CareRoutine>> getAllRoutines() async {
    if (_useSqlite && _sqliteDb != null) {
      final rows = await _sqliteDb!.query('care_routines', orderBy: 'time ASC');
      return rows
          .map((r) => CareRoutine(
                id: r['id'] as String,
                petId: r['petId'] as String,
                title: r['title'] as String,
                time: r['time'] as String,
                date: r['date'] as String,
                category: CareCategory.values.firstWhere(
                  (c) => c.name == r['category'],
                  orElse: () => CareCategory.other,
                ),
                priority: r['priority'] as String? ?? 'Medium',
                isCompleted: (r['isCompleted'] as int) == 1,
                notes: r['notes'] as String? ?? '',
                recurrence: r['recurrence'] as String? ?? 'Daily',
                assignedTo: r['assignedTo'] as String? ?? 'Me',
                completedAt: r['completedAt'] as String? ?? '',
              ))
          .toList();
    } else {
      final raw = _prefs?.getString('db_care_routines');
      if (raw == null) return [];
      try {
        final List list = jsonDecode(raw);
        return list.map((e) => CareRoutine.fromJson(e)).toList();
      } catch (_) {
        return [];
      }
    }
  }

  Future<void> insertRoutine(CareRoutine routine) async {
    if (_useSqlite && _sqliteDb != null) {
      await _sqliteDb!.insert(
        'care_routines',
        {
          'id': routine.id,
          'petId': routine.petId,
          'title': routine.title,
          'time': routine.time,
          'date': routine.date,
          'category': routine.category.name,
          'priority': routine.priority,
          'isCompleted': routine.isCompleted ? 1 : 0,
          'notes': routine.notes,
          'recurrence': routine.recurrence,
          'assignedTo': routine.assignedTo,
          'completedAt': routine.completedAt,
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    } else {
      final list = await getAllRoutines();
      list.removeWhere((r) => r.id == routine.id);
      list.add(routine);
      await _saveJsonList(
          'db_care_routines', list.map((r) => r.toJson()).toList());
    }
  }

  Future<void> deleteRoutine(String routineId) async {
    if (_useSqlite && _sqliteDb != null) {
      await _sqliteDb!
          .delete('care_routines', where: 'id = ?', whereArgs: [routineId]);
    } else {
      final list = await getAllRoutines();
      list.removeWhere((r) => r.id == routineId);
      await _saveJsonList(
          'db_care_routines', list.map((r) => r.toJson()).toList());
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // HEALTH RECORDS CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<List<HealthEvent>> getAllHealthRecords() async {
    if (_useSqlite && _sqliteDb != null) {
      final rows =
          await _sqliteDb!.query('health_records', orderBy: 'date DESC');
      return rows
          .map((r) => HealthEvent(
                id: r['id'] as String,
                petId: r['petId'] as String,
                date: r['date'] as String,
                title: r['title'] as String,
                type: r['type'] as String,
                notes: r['notes'] as String? ?? '',
                veterinarian: r['veterinarian'] as String? ?? '',
                clinic: r['clinic'] as String? ?? '',
              ))
          .toList();
    } else {
      final raw = _prefs?.getString('db_health_records');
      if (raw == null) return [];
      try {
        final List list = jsonDecode(raw);
        return list.map((e) => HealthEvent.fromJson(e)).toList();
      } catch (_) {
        return [];
      }
    }
  }

  Future<void> insertHealthRecord(HealthEvent event) async {
    if (_useSqlite && _sqliteDb != null) {
      await _sqliteDb!.insert(
        'health_records',
        {
          'id': event.id,
          'petId': event.petId,
          'date': event.date,
          'title': event.title,
          'type': event.type,
          'notes': event.notes,
          'veterinarian': event.veterinarian,
          'clinic': event.clinic,
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    } else {
      final list = await getAllHealthRecords();
      list.removeWhere((h) => h.id == event.id);
      list.insert(0, event);
      await _saveJsonList(
          'db_health_records', list.map((h) => h.toJson()).toList());
    }
  }

  Future<void> deleteHealthRecord(String eventId) async {
    if (_useSqlite && _sqliteDb != null) {
      await _sqliteDb!
          .delete('health_records', where: 'id = ?', whereArgs: [eventId]);
    } else {
      final list = await getAllHealthRecords();
      list.removeWhere((h) => h.id == eventId);
      await _saveJsonList(
          'db_health_records', list.map((h) => h.toJson()).toList());
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // WEIGHT ENTRIES CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<List<WeightEntry>> getAllWeightEntries() async {
    if (_useSqlite && _sqliteDb != null) {
      final rows =
          await _sqliteDb!.query('weight_entries', orderBy: 'date DESC');
      return rows
          .map((r) => WeightEntry(
                id: r['id'] as String,
                petId: r['petId'] as String,
                date: r['date'] as String,
                weightKg: (r['weightKg'] as num).toDouble(),
                note: r['note'] as String? ?? '',
              ))
          .toList();
    } else {
      final raw = _prefs?.getString('db_weight_entries');
      if (raw == null) return [];
      try {
        final List list = jsonDecode(raw);
        return list.map((e) => WeightEntry.fromJson(e)).toList();
      } catch (_) {
        return [];
      }
    }
  }

  Future<void> insertWeightEntry(WeightEntry entry) async {
    if (_useSqlite && _sqliteDb != null) {
      await _sqliteDb!.insert(
        'weight_entries',
        {
          'id': entry.id,
          'petId': entry.petId,
          'date': entry.date,
          'weightKg': entry.weightKg,
          'note': entry.note,
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    } else {
      final list = await getAllWeightEntries();
      list.removeWhere((w) => w.id == entry.id);
      list.insert(0, entry);
      await _saveJsonList(
          'db_weight_entries', list.map((w) => w.toJson()).toList());
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // VACCINATIONS CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<List<VaccinationRecord>> getAllVaccinations() async {
    if (_useSqlite && _sqliteDb != null) {
      final rows = await _sqliteDb!
          .query('vaccinations', orderBy: 'dateAdministered DESC');
      return rows
          .map((r) => VaccinationRecord(
                id: r['id'] as String,
                petId: r['petId'] as String,
                vaccineName: r['vaccineName'] as String,
                dateAdministered: r['dateAdministered'] as String,
                nextDueDate: r['nextDueDate'] as String,
                veterinarian: r['veterinarian'] as String? ?? '',
                clinic: r['clinic'] as String? ?? '',
                notes: r['notes'] as String? ?? '',
                status: VaccineStatus.values.firstWhere(
                  (s) => s.name == r['status'],
                  orElse: () => VaccineStatus.current,
                ),
              ))
          .toList();
    } else {
      final raw = _prefs?.getString('db_vaccinations');
      if (raw == null) return [];
      try {
        final List list = jsonDecode(raw);
        return list.map((e) => VaccinationRecord.fromJson(e)).toList();
      } catch (_) {
        return [];
      }
    }
  }

  Future<void> insertVaccination(VaccinationRecord vac) async {
    if (_useSqlite && _sqliteDb != null) {
      await _sqliteDb!.insert(
        'vaccinations',
        {
          'id': vac.id,
          'petId': vac.petId,
          'vaccineName': vac.vaccineName,
          'dateAdministered': vac.dateAdministered,
          'nextDueDate': vac.nextDueDate,
          'veterinarian': vac.veterinarian,
          'clinic': vac.clinic,
          'notes': vac.notes,
          'status': vac.status.name,
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    } else {
      final list = await getAllVaccinations();
      list.removeWhere((v) => v.id == vac.id);
      list.insert(0, vac);
      await _saveJsonList(
          'db_vaccinations', list.map((v) => v.toJson()).toList());
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // MEDICATIONS CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<List<Medication>> getAllMedications() async {
    if (_useSqlite && _sqliteDb != null) {
      final rows = await _sqliteDb!.query('medications', orderBy: 'name ASC');
      return rows
          .map((r) => Medication(
                id: r['id'] as String,
                petId: r['petId'] as String,
                name: r['name'] as String,
                dosage: r['dosage'] as String,
                frequency: r['frequency'] as String,
                instructions: r['instructions'] as String? ?? '',
                startDate: r['startDate'] as String,
                endDate: r['endDate'] as String? ?? 'Ongoing',
                isActive: (r['isActive'] as int) == 1,
              ))
          .toList();
    } else {
      final raw = _prefs?.getString('db_medications');
      if (raw == null) return [];
      try {
        final List list = jsonDecode(raw);
        return list.map((e) => Medication.fromJson(e)).toList();
      } catch (_) {
        return [];
      }
    }
  }

  Future<void> insertMedication(Medication med) async {
    if (_useSqlite && _sqliteDb != null) {
      await _sqliteDb!.insert(
        'medications',
        {
          'id': med.id,
          'petId': med.petId,
          'name': med.name,
          'dosage': med.dosage,
          'frequency': med.frequency,
          'instructions': med.instructions,
          'startDate': med.startDate,
          'endDate': med.endDate,
          'isActive': med.isActive ? 1 : 0,
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    } else {
      final list = await getAllMedications();
      list.removeWhere((m) => m.id == med.id);
      list.insert(0, med);
      await _saveJsonList(
          'db_medications', list.map((m) => m.toJson()).toList());
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // APPOINTMENTS CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<List<Appointment>> getAllAppointments() async {
    if (_useSqlite && _sqliteDb != null) {
      final rows = await _sqliteDb!.query('appointments', orderBy: 'date ASC');
      return rows
          .map((r) => Appointment(
                id: r['id'] as String,
                petId: r['petId'] as String,
                date: r['date'] as String,
                time: r['time'] as String,
                purpose: r['purpose'] as String,
                clinic: r['clinic'] as String,
                vetName: r['vetName'] as String,
                notes: r['notes'] as String? ?? '',
                isCompleted: (r['isCompleted'] as int) == 1,
              ))
          .toList();
    } else {
      final raw = _prefs?.getString('db_appointments');
      if (raw == null) return [];
      try {
        final List list = jsonDecode(raw);
        return list.map((e) => Appointment.fromJson(e)).toList();
      } catch (_) {
        return [];
      }
    }
  }

  Future<void> insertAppointment(Appointment appt) async {
    if (_useSqlite && _sqliteDb != null) {
      await _sqliteDb!.insert(
        'appointments',
        {
          'id': appt.id,
          'petId': appt.petId,
          'date': appt.date,
          'time': appt.time,
          'purpose': appt.purpose,
          'clinic': appt.clinic,
          'vetName': appt.vetName,
          'notes': appt.notes,
          'isCompleted': appt.isCompleted ? 1 : 0,
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    } else {
      final list = await getAllAppointments();
      list.removeWhere((a) => a.id == appt.id);
      list.add(appt);
      await _saveJsonList(
          'db_appointments', list.map((a) => a.toJson()).toList());
    }
  }

  Future<void> deleteAppointment(String apptId) async {
    if (_useSqlite && _sqliteDb != null) {
      await _sqliteDb!
          .delete('appointments', where: 'id = ?', whereArgs: [apptId]);
    } else {
      final list = await getAllAppointments();
      list.removeWhere((a) => a.id == apptId);
      await _saveJsonList(
          'db_appointments', list.map((a) => a.toJson()).toList());
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // MEMORIES CRUD
  // ───────────────────────────────────────────────────────────────────────────

  Future<List<MemoryEntry>> getAllMemories() async {
    if (_useSqlite && _sqliteDb != null) {
      final rows = await _sqliteDb!.query('memories', orderBy: 'date DESC');
      return rows
          .map((r) => MemoryEntry(
                id: r['id'] as String,
                petId: r['petId'] as String,
                date: r['date'] as String,
                title: r['title'] as String,
                caption: r['caption'] as String? ?? '',
                imageUrl: r['imageUrl'] as String,
                milestoneType: r['milestoneType'] as String? ?? 'Milestone',
              ))
          .toList();
    } else {
      final raw = _prefs?.getString('db_memories');
      if (raw == null) return [];
      try {
        final List list = jsonDecode(raw);
        return list.map((e) => MemoryEntry.fromJson(e)).toList();
      } catch (_) {
        return [];
      }
    }
  }

  Future<void> insertMemory(MemoryEntry memory) async {
    if (_useSqlite && _sqliteDb != null) {
      await _sqliteDb!.insert(
        'memories',
        {
          'id': memory.id,
          'petId': memory.petId,
          'date': memory.date,
          'title': memory.title,
          'caption': memory.caption,
          'imageUrl': memory.imageUrl,
          'milestoneType': memory.milestoneType,
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    } else {
      final list = await getAllMemories();
      list.removeWhere((m) => m.id == memory.id);
      list.insert(0, memory);
      await _saveJsonList('db_memories', list.map((m) => m.toJson()).toList());
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // DAILY NOTES CRUD (Owner Wellness Observations)
  // ───────────────────────────────────────────────────────────────────────────

  Future<List<SymptomNote>> getAllDailyNotes() async {
    if (_useSqlite && _sqliteDb != null) {
      final rows = await _sqliteDb!.query('daily_notes', orderBy: 'date DESC');
      return rows
          .map((r) => SymptomNote(
                id: r['id'] as String,
                petId: r['petId'] as String,
                date: r['date'] as String,
                appetite: r['appetite'] as String? ?? 'Good',
                energy: r['energy'] as String? ?? 'Normal',
                stool: r['stool'] as String? ?? 'Normal',
                skin: r['skin'] as String? ?? 'Clear',
                notes: r['notes'] as String? ?? '',
              ))
          .toList();
    } else {
      final raw = _prefs?.getString('db_daily_notes');
      if (raw == null) return [];
      try {
        final List list = jsonDecode(raw);
        return list.map((e) => SymptomNote.fromJson(e)).toList();
      } catch (_) {
        return [];
      }
    }
  }

  Future<void> insertDailyNote(SymptomNote note) async {
    if (_useSqlite && _sqliteDb != null) {
      await _sqliteDb!.insert(
        'daily_notes',
        {
          'id': note.id,
          'petId': note.petId,
          'date': note.date,
          'appetite': note.appetite,
          'energy': note.energy,
          'stool': note.stool,
          'skin': note.skin,
          'notes': note.notes,
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    } else {
      final list = await getAllDailyNotes();
      list.removeWhere((n) => n.id == note.id);
      list.insert(0, note);
      await _saveJsonList(
          'db_daily_notes', list.map((n) => n.toJson()).toList());
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // CLEAR ALL (For demo reset or account deletion)
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> clearAll() async {
    if (_useSqlite && _sqliteDb != null) {
      await _sqliteDb!.delete('pets');
      await _sqliteDb!.delete('care_routines');
      await _sqliteDb!.delete('care_completions');
      await _sqliteDb!.delete('health_records');
      await _sqliteDb!.delete('weight_entries');
      await _sqliteDb!.delete('vaccinations');
      await _sqliteDb!.delete('medications');
      await _sqliteDb!.delete('appointments');
      await _sqliteDb!.delete('memories');
      await _sqliteDb!.delete('daily_notes');
    }
    await _prefs?.remove('db_pets');
    await _prefs?.remove('db_care_routines');
    await _prefs?.remove('db_health_records');
    await _prefs?.remove('db_weight_entries');
    await _prefs?.remove('db_vaccinations');
    await _prefs?.remove('db_medications');
    await _prefs?.remove('db_appointments');
    await _prefs?.remove('db_memories');
    await _prefs?.remove('db_daily_notes');
    await _prefs?.remove('pawly_selected_pet_id');
    await _prefs?.remove('pawly_is_demo');
  }

  Future<void> _saveJsonList(String key, List list) async {
    await _prefs?.setString(key, jsonEncode(list));
  }
}
