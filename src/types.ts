export interface Pet {
  id: number;
  name: string;
  age: number;
  animalType: 'Dog' | 'Cat' | 'Bird' | 'Rabbit' | 'Other';
  breed: string;
  category: 'Companion' | 'Service' | 'Rescue' | 'Foster';
  lastCheckup: string;
  lastVaccination: string;
  disease: string;
  weightKg: number;
  gender: 'Male' | 'Female';
  avatarBg: string;
  imageUrl?: string;
  notes?: string;
  birthday?: string;
  microchipNumber?: string;
  availableForAdoption?: boolean;
}

export interface Reminder {
  id: number;
  petId: number;
  scheduleDate: string;
  time: string;
  suggestion: string;
  priority: 'High' | 'Medium' | 'Low';
  category: 'Vaccination' | 'Medication' | 'Feeding' | 'Grooming' | 'Vet Visit' | 'Exercise';
  completed: boolean;
}

export interface Appointment {
  id: number;
  petId: number;
  appointmentDate: string;
  time: string;
  vetName: string;
  clinic: string;
  purpose: 'Annual Checkup' | 'Vaccination Booster' | 'Dental Cleaning' | 'Dermatology' | 'Surgery Follow-up' | 'Emergency';
  status: 'Scheduled' | 'Completed' | 'Cancelled';
  notes?: string;
}

export interface AdoptionRecord {
  id: number;
  petId: number;
  availableForAdoption: boolean;
  adoptionHistory: string;
  adopterName?: string;
  adoptionDate?: string;
  status: 'Available' | 'Application Pending' | 'Adopted';
  inquiryContact?: string;
}

export interface HealthRecord {
  id: number;
  petId: number;
  date: string;
  type: 'Vaccination' | 'Checkup' | 'Medication' | 'Grooming' | 'Surgery';
  title: string;
  notes: string;
  veterinarian: string;
  clinic?: string;
}

export interface AppNotification {
  id: number;
  title: string;
  description: string;
  timestamp: string;
  read: boolean;
  type: 'warning' | 'info' | 'success';
}

export interface User {
  id: string;
  name: string;
  email: string;
  avatarUrl?: string;
}
