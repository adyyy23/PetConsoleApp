class HealthEvent {
  final String id;
  final String petId;
  final String date;
  final String title;
  final String type; // Vet Visit, Vaccination, Checkup, Medication, Surgery, Note
  final String notes;
  final String veterinarian;
  final String clinic;

  const HealthEvent({
    required this.id,
    required this.petId,
    required this.date,
    required this.title,
    String? type,
    String? eventType,
    required this.notes,
    this.veterinarian = 'Attending Vet',
    this.clinic = '',
  }) : type = type ?? eventType ?? 'Checkup';

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'date': date,
    'title': title,
    'type': type,
    'notes': notes,
    'veterinarian': veterinarian,
    'clinic': clinic,
  };

  factory HealthEvent.fromJson(Map<String, dynamic> json) => HealthEvent(
    id: json['id'] as String,
    petId: json['petId'] as String,
    date: json['date'] as String,
    title: json['title'] as String,
    type: json['type'] as String? ?? 'Checkup',
    notes: json['notes'] as String? ?? '',
    veterinarian: json['veterinarian'] as String? ?? 'Attending Vet',
    clinic: json['clinic'] as String? ?? '',
  );
}

class WeightEntry {
  final String id;
  final String petId;
  final String date;
  final double weightKg;
  final String note;

  const WeightEntry({
    required this.id,
    required this.petId,
    required this.date,
    required this.weightKg,
    String? note,
    String? notes,
  }) : note = note ?? notes ?? '';

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'date': date,
    'weightKg': weightKg,
    'note': note,
  };

  factory WeightEntry.fromJson(Map<String, dynamic> json) => WeightEntry(
    id: json['id'] as String,
    petId: json['petId'] as String,
    date: json['date'] as String,
    weightKg: (json['weightKg'] as num).toDouble(),
    note: json['note'] as String? ?? '',
  );
}

enum VaccineStatus { current, dueSoon, overdue }

class VaccinationRecord {
  final String id;
  final String petId;
  final String vaccineName;
  final String dateAdministered;
  final String nextDueDate;
  final String veterinarian;
  final String clinic;
  final String notes;
  final VaccineStatus status;

  const VaccinationRecord({
    required this.id,
    required this.petId,
    required this.vaccineName,
    required this.dateAdministered,
    required this.nextDueDate,
    required this.veterinarian,
    required this.clinic,
    this.notes = '',
    this.status = VaccineStatus.current,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'vaccineName': vaccineName,
    'dateAdministered': dateAdministered,
    'nextDueDate': nextDueDate,
    'veterinarian': veterinarian,
    'clinic': clinic,
    'notes': notes,
    'status': status.name,
  };

  factory VaccinationRecord.fromJson(Map<String, dynamic> json) => VaccinationRecord(
    id: json['id'] as String,
    petId: json['petId'] as String,
    vaccineName: json['vaccineName'] as String,
    dateAdministered: json['dateAdministered'] as String,
    nextDueDate: json['nextDueDate'] as String,
    veterinarian: json['veterinarian'] as String? ?? '',
    clinic: json['clinic'] as String? ?? '',
    notes: json['notes'] as String? ?? '',
    status: VaccineStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => VaccineStatus.current,
    ),
  );
}

class Medication {
  final String id;
  final String petId;
  final String name;
  final String dosage;
  final String frequency;
  final String instructions;
  final String startDate;
  final String endDate;
  final bool isActive;

  const Medication({
    required this.id,
    required this.petId,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.instructions,
    required this.startDate,
    this.endDate = 'Ongoing',
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'name': name,
    'dosage': dosage,
    'frequency': frequency,
    'instructions': instructions,
    'startDate': startDate,
    'endDate': endDate,
    'isActive': isActive,
  };

  factory Medication.fromJson(Map<String, dynamic> json) => Medication(
    id: json['id'] as String,
    petId: json['petId'] as String,
    name: json['name'] as String,
    dosage: json['dosage'] as String,
    frequency: json['frequency'] as String,
    instructions: json['instructions'] as String? ?? '',
    startDate: json['startDate'] as String,
    endDate: json['endDate'] as String? ?? 'Ongoing',
    isActive: json['isActive'] as bool? ?? true,
  );
}

class Appointment {
  final String id;
  final String petId;
  final String date;
  final String time;
  final String purpose;
  final String clinic;
  final String vetName;
  final String notes;
  final bool isCompleted;

  const Appointment({
    required this.id,
    required this.petId,
    required this.date,
    required this.time,
    required this.purpose,
    required this.clinic,
    required this.vetName,
    this.notes = '',
    this.isCompleted = false,
  });

  Appointment copyWith({
    String? id,
    String? petId,
    String? date,
    String? time,
    String? purpose,
    String? clinic,
    String? vetName,
    String? notes,
    bool? isCompleted,
  }) {
    return Appointment(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      date: date ?? this.date,
      time: time ?? this.time,
      purpose: purpose ?? this.purpose,
      clinic: clinic ?? this.clinic,
      vetName: vetName ?? this.vetName,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'date': date,
    'time': time,
    'purpose': purpose,
    'clinic': clinic,
    'vetName': vetName,
    'notes': notes,
    'isCompleted': isCompleted,
  };

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json['id'] as String,
    petId: json['petId'] as String,
    date: json['date'] as String,
    time: json['time'] as String,
    purpose: json['purpose'] as String,
    clinic: json['clinic'] as String,
    vetName: json['vetName'] as String,
    notes: json['notes'] as String? ?? '',
    isCompleted: json['isCompleted'] as bool? ?? false,
  );
}

class MemoryEntry {
  final String id;
  final String petId;
  final String date;
  final String title;
  final String caption;
  final String imageUrl;
  final String milestoneType;

  const MemoryEntry({
    required this.id,
    required this.petId,
    required this.date,
    required this.title,
    required this.caption,
    required this.imageUrl,
    this.milestoneType = 'Milestone',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'date': date,
    'title': title,
    'caption': caption,
    'imageUrl': imageUrl,
    'milestoneType': milestoneType,
  };

  factory MemoryEntry.fromJson(Map<String, dynamic> json) => MemoryEntry(
    id: json['id'] as String,
    petId: json['petId'] as String,
    date: json['date'] as String,
    title: json['title'] as String,
    caption: json['caption'] as String? ?? '',
    imageUrl: json['imageUrl'] as String,
    milestoneType: json['milestoneType'] as String? ?? 'Milestone',
  );
}

class DocumentItem {
  final String id;
  final String petId;
  final String title;
  final String category; // Vaccination, Lab Result, Prescription, Insurance, Registration
  final String dateAdded;
  final String fileType;

  const DocumentItem({
    required this.id,
    required this.petId,
    required this.title,
    required this.category,
    required this.dateAdded,
    this.fileType = 'PDF',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'title': title,
    'category': category,
    'dateAdded': dateAdded,
    'fileType': fileType,
  };

  factory DocumentItem.fromJson(Map<String, dynamic> json) => DocumentItem(
    id: json['id'] as String,
    petId: json['petId'] as String,
    title: json['title'] as String,
    category: json['category'] as String,
    dateAdded: json['dateAdded'] as String,
    fileType: json['fileType'] as String? ?? 'PDF',
  );
}

class EmergencyCardData {
  final String petId;
  final String emergencyContactName;
  final String emergencyPhone;
  final String preferredVetName;
  final String preferredVetPhone;
  final String preferredClinic;
  final String criticalNotes;

  const EmergencyCardData({
    required this.petId,
    required this.emergencyContactName,
    required this.emergencyPhone,
    required this.preferredVetName,
    required this.preferredVetPhone,
    required this.preferredClinic,
    this.criticalNotes = '',
  });

  Map<String, dynamic> toJson() => {
    'petId': petId,
    'emergencyContactName': emergencyContactName,
    'emergencyPhone': emergencyPhone,
    'preferredVetName': preferredVetName,
    'preferredVetPhone': preferredVetPhone,
    'preferredClinic': preferredClinic,
    'criticalNotes': criticalNotes,
  };

  factory EmergencyCardData.fromJson(Map<String, dynamic> json) => EmergencyCardData(
    petId: json['petId'] as String,
    emergencyContactName: json['emergencyContactName'] as String,
    emergencyPhone: json['emergencyPhone'] as String,
    preferredVetName: json['preferredVetName'] as String,
    preferredVetPhone: json['preferredVetPhone'] as String,
    preferredClinic: json['preferredClinic'] as String,
    criticalNotes: json['criticalNotes'] as String? ?? '',
  );
}

class VetPrepItem {
  final String id;
  final String appointmentId;
  final String text;
  final bool isChecked;

  const VetPrepItem({
    required this.id,
    required this.appointmentId,
    required this.text,
    this.isChecked = false,
  });

  VetPrepItem copyWith({bool? isChecked}) {
    return VetPrepItem(
      id: id,
      appointmentId: appointmentId,
      text: text,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'appointmentId': appointmentId,
    'text': text,
    'isChecked': isChecked,
  };

  factory VetPrepItem.fromJson(Map<String, dynamic> json) => VetPrepItem(
    id: json['id'] as String,
    appointmentId: json['appointmentId'] as String,
    text: json['text'] as String,
    isChecked: json['isChecked'] as bool? ?? false,
  );
}

class AdoptionPet {
  final String id;
  final String name;
  final String species;
  final String breed;
  final double ageYears;
  final String bio;
  final String imageUrl;
  final double weightKg;
  final String fosterStatus;

  const AdoptionPet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.ageYears,
    required this.bio,
    required this.imageUrl,
    required this.weightKg,
    this.fosterStatus = 'Available for Adoption',
  });
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String weightUnit;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl = '',
    this.weightUnit = 'kg',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatarUrl': avatarUrl,
    'weightUnit': weightUnit,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    avatarUrl: json['avatarUrl'] as String? ?? '',
    weightUnit: json['weightUnit'] as String? ?? 'kg',
  );
}

class CareCircleMember {
  final String id;
  final String name;
  final String role; // Owner, Family, Pet Sitter, Co-Owner
  final String email;
  final String phone;
  final String avatarUrl;
  final List<String> permissions; // View pet, Complete routines, Add notes, View health, Emergency access

  const CareCircleMember({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    this.avatarUrl = '',
    this.permissions = const ['View pet', 'Complete routines', 'Add notes'],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role,
    'email': email,
    'phone': phone,
    'avatarUrl': avatarUrl,
    'permissions': permissions,
  };

  factory CareCircleMember.fromJson(Map<String, dynamic> json) => CareCircleMember(
    id: json['id'] as String,
    name: json['name'] as String,
    role: json['role'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String? ?? '',
    avatarUrl: json['avatarUrl'] as String? ?? '',
    permissions: (json['permissions'] as List?)?.map((e) => e.toString()).toList() ??
        const ['View pet', 'Complete routines', 'Add notes'],
  );
}

class PetMilestone {
  final String id;
  final String petId;
  final String year;
  final String title;
  final String subtitle;
  final String date;
  final bool isAutomated;

  const PetMilestone({
    required this.id,
    required this.petId,
    required this.year,
    required this.title,
    required this.subtitle,
    required this.date,
    this.isAutomated = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'year': year,
    'title': title,
    'subtitle': subtitle,
    'date': date,
    'isAutomated': isAutomated,
  };

  factory PetMilestone.fromJson(Map<String, dynamic> json) => PetMilestone(
    id: json['id'] as String,
    petId: json['petId'] as String,
    year: json['year'] as String,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String? ?? '',
    date: json['date'] as String? ?? '',
    isAutomated: json['isAutomated'] as bool? ?? false,
  );
}

class WellnessSnapshot {
  final int waterCupsDrank;
  final int waterCupsTarget;
  final int mealsCompleted;
  final int mealsTarget;
  final int walkMinutes;
  final int medicationCompleted;
  final int medicationTarget;

  const WellnessSnapshot({
    this.waterCupsDrank = 3,
    this.waterCupsTarget = 4,
    this.mealsCompleted = 2,
    this.mealsTarget = 3,
    this.walkMinutes = 35,
    this.medicationCompleted = 1,
    this.medicationTarget = 2,
  });
}

class SymptomNote {
  final String id;
  final String petId;
  final String date;
  final String appetite; // Good, Fair, Reduced, None
  final String energy; // Normal, Lethargic, High
  final String stool; // Normal, Soft, Hard
  final String skin; // Clear, Mild paw redness, Itchy
  final String notes;

  const SymptomNote({
    required this.id,
    required this.petId,
    required this.date,
    required this.appetite,
    required this.energy,
    required this.stool,
    required this.skin,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'date': date,
    'appetite': appetite,
    'energy': energy,
    'stool': stool,
    'skin': skin,
    'notes': notes,
  };

  factory SymptomNote.fromJson(Map<String, dynamic> json) => SymptomNote(
    id: json['id'] as String,
    petId: json['petId'] as String,
    date: json['date'] as String,
    appetite: json['appetite'] as String? ?? 'Good',
    energy: json['energy'] as String? ?? 'Normal',
    stool: json['stool'] as String? ?? 'Normal',
    skin: json['skin'] as String? ?? 'Clear',
    notes: json['notes'] as String? ?? '',
  );
}

class SearchResultItem {
  final String title;
  final String subtitle;
  final String category; // 'Care', 'Health', 'Medication', 'Appointment', 'Memory', 'Document', 'Pet'
  final String date;
  final String petName;
  final dynamic originalObject;

  const SearchResultItem({
    required this.title,
    required this.subtitle,
    required this.category,
    this.date = '',
    this.petName = '',
    this.originalObject,
  });
}
