import React, { useState, useEffect } from 'react';
import {
  Pet,
  Reminder,
  Appointment,
  AdoptionRecord,
  HealthRecord,
  AppNotification,
  User
} from './types';
import {
  INITIAL_PETS,
  INITIAL_REMINDERS,
  INITIAL_APPOINTMENTS,
  INITIAL_ADOPTIONS,
  INITIAL_HEALTH_RECORDS,
  INITIAL_NOTIFICATIONS,
  INITIAL_USER
} from './mockData';

// Component Views
import { Navbar } from './components/Navbar';
import { MobileNav } from './components/MobileNav';
import { LandingPage } from './components/LandingPage';
import { AuthPage } from './components/AuthPage';
import { Onboarding } from './components/Onboarding';
import { HomeView } from './components/HomeView';
import { MyPetsView } from './components/MyPetsView';
import { PetProfileView } from './components/PetProfileView';
import { CareView } from './components/CareView';
import { AppointmentsView } from './components/AppointmentsView';
import { HealthView } from './components/HealthView';
import { DiscoverView } from './components/DiscoverView';

// Modals
import { AddPetModal } from './components/modals/AddPetModal';
import { AddReminderModal } from './components/modals/AddReminderModal';
import { AddAppointmentModal } from './components/modals/AddAppointmentModal';
import { AddHealthRecordModal } from './components/modals/AddHealthRecordModal';

export default function App() {
  // Authentication State
  const [currentUser, setCurrentUser] = useState<User | null>(() => {
    const saved = localStorage.getItem('pawly_auth_user');
    return saved ? JSON.parse(saved) : null;
  });

  // Current Route
  const [activeRoute, setActiveRoute] = useState<string>(() => {
    // If logged in, start at home, else start at landing
    const savedUser = localStorage.getItem('pawly_auth_user');
    return savedUser ? 'home' : 'landing';
  });

  const [selectedPetId, setSelectedPetId] = useState<number>(1);
  const [searchQuery, setSearchQuery] = useState('');

  // Modals state
  const [isAddPetOpen, setIsAddPetOpen] = useState(false);
  const [isAddReminderOpen, setIsAddReminderOpen] = useState(false);
  const [isAddApptOpen, setIsAddApptOpen] = useState(false);
  const [isAddHealthOpen, setIsAddHealthOpen] = useState(false);

  // Data State with backwards-compatible LocalStorage sync
  const [pets, setPets] = useState<Pet[]>(() => {
    const saved = localStorage.getItem('pawly_pets') || localStorage.getItem('petconsole_pets');
    return saved ? JSON.parse(saved) : INITIAL_PETS;
  });

  const [reminders, setReminders] = useState<Reminder[]>(() => {
    const saved = localStorage.getItem('pawly_reminders') || localStorage.getItem('petconsole_reminders');
    return saved ? JSON.parse(saved) : INITIAL_REMINDERS;
  });

  const [appointments, setAppointments] = useState<Appointment[]>(() => {
    const saved = localStorage.getItem('pawly_appointments') || localStorage.getItem('petconsole_appointments');
    return saved ? JSON.parse(saved) : INITIAL_APPOINTMENTS;
  });

  const [adoptions, setAdoptions] = useState<AdoptionRecord[]>(() => {
    const saved = localStorage.getItem('pawly_adoptions') || localStorage.getItem('petconsole_adoptions');
    return saved ? JSON.parse(saved) : INITIAL_ADOPTIONS;
  });

  const [healthRecords, setHealthRecords] = useState<HealthRecord[]>(() => {
    const saved = localStorage.getItem('pawly_health') || localStorage.getItem('petconsole_health');
    return saved ? JSON.parse(saved) : INITIAL_HEALTH_RECORDS;
  });

  const [notifications, setNotifications] = useState<AppNotification[]>(() => {
    const saved = localStorage.getItem('pawly_notifs') || localStorage.getItem('petconsole_notifs');
    return saved ? JSON.parse(saved) : INITIAL_NOTIFICATIONS;
  });

  // Sync to LocalStorage
  useEffect(() => {
    if (currentUser) {
      localStorage.setItem('pawly_auth_user', JSON.stringify(currentUser));
    } else {
      localStorage.removeItem('pawly_auth_user');
    }
  }, [currentUser]);

  useEffect(() => {
    localStorage.setItem('pawly_pets', JSON.stringify(pets));
    localStorage.setItem('petconsole_pets', JSON.stringify(pets));
  }, [pets]);

  useEffect(() => {
    localStorage.setItem('pawly_reminders', JSON.stringify(reminders));
    localStorage.setItem('petconsole_reminders', JSON.stringify(reminders));
  }, [reminders]);

  useEffect(() => {
    localStorage.setItem('pawly_appointments', JSON.stringify(appointments));
    localStorage.setItem('petconsole_appointments', JSON.stringify(appointments));
  }, [appointments]);

  useEffect(() => {
    localStorage.setItem('pawly_adoptions', JSON.stringify(adoptions));
    localStorage.setItem('petconsole_adoptions', JSON.stringify(adoptions));
  }, [adoptions]);

  useEffect(() => {
    localStorage.setItem('pawly_health', JSON.stringify(healthRecords));
    localStorage.setItem('petconsole_health', JSON.stringify(healthRecords));
  }, [healthRecords]);

  useEffect(() => {
    localStorage.setItem('pawly_notifs', JSON.stringify(notifications));
    localStorage.setItem('petconsole_notifs', JSON.stringify(notifications));
  }, [notifications]);

  // Auth Handlers
  const handleAuthSuccess = (user: User, isNewUser: boolean) => {
    setCurrentUser(user);
    if (isNewUser) {
      setActiveRoute('onboarding');
    } else {
      setActiveRoute('home');
    }
  };

  const handleLogout = () => {
    setCurrentUser(null);
    setActiveRoute('landing');
  };

  const handleExploreDemo = () => {
    setCurrentUser(INITIAL_USER);
    setActiveRoute('home');
  };

  const handleOnboardingComplete = (firstPet: Pet) => {
    setPets([firstPet, ...pets]);
    setSelectedPetId(firstPet.id);
    setActiveRoute('home');
  };

  // Pet Actions
  const handleAddPet = (newPet: Pet) => {
    setPets([newPet, ...pets]);
    setSelectedPetId(newPet.id);
    setNotifications(prev => [
      {
        id: Date.now(),
        title: `Welcome ${newPet.name}!`,
        description: `${newPet.name}’s profile has been created successfully.`,
        timestamp: 'Just now',
        read: false,
        type: 'success'
      },
      ...prev
    ]);
  };

  const handleUpdatePet = (updatedPet: Pet) => {
    setPets(prev => prev.map(p => (p.id === updatedPet.id ? updatedPet : p)));
  };

  const handleDeletePet = (id: number) => {
    if (confirm('Are you sure you want to remove this pet profile?')) {
      setPets(prev => prev.filter(p => p.id !== id));
      setReminders(prev => prev.filter(r => r.petId !== id));
      setAppointments(prev => prev.filter(a => a.petId !== id));
      setHealthRecords(prev => prev.filter(h => h.petId !== id));
      if (selectedPetId === id) {
        const remaining = pets.filter(p => p.id !== id);
        if (remaining.length > 0) {
          setSelectedPetId(remaining[0].id);
        }
      }
      setActiveRoute('pets');
    }
  };

  // Reminder Actions
  const handleToggleReminder = (id: number) => {
    setReminders(prev =>
      prev.map(r => (r.id === id ? { ...r, completed: !r.completed } : r))
    );
  };

  const handleDeleteReminder = (id: number) => {
    setReminders(prev => prev.filter(r => r.id !== id));
  };

  const handleAddReminder = (newReminder: Reminder) => {
    setReminders([newReminder, ...reminders]);
  };

  // Appointment Actions
  const handleAddAppointment = (newAppt: Appointment) => {
    setAppointments([newAppt, ...appointments]);
    setNotifications(prev => [
      {
        id: Date.now(),
        title: 'New vet appointment scheduled',
        description: `${newAppt.purpose} on ${newAppt.appointmentDate} at ${newAppt.clinic}.`,
        timestamp: 'Just now',
        read: false,
        type: 'info'
      },
      ...prev
    ]);
  };

  const handleMarkApptCompleted = (id: number) => {
    setAppointments(prev =>
      prev.map(a => (a.id === id ? { ...a, status: 'Completed' } : a))
    );
  };

  // Health Record Actions
  const handleAddHealthRecord = (newRec: HealthRecord) => {
    setHealthRecords([newRec, ...healthRecords]);
  };

  // Adoption Inquiry
  const handleAdoptionInquiry = (petId: number, applicantName: string, msg: string) => {
    setNotifications(prev => [
      {
        id: Date.now(),
        title: 'Adoption inquiry sent',
        description: `Your message for pet #${petId} has been sent to the rescue network.`,
        timestamp: 'Just now',
        read: false,
        type: 'success'
      },
      ...prev
    ]);
  };

  // Mark all notifications read
  const handleMarkAllNotifsRead = () => {
    setNotifications(prev => prev.map(n => ({ ...n, read: true })));
  };

  // Active pet object
  const currentActivePet = pets.find(p => p.id === selectedPetId) || pets[0];

  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      {/* Top Navbar */}
      <Navbar
        currentUser={currentUser}
        activeRoute={activeRoute}
        onNavigate={route => {
          if (route === 'landing-features' || route === 'landing-how' || route === 'landing-care') {
            if (activeRoute !== 'landing') setActiveRoute('landing');
            setTimeout(() => {
              const el = document.getElementById(route);
              el?.scrollIntoView({ behavior: 'smooth' });
            }, 100);
          } else {
            setActiveRoute(route);
          }
        }}
        pets={pets}
        activePetId={selectedPetId}
        onSelectActivePet={id => setSelectedPetId(id)}
        notifications={notifications}
        onMarkNotificationsRead={handleMarkAllNotifsRead}
        onOpenAddPet={() => setIsAddPetOpen(true)}
        onLogout={handleLogout}
        searchQuery={searchQuery}
        onSearchChange={setSearchQuery}
      />

      {/* Main Content Router */}
      <main style={{ flex: 1 }}>
        {/* PUBLIC ROUTES */}
        {activeRoute === 'landing' && (
          <LandingPage
            onStartAuth={mode => setActiveRoute(mode)}
            onExploreDemo={handleExploreDemo}
          />
        )}

        {(activeRoute === 'login' || activeRoute === 'signup') && (
          <AuthPage
            initialMode={activeRoute as 'login' | 'signup'}
            onSuccess={handleAuthSuccess}
            onCancel={() => setActiveRoute('landing')}
          />
        )}

        {/* ONBOARDING */}
        {activeRoute === 'onboarding' && currentUser && (
          <Onboarding
            user={currentUser}
            onComplete={handleOnboardingComplete}
          />
        )}

        {/* LOGGED IN ROUTES */}
        {activeRoute === 'home' && currentUser && (
          <HomeView
            user={currentUser}
            pets={pets}
            activePetId={selectedPetId}
            onSelectActivePet={id => setSelectedPetId(id)}
            reminders={reminders}
            appointments={appointments}
            healthRecords={healthRecords}
            onToggleReminder={handleToggleReminder}
            onNavigate={(route, petId) => {
              if (petId) setSelectedPetId(petId);
              setActiveRoute(route);
            }}
            onOpenAddReminder={() => setIsAddReminderOpen(true)}
            onOpenAddAppointment={() => setIsAddApptOpen(true)}
            onOpenAddPet={() => setIsAddPetOpen(true)}
          />
        )}

        {activeRoute === 'pets' && currentUser && (
          <MyPetsView
            pets={pets}
            reminders={reminders}
            appointments={appointments}
            onSelectPet={petId => {
              setSelectedPetId(petId);
              setActiveRoute('pet-profile');
            }}
            onOpenAddPet={() => setIsAddPetOpen(true)}
            searchQuery={searchQuery}
          />
        )}

        {activeRoute === 'pet-profile' && currentUser && currentActivePet && (
          <PetProfileView
            pet={currentActivePet}
            reminders={reminders}
            appointments={appointments}
            healthRecords={healthRecords}
            onBack={() => setActiveRoute('pets')}
            onToggleReminder={handleToggleReminder}
            onDeletePet={handleDeletePet}
            onUpdatePet={handleUpdatePet}
            onOpenAddReminder={() => setIsAddReminderOpen(true)}
            onOpenAddAppointment={() => setIsAddApptOpen(true)}
            onOpenAddHealthRecord={() => setIsAddHealthOpen(true)}
          />
        )}

        {activeRoute === 'care' && currentUser && (
          <CareView
            pets={pets}
            reminders={reminders}
            onToggleReminder={handleToggleReminder}
            onDeleteReminder={handleDeleteReminder}
            onOpenAddReminder={() => setIsAddReminderOpen(true)}
          />
        )}

        {activeRoute === 'appointments' && currentUser && (
          <AppointmentsView
            pets={pets}
            appointments={appointments}
            onOpenAddAppointment={() => setIsAddApptOpen(true)}
            onMarkAppointmentCompleted={handleMarkApptCompleted}
          />
        )}

        {activeRoute === 'health' && currentUser && (
          <HealthView
            pets={pets}
            healthRecords={healthRecords}
            onOpenAddRecord={() => setIsAddHealthOpen(true)}
          />
        )}

        {activeRoute === 'discover' && (
          <DiscoverView
            pets={pets}
            adoptions={adoptions}
            onInquirySubmitted={handleAdoptionInquiry}
          />
        )}
      </main>

      {/* Mobile Bottom Navigation for App Screens */}
      {currentUser && (
        <MobileNav
          currentUser={currentUser}
          activeRoute={activeRoute}
          onNavigate={route => setActiveRoute(route)}
          onLogout={handleLogout}
          onOpenAddPet={() => setIsAddPetOpen(true)}
        />
      )}

      {/* Reusable Modals */}
      <AddPetModal
        isOpen={isAddPetOpen}
        onClose={() => setIsAddPetOpen(false)}
        onAddPet={handleAddPet}
      />

      <AddReminderModal
        isOpen={isAddReminderOpen}
        onClose={() => setIsAddReminderOpen(false)}
        pets={pets}
        onAddReminder={handleAddReminder}
        defaultPetId={selectedPetId}
      />

      <AddAppointmentModal
        isOpen={isAddApptOpen}
        onClose={() => setIsAddApptOpen(false)}
        pets={pets}
        onAddAppointment={handleAddAppointment}
        defaultPetId={selectedPetId}
      />

      <AddHealthRecordModal
        isOpen={isAddHealthOpen}
        onClose={() => setIsAddHealthOpen(false)}
        pets={pets}
        onAddRecord={handleAddHealthRecord}
        defaultPetId={selectedPetId}
      />
    </div>
  );
}
