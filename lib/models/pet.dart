class Pet {
  final String id;
  final String name;
  final String animalType; // Dog, Cat, Rabbit, Bird, Other
  final String breed;
  final double ageYears;
  final double weightKg;
  final String gender; // Male, Female
  final String imageUrl;
  final String notes;
  final String allergies;
  final String microchipNumber;
  final String birthday;
  final String category; // Companion, Rescue, Foster, Service

  const Pet({
    required this.id,
    required this.name,
    required this.animalType,
    required this.breed,
    required this.ageYears,
    required this.weightKg,
    required this.gender,
    required this.imageUrl,
    this.notes = '',
    this.allergies = 'None reported',
    this.microchipNumber = '',
    this.birthday = '',
    this.category = 'Companion',
  });

  String get species => animalType;
  String get microchipId => microchipNumber;

  Pet copyWith({
    String? id,
    String? name,
    String? animalType,
    String? breed,
    double? ageYears,
    double? weightKg,
    String? gender,
    String? imageUrl,
    String? notes,
    String? allergies,
    String? microchipNumber,
    String? birthday,
    String? category,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      animalType: animalType ?? this.animalType,
      breed: breed ?? this.breed,
      ageYears: ageYears ?? this.ageYears,
      weightKg: weightKg ?? this.weightKg,
      gender: gender ?? this.gender,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      allergies: allergies ?? this.allergies,
      microchipNumber: microchipNumber ?? this.microchipNumber,
      birthday: birthday ?? this.birthday,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'animalType': animalType,
    'breed': breed,
    'ageYears': ageYears,
    'weightKg': weightKg,
    'gender': gender,
    'imageUrl': imageUrl,
    'notes': notes,
    'allergies': allergies,
    'microchipNumber': microchipNumber,
    'birthday': birthday,
    'category': category,
  };

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
    id: json['id'] as String,
    name: json['name'] as String,
    animalType: json['animalType'] as String? ?? 'Dog',
    breed: json['breed'] as String? ?? 'Mixed',
    ageYears: (json['ageYears'] as num?)?.toDouble() ?? 2.0,
    weightKg: (json['weightKg'] as num?)?.toDouble() ?? 10.0,
    gender: json['gender'] as String? ?? 'Male',
    imageUrl: json['imageUrl'] as String? ?? '',
    notes: json['notes'] as String? ?? '',
    allergies: json['allergies'] as String? ?? 'None reported',
    microchipNumber: json['microchipNumber'] as String? ?? '',
    birthday: json['birthday'] as String? ?? '',
    category: json['category'] as String? ?? 'Companion',
  );
}
