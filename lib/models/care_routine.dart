enum CareCategory {
  medication,
  feeding,
  water,
  exercise,
  grooming,
  vaccination,
  training,
  other,
}

extension CareCategoryX on CareCategory {
  String get displayName {
    switch (this) {
      case CareCategory.medication:
        return 'Medication';
      case CareCategory.feeding:
        return 'Feeding';
      case CareCategory.water:
        return 'Hydration';
      case CareCategory.exercise:
        return 'Exercise & Walk';
      case CareCategory.grooming:
        return 'Grooming';
      case CareCategory.vaccination:
        return 'Vaccination';
      case CareCategory.training:
        return 'Training';
      case CareCategory.other:
        return 'Routine';
    }
  }
}

class CareRoutine {
  final String id;
  final String petId;
  final String title;
  final String time; // e.g. "08:00 AM"
  final String date; // YYYY-MM-DD
  final CareCategory category;
  final String priority; // High, Medium, Low
  final bool isCompleted;
  final String notes;
  final String recurrence; // Daily, Weekdays, Every 2 weeks, Every 30 days, Monthly, Once
  final String assignedTo; // e.g. "Me", "David (Family)", "Sarah (Sitter)"
  final String completedAt; // e.g. "08:14 AM"

  const CareRoutine({
    required this.id,
    required this.petId,
    required this.title,
    required this.time,
    required this.date,
    required this.category,
    this.priority = 'Medium',
    this.isCompleted = false,
    this.notes = '',
    this.recurrence = 'Daily',
    this.assignedTo = 'Me',
    this.completedAt = '',
  });

  CareRoutine copyWith({
    String? id,
    String? petId,
    String? title,
    String? time,
    String? date,
    CareCategory? category,
    String? priority,
    bool? isCompleted,
    String? notes,
    String? recurrence,
    String? assignedTo,
    String? completedAt,
  }) {
    return CareRoutine(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      title: title ?? this.title,
      time: time ?? this.time,
      date: date ?? this.date,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
      recurrence: recurrence ?? this.recurrence,
      assignedTo: assignedTo ?? this.assignedTo,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'title': title,
    'time': time,
    'date': date,
    'category': category.name,
    'priority': priority,
    'isCompleted': isCompleted,
    'notes': notes,
    'recurrence': recurrence,
    'assignedTo': assignedTo,
    'completedAt': completedAt,
  };

  factory CareRoutine.fromJson(Map<String, dynamic> json) => CareRoutine(
    id: json['id'] as String,
    petId: json['petId'] as String,
    title: json['title'] as String,
    time: json['time'] as String,
    date: json['date'] as String,
    category: CareCategory.values.firstWhere(
      (e) => e.name == json['category'],
      orElse: () => CareCategory.other,
    ),
    priority: json['priority'] as String? ?? 'Medium',
    isCompleted: json['isCompleted'] as bool? ?? false,
    notes: json['notes'] as String? ?? '',
    recurrence: json['recurrence'] as String? ?? 'Daily',
    assignedTo: json['assignedTo'] as String? ?? 'Me',
    completedAt: json['completedAt'] as String? ?? '',
  );
}
