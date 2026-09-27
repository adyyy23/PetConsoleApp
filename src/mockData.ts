import { Pet, Reminder, Appointment, AdoptionRecord, HealthRecord, AppNotification } from './types';

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
    avatarBg: '#dbeafe',
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
    avatarBg: '#fef3c7',
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
    availableForAdoption: true
  }
];

export const INITIAL_REMINDERS: Reminder[] = [
  {
    id: 1,
    petId: 1,
    scheduleDate: '2026-09-28',
    time: '08:00 AM',
    suggestion: 'Administer Apoquel 16mg for allergy maintenance with morning kibble',
    priority: 'High',
    category: 'Medication',
    completed: false
  },
  {
    id: 2,
    petId: 2,
    scheduleDate: '2026-09-28',
    time: '06:00 PM',
    suggestion: 'Gentle undercoat deshedding brush session (15 mins)',
    priority: 'Medium',
    category: 'Grooming',
    completed: false
  },
  {
    id: 3,
    petId: 1,
    scheduleDate: '2026-09-29',
    time: '07:30 AM',
    suggestion: 'Morning exercise and obedience recall drill (45 mins)',
    priority: 'Low',
    category: 'Exercise',
    completed: true
  },
  {
    id: 4,
    petId: 3,
    scheduleDate: '2026-09-30',
    time: '09:00 AM',
    suggestion: 'Replenish Timothy hay stock and check water bottle valve',
    priority: 'High',
    category: 'Feeding',
    completed: false
  },
  {
    id: 5,
    petId: 4,
    scheduleDate: '2026-10-05',
    time: '10:00 AM',
    suggestion: 'Rabies and DHPP 3-year booster shot due',
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
    clinic: 'City Vet Wellness Center',
    purpose: 'Dermatology',
    status: 'Scheduled'
  },
  {
    id: 2,
    petId: 2,
    appointmentDate: '2026-10-14',
    time: '02:00 PM',
    vetName: 'Dr. Julian Santos, DVM',
    clinic: 'Metro Pet Hospital',
    purpose: 'Dental Cleaning',
    status: 'Scheduled'
  },
  {
    id: 3,
    petId: 4,
    appointmentDate: '2026-09-18',
    time: '11:00 AM',
    vetName: 'Dr. Sarah Ramos, DVM',
    clinic: 'City Vet Wellness Center',
    purpose: 'Annual Checkup',
    status: 'Completed'
  }
];

export const INITIAL_ADOPTIONS: AdoptionRecord[] = [
  {
    id: 1,
    petId: 3,
    availableForAdoption: true,
    adoptionHistory: 'Rescued from local shelter; cleared for indoor foster or adoption.',
    status: 'Available'
  },
  {
    id: 2,
    petId: 4,
    availableForAdoption: true,
    adoptionHistory: 'Surrendered due to family relocation. Very gentle with kids and crate trained.',
    adopterName: 'Mark Villanueva (Application in review)',
    adoptionDate: 'Pending',
    status: 'Application Pending'
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
    veterinarian: 'Dr. Sarah Ramos, DVM'
  },
  {
    id: 2,
    petId: 1,
    date: '2026-08-15',
    type: 'Checkup',
    title: 'Comprehensive Physical & Vitals Check',
    notes: 'Eyes and ears clear. Heart and lungs auscultated normal. Mild erythema on distal paws consistent with seasonal contact allergy.',
    veterinarian: 'Dr. Sarah Ramos, DVM'
  },
  {
    id: 3,
    petId: 2,
    date: '2026-07-10',
    type: 'Vaccination',
    title: 'Feline FVRCP Annual Booster',
    notes: 'Healthy body condition score 5/9. Vaccine administered without complication.',
    veterinarian: 'Dr. Julian Santos, DVM'
  }
];

export const INITIAL_NOTIFICATIONS: AppNotification[] = [
  {
    id: 1,
    title: 'Upcoming Allergy Medication Due',
    description: 'Mochi requires Apoquel 16mg tomorrow at 08:00 AM with food.',
    timestamp: '10 mins ago',
    read: false,
    type: 'info'
  },
  {
    id: 2,
    title: 'Adoption Inquiry Received',
    description: 'Mark Villanueva submitted an adoption inquiry for Buster (Beagle Cross).',
    timestamp: '2 hours ago',
    read: false,
    type: 'success'
  },
  {
    id: 3,
    title: 'Vet Appointment Reminder',
    description: 'Dr. Ramos consultation scheduled for Mochi on Oct 02, 2026 at 10:30 AM.',
    timestamp: '1 day ago',
    read: true,
    type: 'warning'
  }
];
