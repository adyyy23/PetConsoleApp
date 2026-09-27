import React, { useState, useEffect } from 'react';
import {
  PawPrint,
  HeartPulse,
  Calendar,
  Bell,
  Clock,
  Plus,
  Trash2,
  CheckCircle,
  AlertCircle,
  FileText,
  Search,
  Users,
  Menu,
  X,
  ShieldCheck,
  Activity,
  Check
} from 'lucide-react';
import {
  Pet,
  Reminder,
  Appointment,
  AdoptionRecord,
  HealthRecord,
  AppNotification
} from './types';
import {
  INITIAL_PETS,
  INITIAL_REMINDERS,
  INITIAL_APPOINTMENTS,
  INITIAL_ADOPTIONS,
  INITIAL_HEALTH_RECORDS,
  INITIAL_NOTIFICATIONS
} from './mockData';

export default function App() {
  // Navigation
  const [activeTab, setActiveTab] = useState<'dashboard' | 'pets' | 'reminders' | 'appointments' | 'adoptions' | 'health'>('dashboard');
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  // Data State with LocalStorage Persistence
  const [pets, setPets] = useState<Pet[]>(() => {
    const saved = localStorage.getItem('petconsole_pets');
    return saved ? JSON.parse(saved) : INITIAL_PETS;
  });

  const [reminders, setReminders] = useState<Reminder[]>(() => {
    const saved = localStorage.getItem('petconsole_reminders');
    return saved ? JSON.parse(saved) : INITIAL_REMINDERS;
  });

  const [appointments, setAppointments] = useState<Appointment[]>(() => {
    const saved = localStorage.getItem('petconsole_appointments');
    return saved ? JSON.parse(saved) : INITIAL_APPOINTMENTS;
  });

  const [adoptions, setAdoptions] = useState<AdoptionRecord[]>(() => {
    const saved = localStorage.getItem('petconsole_adoptions');
    return saved ? JSON.parse(saved) : INITIAL_ADOPTIONS;
  });

  const [healthRecords, setHealthRecords] = useState<HealthRecord[]>(() => {
    const saved = localStorage.getItem('petconsole_health');
    return saved ? JSON.parse(saved) : INITIAL_HEALTH_RECORDS;
  });

  const [notifications, setNotifications] = useState<AppNotification[]>(() => {
    const saved = localStorage.getItem('petconsole_notifs');
    return saved ? JSON.parse(saved) : INITIAL_NOTIFICATIONS;
  });

  // Search & Filter
  const [searchQuery, setSearchQuery] = useState('');
  const [speciesFilter, setSpeciesFilter] = useState<string>('All');
  const [reminderCategoryFilter, setReminderCategoryFilter] = useState<string>('All');

  // Modals
  const [isAddPetModalOpen, setIsAddPetModalOpen] = useState(false);
  const [isAddReminderModalOpen, setIsAddReminderModalOpen] = useState(false);
  const [isAddApptModalOpen, setIsAddApptModalOpen] = useState(false);
  const [isNotificationOpen, setIsNotificationOpen] = useState(false);
  const [selectedPet, setSelectedPet] = useState<Pet | null>(null);

  // New Pet Form State
  const [newPetName, setNewPetName] = useState('');
  const [newPetType, setNewPetType] = useState<'Dog' | 'Cat' | 'Rabbit' | 'Bird' | 'Other'>('Dog');
  const [newPetBreed, setNewPetBreed] = useState('');
  const [newPetAge, setNewPetAge] = useState(1);
  const [newPetCategory, setNewPetCategory] = useState<'Companion' | 'Service' | 'Rescue' | 'Foster'>('Companion');
  const [newPetDisease, setNewPetDisease] = useState('');
  const [newPetWeight, setNewPetWeight] = useState(5.0);

  // New Reminder Form State
  const [newReminderPetId, setNewReminderPetId] = useState(1);
  const [newReminderCategory, setNewReminderCategory] = useState<'Vaccination' | 'Medication' | 'Feeding' | 'Grooming' | 'Vet Visit' | 'Exercise'>('Medication');
  const [newReminderPriority, setNewReminderPriority] = useState<'High' | 'Medium' | 'Low'>('Medium');
  const [newReminderDate, setNewReminderDate] = useState('2026-09-29');
  const [newReminderTime, setNewReminderTime] = useState('09:00 AM');
  const [newReminderText, setNewReminderText] = useState('');

  // Sync to LocalStorage
  useEffect(() => {
    localStorage.setItem('petconsole_pets', JSON.stringify(pets));
  }, [pets]);

  useEffect(() => {
    localStorage.setItem('petconsole_reminders', JSON.stringify(reminders));
  }, [reminders]);

  useEffect(() => {
    localStorage.setItem('petconsole_appointments', JSON.stringify(appointments));
  }, [appointments]);

  useEffect(() => {
    localStorage.setItem('petconsole_adoptions', JSON.stringify(adoptions));
  }, [adoptions]);

  useEffect(() => {
    localStorage.setItem('petconsole_health', JSON.stringify(healthRecords));
  }, [healthRecords]);

  // Actions
  const handleToggleReminder = (id: number) => {
    setReminders(prev => prev.map(r => r.id === id ? { ...r, completed: !r.completed } : r));
  };

  const handleDeleteReminder = (id: number) => {
    setReminders(prev => prev.filter(r => r.id !== id));
  };

  const handleDeletePet = (id: number) => {
    if (confirm('Are you sure you want to remove this pet profile?')) {
      setPets(prev => prev.filter(p => p.id !== id));
      setReminders(prev => prev.filter(r => r.petId !== id));
      setAppointments(prev => prev.filter(a => a.petId !== id));
      if (selectedPet?.id === id) setSelectedPet(null);
    }
  };

  const handleCreatePet = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newPetName.trim()) return;

    const newPet: Pet = {
      id: Date.now(),
      name: newPetName.trim(),
      animalType: newPetType,
      breed: newPetBreed.trim() || 'Mixed',
      age: Number(newPetAge),
      category: newPetCategory,
      lastCheckup: new Date().toISOString().split('T')[0],
      lastVaccination: new Date().toISOString().split('T')[0],
      disease: newPetDisease.trim() || 'None reported',
      weightKg: Number(newPetWeight),
      gender: 'Male',
      avatarBg: '#dbeafe',
      availableForAdoption: newPetCategory === 'Rescue'
    };

    setPets([newPet, ...pets]);
    setNewPetName('');
    setNewPetBreed('');
    setNewPetDisease('');
    setIsAddPetModalOpen(false);
  };

  const handleCreateReminder = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newReminderText.trim()) return;

    const newRem: Reminder = {
      id: Date.now(),
      petId: Number(newReminderPetId),
      scheduleDate: newReminderDate,
      time: newReminderTime,
      suggestion: newReminderText.trim(),
      priority: newReminderPriority,
      category: newReminderCategory,
      completed: false
    };

    setReminders([newRem, ...reminders]);
    setNewReminderText('');
    setIsAddReminderModalOpen(false);
  };

  const handleMarkAllNotifsRead = () => {
    setNotifications(prev => prev.map(n => ({ ...n, read: true })));
  };

  // Filtered Lists
  const filteredPets = pets.filter(p => {
    const matchesSearch = p.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          p.breed.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesSpecies = speciesFilter === 'All' || p.animalType === speciesFilter;
    return matchesSearch && matchesSpecies;
  });

  const filteredReminders = reminders.filter(r => {
    const matchesCat = reminderCategoryFilter === 'All' || r.category === reminderCategoryFilter;
    return matchesCat;
  });

  const unreadNotifCount = notifications.filter(n => !n.read).length;

  return (
    <div className="app-container">
      {/* Sidebar */}
      <aside className={`app-sidebar ${mobileMenuOpen ? 'open' : ''}`}>
        <div className="sidebar-header">
          <div className="logo-icon-box">
            <PawPrint style={{ width: 22, height: 22 }} />
          </div>
          <div>
            <div className="logo-text-title">PetConsole</div>
            <div className="logo-text-sub">Clinical & Care Care Hub</div>
          </div>
        </div>

        <nav className="sidebar-menu">
          <button
            className={`sidebar-link ${activeTab === 'dashboard' ? 'active' : ''}`}
            onClick={() => { setActiveTab('dashboard'); setMobileMenuOpen(false); }}
          >
            <Activity style={{ width: 18, height: 18 }} />
            <span>Dashboard</span>
          </button>

          <button
            className={`sidebar-link ${activeTab === 'pets' ? 'active' : ''}`}
            onClick={() => { setActiveTab('pets'); setMobileMenuOpen(false); }}
          >
            <PawPrint style={{ width: 18, height: 18 }} />
            <span>Pet Profiles</span>
            <span className="sidebar-badge">{pets.length}</span>
          </button>

          <button
            className={`sidebar-link ${activeTab === 'reminders' ? 'active' : ''}`}
            onClick={() => { setActiveTab('reminders'); setMobileMenuOpen(false); }}
          >
            <Clock style={{ width: 18, height: 18 }} />
            <span>Care Reminders</span>
            <span className="sidebar-badge">{reminders.filter(r => !r.completed).length}</span>
          </button>

          <button
            className={`sidebar-link ${activeTab === 'appointments' ? 'active' : ''}`}
            onClick={() => { setActiveTab('appointments'); setMobileMenuOpen(false); }}
          >
            <Calendar style={{ width: 18, height: 18 }} />
            <span>Vet Appointments</span>
            <span className="sidebar-badge">{appointments.filter(a => a.status === 'Scheduled').length}</span>
          </button>

          <button
            className={`sidebar-link ${activeTab === 'health' ? 'active' : ''}`}
            onClick={() => { setActiveTab('health'); setMobileMenuOpen(false); }}
          >
            <HeartPulse style={{ width: 18, height: 18 }} />
            <span>Clinical Records</span>
          </button>

          <button
            className={`sidebar-link ${activeTab === 'adoptions' ? 'active' : ''}`}
            onClick={() => { setActiveTab('adoptions'); setMobileMenuOpen(false); }}
          >
            <Users style={{ width: 18, height: 18 }} />
            <span>Adoptions</span>
            <span className="sidebar-badge">{pets.filter(p => p.availableForAdoption).length}</span>
          </button>
        </nav>

        <div className="sidebar-footer">
          <div>PetConsole App v2.0 • Web Edition</div>
          <div style={{ fontSize: '0.7rem', color: '#a8a29e', marginTop: 4 }}>Connected Database: Local Storage Engine</div>
        </div>
      </aside>

      {/* Main Container */}
      <div className="app-main">
        {/* Top Header */}
        <header className="top-header">
          <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
            <button
              className="mobile-menu-btn"
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              aria-label="Toggle menu"
            >
              {mobileMenuOpen ? <X style={{ width: 20, height: 20 }} /> : <Menu style={{ width: 20, height: 20 }} />}
            </button>
            <div style={{ display: 'flex', alignItems: 'center', background: 'var(--bg-subtle)', borderRadius: 8, padding: '6px 12px', border: '1px solid var(--border-color)', width: 280 }}>
              <Search style={{ width: 16, height: 16, color: 'var(--text-muted)', marginRight: 8 }} />
              <input
                type="text"
                placeholder="Search pets, breeds, reminders..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                style={{ border: 'none', background: 'transparent', outline: 'none', width: '100%', fontSize: '0.875rem' }}
              />
            </div>
          </div>

          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <button
              className="btn btn-secondary btn-sm"
              onClick={() => setIsNotificationOpen(!isNotificationOpen)}
              style={{ position: 'relative' }}
            >
              <Bell style={{ width: 16, height: 16 }} />
              {unreadNotifCount > 0 && (
                <span style={{ position: 'absolute', top: -3, right: -3, background: 'var(--accent-rose)', color: '#fff', fontSize: '0.625rem', fontWeight: 700, borderRadius: 9999, width: 16, height: 16, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                  {unreadNotifCount}
                </span>
              )}
            </button>
            <button className="btn btn-primary btn-sm" onClick={() => setIsAddPetModalOpen(true)}>
              <Plus style={{ width: 16, height: 16 }} />
              <span>Add Pet</span>
            </button>
          </div>
        </header>

        {/* Notifications Dropdown Panel */}
        {isNotificationOpen && (
          <div style={{ position: 'absolute', top: 72, right: 32, width: 340, background: 'var(--bg-surface)', border: '1px solid var(--border-color)', borderRadius: 'var(--radius-lg)', boxShadow: 'var(--shadow-lg)', zIndex: 200, padding: 16 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12, borderBottom: '1px solid var(--border-color)', paddingBottom: 8 }}>
              <span style={{ fontWeight: 700, fontSize: '0.875rem' }}>Notifications ({unreadNotifCount} unread)</span>
              <button onClick={handleMarkAllNotifsRead} style={{ fontSize: '0.75rem', color: 'var(--primary)', fontWeight: 600 }}>Mark all read</button>
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 8, maxHeight: 300, overflowY: 'auto' }}>
              {notifications.map(n => (
                <div key={n.id} style={{ padding: '8px 10px', borderRadius: 'var(--radius-sm)', background: n.read ? 'transparent' : 'var(--primary-light)', border: '1px solid var(--border-subtle)', fontSize: '0.8125rem' }}>
                  <div style={{ fontWeight: 600, color: 'var(--text-primary)' }}>{n.title}</div>
                  <div style={{ color: 'var(--text-secondary)', fontSize: '0.75rem', marginTop: 2 }}>{n.description}</div>
                  <div style={{ color: 'var(--text-muted)', fontSize: '0.6875rem', marginTop: 4 }}>{n.timestamp}</div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Main Content Body */}
        <main className="content-body">
          {/* ========================================================
              TAB: DASHBOARD
              ======================================================== */}
          {activeTab === 'dashboard' && (
            <div>
              <div className="page-title-row">
                <div>
                  <h1 className="page-title">Pet Care Overview</h1>
                  <p className="page-desc">Comprehensive patient records, daily care routines, and clinical schedules.</p>
                </div>
                <div style={{ display: 'flex', gap: 10 }}>
                  <button className="btn btn-secondary" onClick={() => setIsAddReminderModalOpen(true)}>
                    <Clock style={{ width: 16, height: 16 }} />
                    <span>New Reminder</span>
                  </button>
                  <button className="btn btn-primary" onClick={() => setIsAddPetModalOpen(true)}>
                    <Plus style={{ width: 16, height: 16 }} />
                    <span>Register Pet</span>
                  </button>
                </div>
              </div>

              {/* Stats Cards */}
              <div className="stats-cards-row">
                <div className="stat-item-card" style={{ borderLeft: '4px solid var(--primary)' }}>
                  <div className="stat-header">
                    <span>Registered Pets</span>
                    <PawPrint style={{ width: 20, height: 20, color: 'var(--primary)' }} />
                  </div>
                  <div className="stat-num">{pets.length}</div>
                  <div className="stat-subtext">Active animal profiles under care</div>
                </div>

                <div className="stat-item-card">
                  <div className="stat-header">
                    <span>Pending Tasks</span>
                    <Clock style={{ width: 20, height: 20, color: 'var(--accent-amber)' }} />
                  </div>
                  <div className="stat-num">{reminders.filter(r => !r.completed).length}</div>
                  <div className="stat-subtext">Medication, feeding & grooming routines</div>
                </div>

                <div className="stat-item-card">
                  <div className="stat-header">
                    <span>Scheduled Appointments</span>
                    <Calendar style={{ width: 20, height: 20, color: 'var(--accent-blue)' }} />
                  </div>
                  <div className="stat-num">{appointments.filter(a => a.status === 'Scheduled').length}</div>
                  <div className="stat-subtext">Veterinary clinical consultations</div>
                </div>

                <div className="stat-item-card">
                  <div className="stat-header">
                    <span>Available For Adoption</span>
                    <ShieldCheck style={{ width: 20, height: 20, color: 'var(--primary)' }} />
                  </div>
                  <div className="stat-num">{pets.filter(p => p.availableForAdoption).length}</div>
                  <div className="stat-subtext">Rescue & foster animals looking for homes</div>
                </div>
              </div>

              {/* Two Column Grid: Today's Tasks & Pets Overview */}
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(380px, 1fr))', gap: 24 }}>
                {/* Reminders Card */}
                <div className="table-card" style={{ padding: 24 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16, borderBottom: '1px solid var(--border-color)', paddingBottom: 12 }}>
                    <div>
                      <h3 style={{ fontSize: '1.0625rem', fontWeight: 700 }}>Upcoming Care Schedule</h3>
                      <p style={{ fontSize: '0.8125rem', color: 'var(--text-muted)' }}>Tasks due today and upcoming week</p>
                    </div>
                    <button className="btn btn-secondary btn-sm" onClick={() => setActiveTab('reminders')}>
                      View All
                    </button>
                  </div>

                  <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
                    {reminders.slice(0, 4).map(rem => {
                      const pet = pets.find(p => p.id === rem.petId);
                      return (
                        <div
                          key={rem.id}
                          style={{
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'space-between',
                            padding: '10px 14px',
                            borderRadius: 'var(--radius-md)',
                            border: '1px solid var(--border-color)',
                            background: rem.completed ? 'var(--bg-subtle)' : 'var(--bg-surface)'
                          }}
                        >
                          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                            <button
                              onClick={() => handleToggleReminder(rem.id)}
                              style={{
                                width: 22,
                                height: 22,
                                borderRadius: 4,
                                border: '1.5px solid var(--border-color)',
                                background: rem.completed ? 'var(--primary)' : 'var(--bg-surface)',
                                color: '#fff',
                                display: 'flex',
                                alignItems: 'center',
                                justifyContent: 'center'
                              }}
                              aria-label="Toggle completed"
                            >
                              {rem.completed && <Check style={{ width: 14, height: 14 }} />}
                            </button>
                            <div>
                              <div style={{ fontSize: '0.875rem', fontWeight: 600, textDecoration: rem.completed ? 'line-through' : 'none', color: rem.completed ? 'var(--text-muted)' : 'var(--text-primary)' }}>
                                {rem.suggestion}
                              </div>
                              <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>
                                {pet ? pet.name : 'Unknown Pet'} • {rem.category} • Due: {rem.scheduleDate} at {rem.time}
                              </div>
                            </div>
                          </div>
                          <span className={`badge ${rem.priority === 'High' ? 'badge-rose' : rem.priority === 'Medium' ? 'badge-amber' : 'badge-blue'}`}>
                            {rem.priority}
                          </span>
                        </div>
                      );
                    })}
                  </div>
                </div>

                {/* Recent Clinical Records Card */}
                <div className="table-card" style={{ padding: 24 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16, borderBottom: '1px solid var(--border-color)', paddingBottom: 12 }}>
                    <div>
                      <h3 style={{ fontSize: '1.0625rem', fontWeight: 700 }}>Recent Health History</h3>
                      <p style={{ fontSize: '0.8125rem', color: 'var(--text-muted)' }}>Clinical treatments & vaccinations</p>
                    </div>
                    <button className="btn btn-secondary btn-sm" onClick={() => setActiveTab('health')}>
                      Full Records
                    </button>
                  </div>

                  <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
                    {healthRecords.map(rec => {
                      const pet = pets.find(p => p.id === rec.petId);
                      return (
                        <div key={rec.id} style={{ padding: '12px 14px', borderRadius: 'var(--radius-md)', background: 'var(--bg-subtle)', border: '1px solid var(--border-subtle)' }}>
                          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 4 }}>
                            <span style={{ fontWeight: 700, fontSize: '0.875rem' }}>{rec.title}</span>
                            <span className="badge badge-emerald">{rec.type}</span>
                          </div>
                          <div style={{ fontSize: '0.8125rem', color: 'var(--text-secondary)', lineHeight: 1.4 }}>
                            {rec.notes}
                          </div>
                          <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)', marginTop: 6, display: 'flex', justifyContent: 'space-between' }}>
                            <span>Patient: <strong>{pet?.name}</strong></span>
                            <span>{rec.veterinarian} • {rec.date}</span>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* ========================================================
              TAB: PETS DIRECTORY
              ======================================================== */}
          {activeTab === 'pets' && (
            <div>
              <div className="page-title-row">
                <div>
                  <h1 className="page-title">Pet Directory & Profiles</h1>
                  <p className="page-desc">Manage companion animals, physical parameters, allergies, and vaccination status.</p>
                </div>
                <button className="btn btn-primary" onClick={() => setIsAddPetModalOpen(true)}>
                  <Plus style={{ width: 16, height: 16 }} />
                  <span>Register New Pet</span>
                </button>
              </div>

              {/* Species Filter Tabs */}
              <div style={{ display: 'flex', gap: 8, marginBottom: 20, flexWrap: 'wrap' }}>
                {['All', 'Dog', 'Cat', 'Rabbit', 'Bird'].map(species => (
                  <button
                    key={species}
                    className={`btn btn-sm ${speciesFilter === species ? 'btn-primary' : 'btn-secondary'}`}
                    onClick={() => setSpeciesFilter(species)}
                  >
                    {species}
                  </button>
                ))}
              </div>

              {/* Pets Grid */}
              {filteredPets.length === 0 ? (
                <div className="table-card empty-view">
                  <div className="empty-view-icon">
                    <PawPrint style={{ width: 24, height: 24 }} />
                  </div>
                  <div className="empty-view-title">No Pets Found</div>
                  <div className="empty-view-desc">No pets match the current filter or search criteria.</div>
                  <button className="btn btn-secondary btn-sm" onClick={() => { setSpeciesFilter('All'); setSearchQuery(''); }}>
                    Reset Filters
                  </button>
                </div>
              ) : (
                <div className="pets-grid">
                  {filteredPets.map(pet => (
                    <div key={pet.id} className="pet-card">
                      <div>
                        <div className="pet-top-info">
                          <div className="pet-avatar-circle" style={{ backgroundColor: pet.avatarBg }}>
                            <PawPrint style={{ width: 26, height: 26, color: 'var(--text-primary)' }} />
                          </div>
                          <div>
                            <div className="pet-name">{pet.name}</div>
                            <div className="pet-species-breed">{pet.animalType} • {pet.breed}</div>
                          </div>
                          <span className="badge badge-emerald" style={{ marginLeft: 'auto' }}>{pet.category}</span>
                        </div>

                        <div className="pet-detail-rows">
                          <div className="detail-row">
                            <span className="detail-label">Age & Weight</span>
                            <span className="detail-val">{pet.age} years • {pet.weightKg} kg</span>
                          </div>
                          <div className="detail-row">
                            <span className="detail-label">Gender</span>
                            <span className="detail-val">{pet.gender}</span>
                          </div>
                          <div className="detail-row">
                            <span className="detail-label">Last Checkup</span>
                            <span className="detail-val">{pet.lastCheckup}</span>
                          </div>
                          <div className="detail-row">
                            <span className="detail-label">Last Vaccination</span>
                            <span className="detail-val">{pet.lastVaccination}</span>
                          </div>
                          <div className="detail-row">
                            <span className="detail-label">Medical Notes</span>
                            <span className="detail-val" style={{ color: pet.disease !== 'None reported' ? 'var(--accent-amber)' : 'inherit' }}>
                              {pet.disease}
                            </span>
                          </div>
                        </div>
                      </div>

                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', paddingTop: 8 }}>
                        <button
                          className="btn btn-secondary btn-sm"
                          onClick={() => setSelectedPet(pet)}
                        >
                          <FileText style={{ width: 14, height: 14 }} />
                          <span>View Details</span>
                        </button>
                        <button
                          className="btn btn-sm btn-secondary"
                          onClick={() => handleDeletePet(pet.id)}
                          title="Delete pet profile"
                          style={{ color: 'var(--accent-rose)' }}
                        >
                          <Trash2 style={{ width: 14, height: 14 }} />
                        </button>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}

          {/* ========================================================
              TAB: REMINDERS & TASKS
              ======================================================== */}
          {activeTab === 'reminders' && (
            <div>
              <div className="page-title-row">
                <div>
                  <h1 className="page-title">Pet Care Reminders & Tasks</h1>
                  <p className="page-desc">Track feeding schedules, medications, vaccination boosters, and grooming.</p>
                </div>
                <button className="btn btn-primary" onClick={() => setIsAddReminderModalOpen(true)}>
                  <Plus style={{ width: 16, height: 16 }} />
                  <span>Create Reminder</span>
                </button>
              </div>

              {/* Category Filter */}
              <div style={{ display: 'flex', gap: 8, marginBottom: 20, flexWrap: 'wrap' }}>
                {['All', 'Medication', 'Feeding', 'Grooming', 'Vaccination', 'Exercise'].map(cat => (
                  <button
                    key={cat}
                    className={`btn btn-sm ${reminderCategoryFilter === cat ? 'btn-primary' : 'btn-secondary'}`}
                    onClick={() => setReminderCategoryFilter(cat)}
                  >
                    {cat}
                  </button>
                ))}
              </div>

              <div className="table-card">
                <div className="table-wrap">
                  <table className="clean-table">
                    <thead>
                      <tr>
                        <th style={{ width: 50 }}>Status</th>
                        <th>Pet Name</th>
                        <th>Category</th>
                        <th>Care Instructions / Suggestion</th>
                        <th>Schedule Date</th>
                        <th>Priority</th>
                        <th style={{ textAlign: 'right' }}>Actions</th>
                      </tr>
                    </thead>
                    <tbody>
                      {filteredReminders.map(rem => {
                        const pet = pets.find(p => p.id === rem.petId);
                        return (
                          <tr key={rem.id}>
                            <td>
                              <button
                                onClick={() => handleToggleReminder(rem.id)}
                                style={{
                                  width: 22,
                                  height: 22,
                                  borderRadius: 4,
                                  border: '1.5px solid var(--border-color)',
                                  background: rem.completed ? 'var(--primary)' : 'var(--bg-surface)',
                                  color: '#fff',
                                  display: 'flex',
                                  alignItems: 'center',
                                  justifyContent: 'center'
                                }}
                                aria-label="Toggle status"
                              >
                                {rem.completed && <Check style={{ width: 14, height: 14 }} />}
                              </button>
                            </td>
                            <td>
                              <strong>{pet ? pet.name : 'Unknown Pet'}</strong>
                              <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>{pet?.breed}</div>
                            </td>
                            <td><span className="badge badge-blue">{rem.category}</span></td>
                            <td style={{ maxWidth: 360, textDecoration: rem.completed ? 'line-through' : 'none', color: rem.completed ? 'var(--text-muted)' : 'inherit' }}>
                              {rem.suggestion}
                            </td>
                            <td>
                              {rem.scheduleDate}
                              <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>{rem.time}</div>
                            </td>
                            <td>
                              <span className={`badge ${rem.priority === 'High' ? 'badge-rose' : rem.priority === 'Medium' ? 'badge-amber' : 'badge-emerald'}`}>
                                {rem.priority}
                              </span>
                            </td>
                            <td style={{ textAlign: 'right' }}>
                              <button
                                className="btn btn-sm btn-secondary"
                                onClick={() => handleDeleteReminder(rem.id)}
                                title="Delete reminder"
                                style={{ color: 'var(--accent-rose)' }}
                              >
                                <Trash2 style={{ width: 14, height: 14 }} />
                              </button>
                            </td>
                          </tr>
                        );
                      })}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          )}

          {/* ========================================================
              TAB: VET APPOINTMENTS
              ======================================================== */}
          {activeTab === 'appointments' && (
            <div>
              <div className="page-title-row">
                <div>
                  <h1 className="page-title">Veterinary Appointments</h1>
                  <p className="page-desc">Schedule and track clinical visits, annual vaccinations, and diagnostics.</p>
                </div>
                <button className="btn btn-primary" onClick={() => setIsAddApptModalOpen(true)}>
                  <Plus style={{ width: 16, height: 16 }} />
                  <span>Book Consultation</span>
                </button>
              </div>

              <div className="table-card">
                <div className="table-wrap">
                  <table className="clean-table">
                    <thead>
                      <tr>
                        <th>Pet</th>
                        <th>Clinic & Doctor</th>
                        <th>Appointment Date</th>
                        <th>Purpose of Visit</th>
                        <th>Status</th>
                        <th style={{ textAlign: 'right' }}>Actions</th>
                      </tr>
                    </thead>
                    <tbody>
                      {appointments.map(appt => {
                        const pet = pets.find(p => p.id === appt.petId);
                        return (
                          <tr key={appt.id}>
                            <td>
                              <strong>{pet?.name}</strong>
                              <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>{pet?.animalType}</div>
                            </td>
                            <td>
                              <strong>{appt.vetName}</strong>
                              <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>{appt.clinic}</div>
                            </td>
                            <td>
                              {appt.appointmentDate}
                              <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>{appt.time}</div>
                            </td>
                            <td>
                              <span className="badge badge-blue">{appt.purpose}</span>
                            </td>
                            <td>
                              <span className={`badge ${appt.status === 'Completed' ? 'badge-emerald' : 'badge-amber'}`}>
                                {appt.status}
                              </span>
                            </td>
                            <td style={{ textAlign: 'right' }}>
                              {appt.status === 'Scheduled' && (
                                <button
                                  className="btn btn-sm btn-secondary"
                                  onClick={() => {
                                    setAppointments(prev => prev.map(a => a.id === appt.id ? { ...a, status: 'Completed' } : a));
                                  }}
                                >
                                  Mark Completed
                                </button>
                              )}
                            </td>
                          </tr>
                        );
                      })}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          )}

          {/* ========================================================
              TAB: CLINICAL HEALTH RECORDS
              ======================================================== */}
          {activeTab === 'health' && (
            <div>
              <div className="page-title-row">
                <div>
                  <h1 className="page-title">Clinical Health Records</h1>
                  <p className="page-desc">Immunization logs, checkup summaries, and prescription dosages.</p>
                </div>
              </div>

              <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
                {healthRecords.map(rec => {
                  const pet = pets.find(p => p.id === rec.petId);
                  return (
                    <div key={rec.id} className="table-card" style={{ padding: 24 }}>
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                          <span className="badge badge-emerald">{rec.type}</span>
                          <h3 style={{ fontSize: '1.125rem', fontWeight: 700 }}>{rec.title}</h3>
                        </div>
                        <span style={{ fontSize: '0.8125rem', color: 'var(--text-muted)' }}>{rec.date}</span>
                      </div>
                      <p style={{ fontSize: '0.875rem', color: 'var(--text-secondary)', lineHeight: 1.6, marginBottom: 16 }}>
                        {rec.notes}
                      </p>
                      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.75rem', color: 'var(--text-muted)', borderTop: '1px solid var(--border-subtle)', paddingTop: 12 }}>
                        <span>Patient: <strong>{pet?.name} ({pet?.breed})</strong></span>
                        <span>Authorized Veterinarian: <strong>{rec.veterinarian}</strong></span>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {/* ========================================================
              TAB: ADOPTIONS MANAGEMENT (From Java AdoptionRecord)
              ======================================================== */}
          {activeTab === 'adoptions' && (
            <div>
              <div className="page-title-row">
                <div>
                  <h1 className="page-title">Adoption & Foster Management</h1>
                  <p className="page-desc">Shelter rescue tracking, adoption status, and caretaker placement records.</p>
                </div>
              </div>

              <div className="table-card">
                <div className="table-wrap">
                  <table className="clean-table">
                    <thead>
                      <tr>
                        <th>Pet Name</th>
                        <th>Breed / Type</th>
                        <th>Availability</th>
                        <th>Background & History</th>
                        <th>Status</th>
                      </tr>
                    </thead>
                    <tbody>
                      {adoptions.map(ad => {
                        const pet = pets.find(p => p.id === ad.petId);
                        return (
                          <tr key={ad.id}>
                            <td>
                              <strong>{pet?.name}</strong>
                              <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>ID #{ad.petId}</div>
                            </td>
                            <td>{pet?.animalType} • {pet?.breed}</td>
                            <td>
                              <span className={`badge ${ad.availableForAdoption ? 'badge-emerald' : 'badge-amber'}`}>
                                {ad.availableForAdoption ? 'Yes' : 'No'}
                              </span>
                            </td>
                            <td style={{ maxWidth: 400 }}>
                              {ad.adoptionHistory}
                              {ad.adopterName && (
                                <div style={{ fontSize: '0.75rem', color: 'var(--primary)', marginTop: 4 }}>
                                  Adopter: {ad.adopterName}
                                </div>
                              )}
                            </td>
                            <td>
                              <span className={`badge ${ad.status === 'Available' ? 'badge-emerald' : 'badge-amber'}`}>
                                {ad.status}
                              </span>
                            </td>
                          </tr>
                        );
                      })}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          )}
        </main>
      </div>

      {/* ============================================================
          MODAL: ADD NEW PET
          ============================================================ */}
      {isAddPetModalOpen && (
        <div className="modal-overlay" onClick={() => setIsAddPetModalOpen(false)}>
          <div className="modal-card" onClick={e => e.stopPropagation()}>
            <div className="modal-header">
              <h2 className="modal-title">Register New Pet Profile</h2>
              <button onClick={() => setIsAddPetModalOpen(false)} style={{ color: 'var(--text-muted)' }}>
                <X style={{ width: 20, height: 20 }} />
              </button>
            </div>

            <form onSubmit={handleCreatePet}>
              <div className="form-group">
                <label>Pet Name *</label>
                <input
                  type="text"
                  required
                  className="form-control"
                  placeholder="e.g. Mochi, Charlie"
                  value={newPetName}
                  onChange={e => setNewPetName(e.target.value)}
                />
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
                <div className="form-group">
                  <label>Species *</label>
                  <select
                    className="form-control"
                    value={newPetType}
                    onChange={e => setNewPetType(e.target.value as any)}
                  >
                    <option value="Dog">Dog</option>
                    <option value="Cat">Cat</option>
                    <option value="Rabbit">Rabbit</option>
                    <option value="Bird">Bird</option>
                    <option value="Other">Other</option>
                  </select>
                </div>

                <div className="form-group">
                  <label>Breed</label>
                  <input
                    type="text"
                    className="form-control"
                    placeholder="e.g. Golden Retriever"
                    value={newPetBreed}
                    onChange={e => setNewPetBreed(e.target.value)}
                  />
                </div>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
                <div className="form-group">
                  <label>Age (Years)</label>
                  <input
                    type="number"
                    min="0"
                    max="30"
                    className="form-control"
                    value={newPetAge}
                    onChange={e => setNewPetAge(Number(e.target.value))}
                  />
                </div>

                <div className="form-group">
                  <label>Weight (Kg)</label>
                  <input
                    type="number"
                    step="0.1"
                    min="0.1"
                    className="form-control"
                    value={newPetWeight}
                    onChange={e => setNewPetWeight(Number(e.target.value))}
                  />
                </div>
              </div>

              <div className="form-group">
                <label>Care Category</label>
                <select
                  className="form-control"
                  value={newPetCategory}
                  onChange={e => setNewPetCategory(e.target.value as any)}
                >
                  <option value="Companion">Companion</option>
                  <option value="Rescue">Rescue / Shelter</option>
                  <option value="Foster">Foster</option>
                  <option value="Service">Service Animal</option>
                </select>
              </div>

              <div className="form-group">
                <label>Known Allergies / Disease</label>
                <input
                  type="text"
                  className="form-control"
                  placeholder="e.g. Seasonal allergy, None"
                  value={newPetDisease}
                  onChange={e => setNewPetDisease(e.target.value)}
                />
              </div>

              <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 10, marginTop: 24 }}>
                <button type="button" className="btn btn-secondary" onClick={() => setIsAddPetModalOpen(false)}>
                  Cancel
                </button>
                <button type="submit" className="btn btn-primary">
                  Save Pet Profile
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ============================================================
          MODAL: ADD REMINDER
          ============================================================ */}
      {isAddReminderModalOpen && (
        <div className="modal-overlay" onClick={() => setIsAddReminderModalOpen(false)}>
          <div className="modal-card" onClick={e => e.stopPropagation()}>
            <div className="modal-header">
              <h2 className="modal-title">Schedule Care Reminder</h2>
              <button onClick={() => setIsAddReminderModalOpen(false)} style={{ color: 'var(--text-muted)' }}>
                <X style={{ width: 20, height: 20 }} />
              </button>
            </div>

            <form onSubmit={handleCreateReminder}>
              <div className="form-group">
                <label>Select Pet *</label>
                <select
                  className="form-control"
                  value={newReminderPetId}
                  onChange={e => setNewReminderPetId(Number(e.target.value))}
                >
                  {pets.map(p => (
                    <option key={p.id} value={p.id}>{p.name} ({p.animalType})</option>
                  ))}
                </select>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
                <div className="form-group">
                  <label>Category *</label>
                  <select
                    className="form-control"
                    value={newReminderCategory}
                    onChange={e => setNewReminderCategory(e.target.value as any)}
                  >
                    <option value="Medication">Medication</option>
                    <option value="Feeding">Feeding</option>
                    <option value="Grooming">Grooming</option>
                    <option value="Vaccination">Vaccination</option>
                    <option value="Vet Visit">Vet Visit</option>
                    <option value="Exercise">Exercise</option>
                  </select>
                </div>

                <div className="form-group">
                  <label>Priority *</label>
                  <select
                    className="form-control"
                    value={newReminderPriority}
                    onChange={e => setNewReminderPriority(e.target.value as any)}
                  >
                    <option value="High">High</option>
                    <option value="Medium">Medium</option>
                    <option value="Low">Low</option>
                  </select>
                </div>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
                <div className="form-group">
                  <label>Date *</label>
                  <input
                    type="date"
                    required
                    className="form-control"
                    value={newReminderDate}
                    onChange={e => setNewReminderDate(e.target.value)}
                  />
                </div>

                <div className="form-group">
                  <label>Time</label>
                  <input
                    type="text"
                    className="form-control"
                    placeholder="08:00 AM"
                    value={newReminderTime}
                    onChange={e => setNewReminderTime(e.target.value)}
                  />
                </div>
              </div>

              <div className="form-group">
                <label>Care Instructions / Reminder Text *</label>
                <textarea
                  required
                  rows={3}
                  className="form-control"
                  placeholder="e.g. Dose 10mg antibiotic with breakfast"
                  value={newReminderText}
                  onChange={e => setNewReminderText(e.target.value)}
                />
              </div>

              <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 10, marginTop: 24 }}>
                <button type="button" className="btn btn-secondary" onClick={() => setIsAddReminderModalOpen(false)}>
                  Cancel
                </button>
                <button type="submit" className="btn btn-primary">
                  Set Reminder
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ============================================================
          MODAL: PET DETAIL VIEW
          ============================================================ */}
      {selectedPet && (
        <div className="modal-overlay" onClick={() => setSelectedPet(null)}>
          <div className="modal-card" onClick={e => e.stopPropagation()}>
            <div className="modal-header">
              <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                <div className="pet-avatar-circle" style={{ backgroundColor: selectedPet.avatarBg, width: 44, height: 44 }}>
                  <PawPrint style={{ width: 22, height: 22 }} />
                </div>
                <div>
                  <h2 className="modal-title" style={{ fontSize: '1.2rem' }}>{selectedPet.name}</h2>
                  <div style={{ fontSize: '0.8rem', color: 'var(--text-muted)' }}>{selectedPet.animalType} • {selectedPet.breed}</div>
                </div>
              </div>
              <button onClick={() => setSelectedPet(null)} style={{ color: 'var(--text-muted)' }}>
                <X style={{ width: 20, height: 20 }} />
              </button>
            </div>

            <div className="pet-detail-rows" style={{ margin: 0, paddingBottom: 16 }}>
              <div className="detail-row">
                <span className="detail-label">Care Category</span>
                <span className="badge badge-emerald">{selectedPet.category}</span>
              </div>
              <div className="detail-row">
                <span className="detail-label">Age</span>
                <span className="detail-val">{selectedPet.age} years old</span>
              </div>
              <div className="detail-row">
                <span className="detail-label">Weight</span>
                <span className="detail-val">{selectedPet.weightKg} kg</span>
              </div>
              <div className="detail-row">
                <span className="detail-label">Gender</span>
                <span className="detail-val">{selectedPet.gender}</span>
              </div>
              <div className="detail-row">
                <span className="detail-label">Last Physical Checkup</span>
                <span className="detail-val">{selectedPet.lastCheckup}</span>
              </div>
              <div className="detail-row">
                <span className="detail-label">Last Vaccination Date</span>
                <span className="detail-val">{selectedPet.lastVaccination}</span>
              </div>
              <div className="detail-row">
                <span className="detail-label">Chronic Conditions / Allergies</span>
                <span className="detail-val">{selectedPet.disease}</span>
              </div>
            </div>

            <div style={{ marginTop: 20, display: 'flex', justifyContent: 'flex-end', gap: 10 }}>
              <button className="btn btn-secondary" onClick={() => setSelectedPet(null)}>
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
