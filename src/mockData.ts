import { Pet, Reminder, Appointment, AdoptionRecord, HealthRecord, AppNotification, User } from './types';

export const INITIAL_USER: User = {
  id: 'user_1',
  name: 'Lady',
  email: 'lady@pawly.app',
  avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80'
};

export const INITIAL_PETS: Pet[] = [
  {
    id: 1,
    name: 'Mochi',
    age: 3,
    animalType: 'Dog',
    breed: 'Golden Retriever',
    category: 'Companion',
    lastCheckup: '2026-08-15',
    lastVaccination: '2026-08-15',
    disease: 'Seasonal grass allergy',
    weightKg: 28.5,
    gender: 'Male',
    avatarBg: '#fef3c7',
    imageUrl: 'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=800&q=80',
    notes: 'Very friendly, loves swimming and frozen carrot treats. Requires Apoquel during pollen season.',
    birthday: '2023-04-12',
    microchipNumber: '985-1410-0982-1201',
    availableForAdoption: false
  },
  {
    id: 2,
    name: 'Luna',
    age: 2,
    animalType: 'Cat',
    breed: 'British Shorthair',
    category: 'Companion',
    lastCheckup: '2026-07-10',
    lastVaccination: '2026-07-10',
    disease: 'None reported',
    weightKg: 4.2,
    gender: 'Female',
    avatarBg: '#e0e7ff',
    imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=800&q=80',
    notes: 'Calm indoor cat. Prefers salmon pate and window bird watching. Sensitive to loud noises.',
    birthday: '2024-05-20',
    microchipNumber: '985-1410-0982-5541',
    availableForAdoption: false
  },
  {
    id: 3,
    name: 'Barnaby',
    age: 1,
    animalType: 'Rabbit',
    breed: 'Holland Lop',
    category: 'Rescue',
    lastCheckup: '2026-09-02',
    lastVaccination: '2026-09-02',
    disease: 'Mild sensitive digestion',
    weightKg: 1.8,
    gender: 'Male',
    avatarBg: '#dcfce7',
    imageUrl: 'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?auto=format&fit=crop&w=800&q=80',
    notes: 'Gentle indoor bunny looking for a peaceful home. Loves fresh Timothy hay and apple wood chews.',
    birthday: '2025-06-15',
    availableForAdoption: true
  },
  {
    id: 4,
    name: 'Buster',
    age: 4,
    animalType: 'Dog',
    breed: 'Beagle Cross',
    category: 'Rescue',
    lastCheckup: '2026-06-20',
    lastVaccination: '2026-06-20',
    disease: 'Underweight (improving)',
    weightKg: 11.4,
    gender: 'Male',
    avatarBg: '#fce7f3',
    imageUrl: 'https://images.unsplash.com/photo-1537151608828-ea2b11777ee8?auto=format&fit=crop&w=800&q=80',
    notes: 'Affectionate and crate trained. Gets along great with kids and other dogs.',
    birthday: '2022-09-10',
    availableForAdoption: true
  }
];

export const INITIAL_REMINDERS: Reminder[] = [
  {
    id: 1,
    petId: 1,
    scheduleDate: '2026-10-02',
    time: '08:00 AM',
    suggestion: 'Allergy medication — Apoquel 16mg with morning meal',
    priority: 'High',
    category: 'Medication',
    completed: false
  },
  {
    id: 2,
    petId: 2,
    scheduleDate: '2026-10-02',
    time: '06:00 PM',
    suggestion: 'Undercoat brush session & dental check',
    priority: 'Medium',
    category: 'Grooming',
    completed: false
  },
  {
    id: 3,
    petId: 1,
    scheduleDate: '2026-10-03',
    time: '07:30 AM',
    suggestion: 'Morning exercise and recall training in park',
    priority: 'Low',
    category: 'Exercise',
    completed: true
  },
  {
    id: 4,
    petId: 3,
    scheduleDate: '2026-10-03',
    time: '09:00 AM',
    suggestion: 'Replenish Timothy hay rack & fresh clean water',
    priority: 'High',
    category: 'Feeding',
    completed: false
  },
  {
    id: 5,
    petId: 4,
    scheduleDate: '2026-10-05',
    time: '10:00 AM',
    suggestion: 'Rabies and DHPP 3-year booster visit',
    priority: 'High',
    category: 'Vaccination',
    completed: false
  }
];

export const INITIAL_APPOINTMENTS: Appointment[] = [
  {
    id: 1,
    petId: 1,
    appointmentDate: '2026-10-02',
    time: '10:30 AM',
    vetName: 'Dr. Sarah Ramos, DVM',
    clinic: 'CityVet Wellness Center',
    purpose: 'Dermatology',
    status: 'Scheduled',
    notes: 'Follow-up on seasonal paw itching and coat cytology.'
  },
  {
    id: 2,
    petId: 2,
    appointmentDate: '2026-10-14',
    time: '02:00 PM',
    vetName: 'Dr. Julian Santos, DVM',
    clinic: 'Metro Pet Hospital',
    purpose: 'Dental Cleaning',
    status: 'Scheduled',
    notes: 'Routine ultrasonic scale and polish.'
  },
  {
    id: 3,
    petId: 4,
    appointmentDate: '2026-09-18',
    time: '11:00 AM',
    vetName: 'Dr. Sarah Ramos, DVM',
    clinic: 'CityVet Wellness Center',
    purpose: 'Annual Checkup',
    status: 'Completed',
    notes: 'Physical exam clear, weight up by 1.1kg.'
  }
];

export const INITIAL_ADOPTIONS: AdoptionRecord[] = [
  {
    id: 1,
    petId: 3,
    availableForAdoption: true,
    adoptionHistory: 'Rescued from local foster network. Cleared for indoor bunny-proof home.',
    status: 'Available',
    inquiryContact: 'foster@pawly.app'
  },
  {
    id: 2,
    petId: 4,
    availableForAdoption: true,
    adoptionHistory: 'Surrendered due to family relocation. Extremely affectionate, good with other pets.',
    adopterName: 'Mark Villanueva',
    adoptionDate: 'Pending Review',
    status: 'Application Pending',
    inquiryContact: 'rescue@pawly.app'
  }
];

export const INITIAL_HEALTH_RECORDS: HealthRecord[] = [
  {
    id: 1,
    petId: 1,
    date: '2026-08-15',
    type: 'Vaccination',
    title: 'Core Canine Booster (DHPP + Leptospirosis)',
    notes: 'Administered right shoulder subcutaneous. Temperature 38.4°C normal. No adverse reaction observed during 15-min post observation.',
    veterinarian: 'Dr. Sarah Ramos, DVM',
    clinic: 'CityVet Wellness Center'
  },
  {
    id: 2,
    petId: 1,
    date: '2026-08-15',
    type: 'Checkup',
    title: 'Annual Physical & Vitals Check',
    notes: 'Eyes and ears clear. Heart and lungs auscultated normal. Mild seasonal erythema on distal paws.',
    veterinarian: 'Dr. Sarah Ramos, DVM',
    clinic: 'CityVet Wellness Center'
  },
  {
    id: 3,
    petId: 2,
    date: '2026-07-10',
    type: 'Vaccination',
    title: 'Feline FVRCP Annual Booster',
    notes: 'Healthy body condition score 5/9. Vaccine administered without complication.',
    veterinarian: 'Dr. Julian Santos, DVM',
    clinic: 'Metro Pet Hospital'
  }
];

export const INITIAL_NOTIFICATIONS: AppNotification[] = [
  {
    id: 1,
    title: 'Allergy medication due today',
    description: 'Mochi needs Apoquel 16mg this morning with food.',
    timestamp: '15 mins ago',
    read: false,
    type: 'info'
  },
  {
    id: 2,
    title: 'Upcoming vet visit confirmed',
    description: 'Dr. Sarah Ramos consultation is scheduled for today at 10:30 AM.',
    timestamp: '2 hours ago',
    read: false,
    type: 'success'
  },
  {
    id: 3,
    title: 'New adoption update',
    description: 'Buster’s foster application has moved to the next step.',
    timestamp: 'Yesterday',
    read: true,
    type: 'info'
  }
];
