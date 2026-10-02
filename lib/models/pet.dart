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

  // Personality Profile fields
  final String nickname;
  final String favoriteFood;
  final String favoriteToy;
  final String favoriteActivity;
  final String temperament;
  final List<String> likes;
  final List<String> dislikes;
  final String funFact;

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
    this.nickname = '',
    this.favoriteFood = '',
    this.favoriteToy = '',
    this.favoriteActivity = '',
    this.temperament = 'Gentle, friendly & curious',
    this.likes = const [],
    this.dislikes = const [],
    this.funFact = '',
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
    String? nickname,
    String? favoriteFood,
    String? favoriteToy,
    String? favoriteActivity,
    String? temperament,
    List<String>? likes,
    List<String>? dislikes,
    String? funFact,
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
      nickname: nickname ?? this.nickname,
      favoriteFood: favoriteFood ?? this.favoriteFood,
      favoriteToy: favoriteToy ?? this.favoriteToy,
      favoriteActivity: favoriteActivity ?? this.favoriteActivity,
      temperament: temperament ?? this.temperament,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      funFact: funFact ?? this.funFact,
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
    'nickname': nickname,
    'favoriteFood': favoriteFood,
    'favoriteToy': favoriteToy,
    'favoriteActivity': favoriteActivity,
    'temperament': temperament,
    'likes': likes,
    'dislikes': dislikes,
    'funFact': funFact,
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
    nickname: json['nickname'] as String? ?? '',
    favoriteFood: json['favoriteFood'] as String? ?? '',
    favoriteToy: json['favoriteToy'] as String? ?? '',
    favoriteActivity: json['favoriteActivity'] as String? ?? '',
    temperament: json['temperament'] as String? ?? 'Gentle, friendly & curious',
    likes: (json['likes'] as List?)?.map((e) => e.toString()).toList() ?? const [],
    dislikes: (json['dislikes'] as List?)?.map((e) => e.toString()).toList() ?? const [],
    funFact: json['funFact'] as String? ?? '',
  );
}
