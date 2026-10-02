import '../models/pet.dart';
import '../models/care_routine.dart';
import '../models/models.dart';

class SampleData {
  SampleData._();

  static const UserProfile defaultUser = UserProfile(
    id: 'user_lady',
    name: 'Lady',
    email: 'lady@pawly.app',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
    weightUnit: 'kg',
  );

  static final List<Pet> initialPets = [
    const Pet(
      id: 'pet_mochi',
      name: 'Mochi',
      animalType: 'Dog',
      breed: 'Golden Retriever',
      ageYears: 3.0,
      weightKg: 28.5,
      gender: 'Male',
      imageUrl: 'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=800&q=80',
      notes: 'Loves swimming, tennis balls, and carrots. Friendly with kids and other dogs.',
      allergies: 'Seasonal grass pollen',
      microchipNumber: '985-1410-0982-1201',
      birthday: 'April 12, 2023',
      category: 'Companion',
    ),
    const Pet(
      id: 'pet_luna',
      name: 'Luna',
      animalType: 'Cat',
      breed: 'British Shorthair',
      ageYears: 2.0,
      weightKg: 4.2,
      gender: 'Female',
      imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=800&q=80',
      notes: 'Quiet window birdwatcher. Prefers salmon pate. Sensitive to vacuum cleaner noise.',
      allergies: 'None reported',
      microchipNumber: '985-1410-0982-5541',
      birthday: 'May 20, 2024',
      category: 'Companion',
    ),
    const Pet(
      id: 'pet_milo',
      name: 'Milo',
      animalType: 'Dog',
      breed: 'Beagle',
      ageYears: 1.5,
      weightKg: 12.0,
      gender: 'Male',
      imageUrl: 'https://images.unsplash.com/photo-1537151608828-ea2b11777ee8?auto=format&fit=crop&w=800&q=80',
      notes: 'High energy scent hound. Loves puzzle feeders and agility games.',
      allergies: 'Chicken sensitivity',
      microchipNumber: '985-1410-0982-8873',
      birthday: 'March 8, 2025',
      category: 'Companion',
    ),
  ];

  static final List<CareRoutine> initialRoutines = [
    const CareRoutine(
      id: 'care_1',
      petId: 'pet_mochi',
      title: 'Apoquel 16mg Allergy Dose',
      time: '08:00 AM',
      date: '2026-10-02',
      category: CareCategory.medication,
      priority: 'High',
      isCompleted: false,
      notes: 'Give with morning meal kibble.',
      recurrence: 'Daily',
    ),
    const CareRoutine(
      id: 'care_2',
      petId: 'pet_mochi',
      title: 'Lunch & Fresh Water',
      time: '12:00 PM',
      date: '2026-10-02',
      category: CareCategory.feeding,
      priority: 'Medium',
      isCompleted: false,
      notes: '1.5 cups premium dry food.',
      recurrence: 'Daily',
    ),
    const CareRoutine(
      id: 'care_3',
      petId: 'pet_mochi',
      title: 'Evening Neighborhood Walk',
      time: '06:00 PM',
      date: '2026-10-02',
      category: CareCategory.exercise,
      priority: 'Medium',
      isCompleted: false,
      notes: '35-minute park stroll and fetch.',
      recurrence: 'Daily',
    ),
    const CareRoutine(
      id: 'care_4',
      petId: 'pet_luna',
      title: 'Undercoat Deshedding Brush',
      time: '06:30 PM',
      date: '2026-10-02',
      category: CareCategory.grooming,
      priority: 'Low',
      isCompleted: false,
      notes: 'Gentle 15-minute brush session.',
      recurrence: 'Every 3 days',
    ),
    const CareRoutine(
      id: 'care_5',
      petId: 'pet_mochi',
      title: 'Morning Recall Training',
      time: '07:30 AM',
      date: '2026-10-02',
      category: CareCategory.exercise,
      priority: 'Low',
      isCompleted: true,
      notes: 'Recall drill in fenced backyard.',
      recurrence: 'Daily',
    ),
  ];

  static final List<Appointment> initialAppointments = [
    const Appointment(
      id: 'appt_1',
      petId: 'pet_mochi',
      date: '2026-10-12',
      time: '10:30 AM',
      purpose: 'Dermatology Consultation',
      clinic: 'CityVet Wellness Center',
      vetName: 'Dr. Sarah Ramos, DVM',
      notes: 'Review grass allergy symptoms and seasonal coat cytology.',
      isCompleted: false,
    ),
    const Appointment(
      id: 'appt_2',
      petId: 'pet_luna',
      date: '2026-10-24',
      time: '02:00 PM',
      purpose: 'Dental Cleaning Checkup',
      clinic: 'Metro Pet Hospital',
      vetName: 'Dr. Julian Santos, DVM',
      notes: 'Routine ultrasonic scale evaluation.',
      isCompleted: false,
    ),
    const Appointment(
      id: 'appt_3',
      petId: 'pet_mochi',
      date: '2026-08-15',
      time: '11:00 AM',
      purpose: 'Annual Physical & Vitals Check',
      clinic: 'CityVet Wellness Center',
      vetName: 'Dr. Sarah Ramos, DVM',
      notes: 'All vitals normal. Body condition score 5/9.',
      isCompleted: true,
    ),
  ];

  static final List<HealthEvent> initialHealthEvents = [
    const HealthEvent(
      id: 'health_1',
      petId: 'pet_mochi',
      date: 'Oct 02, 2026',
      title: 'Routine Checkup & Vitals',
      type: 'Vet Visit',
      notes: 'Healthy overall. Distal paws show mild seasonal redness. Ears clean, heart and lungs clear.',
      veterinarian: 'Dr. Sarah Ramos, DVM',
      clinic: 'CityVet Wellness Center',
    ),
    const HealthEvent(
      id: 'health_2',
      petId: 'pet_mochi',
      date: 'Sep 15, 2026',
      title: 'DHPP Booster Administered',
      type: 'Vaccination',
      notes: 'Core canine booster administered subcutaneous. No adverse reaction during 15-minute observation.',
      veterinarian: 'Dr. Sarah Ramos, DVM',
      clinic: 'CityVet Wellness Center',
    ),
    const HealthEvent(
      id: 'health_3',
      petId: 'pet_mochi',
      date: 'Aug 21, 2026',
      title: 'Weight Milestone Recorded',
      type: 'Checkup',
      notes: 'Weight steady at 28.5 kg. Good muscle definition maintained through regular exercise.',
      veterinarian: 'Dr. Sarah Ramos, DVM',
      clinic: 'CityVet Wellness Center',
    ),
  ];

  static final List<WeightEntry> initialWeightHistory = [
    const WeightEntry(id: 'w_1', petId: 'pet_mochi', date: 'Jun 10, 2026', weightKg: 27.5, note: 'Early summer weigh-in'),
    const WeightEntry(id: 'w_2', petId: 'pet_mochi', date: 'Jul 15, 2026', weightKg: 27.9, note: 'Normal physical check'),
    const WeightEntry(id: 'w_3', petId: 'pet_mochi', date: 'Aug 21, 2026', weightKg: 28.2, note: 'Post-lake vacation'),
    const WeightEntry(id: 'w_4', petId: 'pet_mochi', date: 'Oct 02, 2026', weightKg: 28.5, note: 'Target adult maintenance'),
    const WeightEntry(id: 'w_5', petId: 'pet_luna', date: 'Jul 10, 2026', weightKg: 4.1, note: 'Annual physical'),
    const WeightEntry(id: 'w_6', petId: 'pet_luna', date: 'Sep 20, 2026', weightKg: 4.2, note: 'Stable indoor weight'),
  ];

  static final List<VaccinationRecord> initialVaccinations = [
    const VaccinationRecord(
      id: 'v_1',
      petId: 'pet_mochi',
      vaccineName: 'Rabies (3-Year Booster)',
      dateAdministered: 'Aug 15, 2024',
      nextDueDate: 'Aug 15, 2027',
      veterinarian: 'Dr. Sarah Ramos, DVM',
      clinic: 'CityVet Wellness Center',
      status: VaccineStatus.current,
      notes: 'Microchip verified prior to vaccine.',
    ),
    const VaccinationRecord(
      id: 'v_2',
      petId: 'pet_mochi',
      vaccineName: 'Core Canine DHPP Booster',
      dateAdministered: 'Sep 15, 2025',
      nextDueDate: 'Sep 15, 2026',
      veterinarian: 'Dr. Sarah Ramos, DVM',
      clinic: 'CityVet Wellness Center',
      status: VaccineStatus.dueSoon,
      notes: 'Annual immunity protection.',
    ),
    const VaccinationRecord(
      id: 'v_3',
      petId: 'pet_mochi',
      vaccineName: 'Bordetella (Oral Kennel Cough)',
      dateAdministered: 'Mar 10, 2026',
      nextDueDate: 'Sep 10, 2026',
      veterinarian: 'Dr. Sarah Ramos, DVM',
      clinic: 'CityVet Wellness Center',
      status: VaccineStatus.dueSoon,
      notes: 'Required for daycare and agility classes.',
    ),
  ];

  static final List<Medication> initialMedications = [
    const Medication(
      id: 'med_1',
      petId: 'pet_mochi',
      name: 'Apoquel 16mg',
      dosage: '1 tablet (16mg)',
      frequency: 'Once daily with morning meal',
      instructions: 'Administer with food during seasonal pollen peaks. Do not skip days.',
      startDate: 'Aug 01, 2026',
      endDate: 'Nov 01, 2026',
      isActive: true,
    ),
    const Medication(
      id: 'med_2',
      petId: 'pet_mochi',
      name: 'Heartgard Plus Chewable',
      dosage: '1 beef chew (51-100 lbs)',
      frequency: 'Monthly on the 1st',
      instructions: 'Give directly by hand or in food bowl. Protects against heartworm.',
      startDate: 'Jan 01, 2026',
      endDate: 'Ongoing',
      isActive: true,
    ),
  ];

  static final List<MemoryEntry> initialMemories = [
    const MemoryEntry(
      id: 'mem_1',
      petId: 'pet_mochi',
      date: 'Aug 20, 2026',
      title: 'First Beach Trip',
      caption: 'Mochi spent three full hours leaping into ocean waves and digging for sea shells!',
      imageUrl: 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=800&q=80',
      milestoneType: 'Adventure',
    ),
    const MemoryEntry(
      id: 'mem_2',
      petId: 'pet_mochi',
      date: 'Apr 12, 2026',
      title: '3rd Birthday Party',
      caption: 'Homemade carrot & peanut butter cake with party hats and neighborhood puppy friends.',
      imageUrl: 'https://images.unsplash.com/photo-1535930891776-0c2dfb7fda1a?auto=format&fit=crop&w=800&q=80',
      milestoneType: 'Birthday',
    ),
    const MemoryEntry(
      id: 'mem_3',
      petId: 'pet_mochi',
      date: 'Nov 04, 2024',
      title: 'Puppy School Graduation',
      caption: 'Passed obedience level 1 with a gold star medal for reliable recall.',
      imageUrl: 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?auto=format&fit=crop&w=800&q=80',
      milestoneType: 'Milestone',
    ),
  ];

  static final List<DocumentItem> initialDocuments = [
    const DocumentItem(
      id: 'doc_1',
      petId: 'pet_mochi',
      title: 'Rabies Certificate & Serology Tag',
      category: 'Vaccination',
      dateAdded: 'Aug 15, 2024',
      fileType: 'PDF • 1.2 MB',
    ),
    const DocumentItem(
      id: 'doc_2',
      petId: 'pet_mochi',
      title: 'Municipal Dog License Record',
      category: 'Registration',
      dateAdded: 'Jan 10, 2026',
      fileType: 'PDF • 480 KB',
    ),
    const DocumentItem(
      id: 'doc_3',
      petId: 'pet_mochi',
      title: 'Pet Insurance Comprehensive Policy',
      category: 'Insurance',
      dateAdded: 'Apr 01, 2026',
      fileType: 'PDF • 2.8 MB',
    ),
  ];

  static const EmergencyCardData defaultEmergency = EmergencyCardData(
    petId: 'pet_mochi',
    emergencyContactName: 'Lady Liberty Caragay (Owner)',
    emergencyPhone: '+1 (555) 392-8821',
    preferredVetName: 'Dr. Sarah Ramos, DVM',
    preferredVetPhone: '+1 (555) 902-1144',
    preferredClinic: 'CityVet Wellness Center (24/7 Urgent Care)',
    criticalNotes: 'Seasonal grass allergy. Do not administer penicillin-derived antibiotics without vet review.',
  );

  static final List<VetPrepItem> initialVetPrep = [
    const VetPrepItem(id: 'prep_1', appointmentId: 'appt_1', text: 'Bring updated vaccination certificate', isChecked: true),
    const VetPrepItem(id: 'prep_2', appointmentId: 'appt_1', text: 'Take photo of distal paw redness for Dr. Ramos', isChecked: true),
    const VetPrepItem(id: 'prep_3', appointmentId: 'appt_1', text: 'Ask about adjusting Apoquel dosage for pollen season', isChecked: false),
    const VetPrepItem(id: 'prep_4', appointmentId: 'appt_1', text: 'Check if heartworm blood titer is due this autumn', isChecked: false),
  ];

  static final List<AdoptionPet> adoptionPets = [
    const AdoptionPet(
      id: 'adopt_1',
      name: 'Barnaby',
      species: 'Rabbit',
      breed: 'Holland Lop',
      ageYears: 1.0,
      bio: 'Gentle indoor rabbit looking for a quiet home. Litter-box trained and loves fresh Timothy hay.',
      imageUrl: 'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?auto=format&fit=crop&w=800&q=80',
      weightKg: 1.8,
      fosterStatus: 'Available for Adoption',
    ),
    const AdoptionPet(
      id: 'adopt_2',
      name: 'Buster',
      species: 'Dog',
      breed: 'Beagle Cross',
      ageYears: 4.0,
      bio: 'Affectionate and crate-trained rescue. Gets along wonderfully with children and other companions.',
      imageUrl: 'https://images.unsplash.com/photo-1537151608828-ea2b11777ee8?auto=format&fit=crop&w=800&q=80',
      weightKg: 11.4,
      fosterStatus: 'Pending Foster Review',
    ),
  ];
}
