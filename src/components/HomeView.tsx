import React from 'react';
import {
  Clock,
  Calendar,
  HeartPulse,
  Plus,
  Check,
  ArrowRight,
  ShieldCheck,
  ChevronRight,
  Sparkles,
  MapPin,
  AlertCircle
} from 'lucide-react';
import { Pet, Reminder, Appointment, HealthRecord, User } from '../types';

interface HomeViewProps {
  user: User;
  pets: Pet[];
  activePetId: number;
  onSelectActivePet: (id: number) => void;
  reminders: Reminder[];
  appointments: Appointment[];
  healthRecords: HealthRecord[];
  onToggleReminder: (id: number) => void;
  onNavigate: (route: string, petId?: number) => void;
  onOpenAddReminder: () => void;
  onOpenAddAppointment: () => void;
  onOpenAddPet: () => void;
}

export const HomeView: React.FC<HomeViewProps> = ({
  user,
  pets,
  activePetId,
  onSelectActivePet,
  reminders,
  appointments,
  healthRecords,
  onToggleReminder,
  onNavigate,
  onOpenAddReminder,
  onOpenAddAppointment,
  onOpenAddPet
}) => {
  const activePet = pets.find(p => p.id === activePetId) || pets[0];

  // Filter routines for active pet or today
  const activePetReminders = reminders.filter(r => r.petId === activePet?.id);
  const nextCareItem = activePetReminders.find(r => !r.completed);

  const todayReminders = reminders.filter(r => {
    // Show either due today or incomplete
    return !r.completed;
  });

  const nextAppointment = appointments
    .filter(a => a.status === 'Scheduled' && (activePet ? a.petId === activePet.id : true))
    .sort((a, b) => a.appointmentDate.localeCompare(b.appointmentDate))[0];

  const recentHealth = healthRecords.filter(h => !activePet || h.petId === activePet.id).slice(0, 3);

  // Time of day greeting
  const getGreeting = () => {
    const hour = new Date().getHours();
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  };

  return (
    <div className="app-container">
      {/* Personalized Header Row */}
      <div className="page-header" style={{ marginBottom: 20 }}>
        <div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 4 }}>
            <span style={{ fontSize: '0.8125rem', fontWeight: 700, color: 'var(--primary)', letterSpacing: '0.04em', textTransform: 'uppercase' }}>
              Pet Companion Home
            </span>
          </div>
          <h1 className="page-title">
            {getGreeting()}, {user.name}.
          </h1>
          <p className="page-subtitle">
            How's {activePet ? activePet.name : 'your pet'} doing today?
          </p>
        </div>

        {/* Quick Action Buttons */}
        <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap' }}>
          <button className="btn btn-secondary btn-sm" onClick={onOpenAddReminder}>
            <Clock style={{ width: 14, height: 14, color: 'var(--accent-honey)' }} />
            <span>Add Routine</span>
          </button>
          <button className="btn btn-secondary btn-sm" onClick={onOpenAddAppointment}>
            <Calendar style={{ width: 14, height: 14, color: 'var(--primary)' }} />
            <span>Book Visit</span>
          </button>
          <button className="btn btn-primary btn-sm" onClick={onOpenAddPet}>
            <Plus style={{ width: 14, height: 14 }} />
            <span>Add Pet</span>
          </button>
        </div>
      </div>

      {/* Pet Switcher Row */}
      {pets.length > 1 && (
        <div className="pet-switcher-row">
          <span style={{ fontSize: '0.75rem', fontWeight: 700, color: 'var(--text-muted)', textTransform: 'uppercase', marginRight: 4 }}>
            Pets:
          </span>
          {pets.map(p => (
            <button
              key={p.id}
              className={`pet-pill-btn ${p.id === activePet?.id ? 'active' : ''}`}
              onClick={() => onSelectActivePet(p.id)}
            >
              <img
                src={p.imageUrl || 'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=100&q=80'}
                alt={p.name}
                className="pet-pill-avatar"
              />
              <span>{p.name}</span>
            </button>
          ))}
        </div>
      )}

      {/* Top Visual Hero Card for Active Pet */}
      {activePet && (
        <div className="home-hero-card">
          <div className="pet-hero-portrait">
            <img
              src={activePet.imageUrl || 'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=800&q=80'}
              alt={activePet.name}
            />
            <div className="pet-hero-badge">
              {activePet.category}
            </div>
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 6 }}>
              <h2 style={{ fontSize: '1.875rem', fontWeight: 800, color: 'var(--text-primary)', letterSpacing: '-0.02em' }}>
                {activePet.name}
              </h2>
              <button
                className="btn btn-secondary btn-sm"
                onClick={() => onNavigate('pet-profile', activePet.id)}
              >
                <span>View Full Profile</span>
                <ChevronRight style={{ width: 14, height: 14 }} />
              </button>
            </div>

            <div style={{ fontSize: '0.9375rem', color: 'var(--text-secondary)', marginBottom: 18 }}>
              {activePet.animalType} • {activePet.breed} • {activePet.age} years old • {activePet.weightKg} kg
            </div>

            {/* Next Care Item Highlight */}
            <div
              style={{
                backgroundColor: 'var(--bg-subtle)',
                border: '1px solid var(--border-color)',
                borderRadius: 'var(--radius-md)',
                padding: '16px',
                marginBottom: 16
              }}
            >
              <div style={{ fontSize: '0.75rem', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.05em', color: 'var(--accent-honey)', marginBottom: 6 }}>
                Next Care Routine
              </div>
              {nextCareItem ? (
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12 }}>
                  <div>
                    <div style={{ fontWeight: 700, fontSize: '0.9375rem', color: 'var(--text-primary)' }}>
                      {nextCareItem.suggestion}
                    </div>
                    <div style={{ fontSize: '0.8125rem', color: 'var(--text-muted)', marginTop: 2 }}>
                      {nextCareItem.category} • {nextCareItem.time} ({nextCareItem.scheduleDate})
                    </div>
                  </div>
                  <button
                    className="btn btn-primary btn-sm"
                    onClick={() => onToggleReminder(nextCareItem.id)}
                  >
                    <Check style={{ width: 14, height: 14 }} />
                    <span>Done</span>
                  </button>
                </div>
              ) : (
                <div style={{ fontSize: '0.875rem', color: 'var(--text-secondary)' }}>
                  All scheduled routines for {activePet.name} are complete for today!
                </div>
              )}
            </div>

            {/* Health Notice Chip if allergy/condition */}
            {activePet.disease && activePet.disease !== 'None reported' && (
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: '0.8125rem', color: 'var(--accent-clay)' }}>
                <AlertCircle style={{ width: 16, height: 16, flexShrink: 0 }} />
                <span>Notice: {activePet.disease}</span>
              </div>
            )}
          </div>
        </div>
      )}

      {/* Main Two-Column Layout: Today's Care & Upcoming Events */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(360px, 1fr))', gap: 28 }}>
        {/* Column 1: Today's Care Routine */}
        <div className="pawly-card">
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 18 }}>
            <div>
              <h3 style={{ fontSize: '1.125rem', fontWeight: 800, color: 'var(--text-primary)' }}>
                Today's Care
              </h3>
              <p style={{ fontSize: '0.8125rem', color: 'var(--text-muted)' }}>
                Daily routines, medications, and meals
              </p>
            </div>
            <button className="btn btn-subtle btn-sm" onClick={() => onNavigate('care')}>
              <span>View Agenda</span>
              <ArrowRight style={{ width: 14, height: 14 }} />
            </button>
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            {todayReminders.slice(0, 4).map(rem => {
              const pet = pets.find(p => p.id === rem.petId);
              return (
                <div key={rem.id} className={`routine-item ${rem.completed ? 'completed' : ''}`}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                    <button
                      className={`routine-check-btn ${rem.completed ? 'checked' : ''}`}
                      onClick={() => onToggleReminder(rem.id)}
                      aria-label="Toggle completion"
                    >
                      {rem.completed && <Check style={{ width: 14, height: 14 }} />}
                    </button>
                    <div>
                      <div
                        style={{
                          fontSize: '0.875rem',
                          fontWeight: 600,
                          textDecoration: rem.completed ? 'line-through' : 'none',
                          color: rem.completed ? 'var(--text-muted)' : 'var(--text-primary)'
                        }}
                      >
                        {rem.suggestion}
                      </div>
                      <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)', marginTop: 2 }}>
                        {pet?.name} • {rem.category} • {rem.time}
                      </div>
                    </div>
                  </div>
                  <span className={`badge ${rem.priority === 'High' ? 'badge-rose' : rem.priority === 'Medium' ? 'badge-honey' : 'badge-subtle'}`}>
                    {rem.priority}
                  </span>
                </div>
              );
            })}

            {todayReminders.length === 0 && (
              <div style={{ textAlign: 'center', padding: '24px 12px', color: 'var(--text-muted)', fontSize: '0.875rem' }}>
                No pending care tasks right now. You're all caught up!
              </div>
            )}
          </div>
        </div>

        {/* Column 2: Upcoming Vet Visit & Health Updates */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 24 }}>
          {/* Upcoming Vet Visit Card */}
          <div className="pawly-card">
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 14 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                <Calendar style={{ width: 18, height: 18, color: 'var(--primary)' }} />
                <h3 style={{ fontSize: '1.0625rem', fontWeight: 800, color: 'var(--text-primary)' }}>
                  Upcoming Vet Visit
                </h3>
              </div>
              <button className="btn btn-subtle btn-sm" onClick={() => onNavigate('appointments')}>
                View All
              </button>
            </div>

            {nextAppointment ? (
              <div
                style={{
                  padding: '16px',
                  borderRadius: 'var(--radius-md)',
                  backgroundColor: 'var(--primary-light)',
                  border: '1px solid var(--primary-border)'
                }}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 8 }}>
                  <div>
                    <div style={{ fontWeight: 800, fontSize: '0.9375rem', color: 'var(--text-primary)' }}>
                      {nextAppointment.purpose}
                    </div>
                    <div style={{ fontSize: '0.8125rem', color: 'var(--primary)', fontWeight: 600 }}>
                      Patient: {pets.find(p => p.id === nextAppointment.petId)?.name}
                    </div>
                  </div>
                  <span className="badge badge-sage">
                    {nextAppointment.appointmentDate} · {nextAppointment.time}
                  </span>
                </div>

                <div style={{ fontSize: '0.8125rem', color: 'var(--text-secondary)', display: 'flex', alignItems: 'center', gap: 6 }}>
                  <MapPin style={{ width: 14, height: 14, color: 'var(--primary)' }} />
                  <span>{nextAppointment.clinic} ({nextAppointment.vetName})</span>
                </div>
              </div>
            ) : (
              <div style={{ fontSize: '0.875rem', color: 'var(--text-muted)', padding: '12px 0' }}>
                No visits currently scheduled.
              </div>
            )}
          </div>

          {/* Health Milestones Card */}
          <div className="pawly-card">
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 14 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                <HeartPulse style={{ width: 18, height: 18, color: 'var(--accent-clay)' }} />
                <h3 style={{ fontSize: '1.0625rem', fontWeight: 800, color: 'var(--text-primary)' }}>
                  Recent Health Milestones
                </h3>
              </div>
              <button className="btn btn-subtle btn-sm" onClick={() => onNavigate('health')}>
                History
              </button>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
              {recentHealth.map(rec => {
                const pet = pets.find(p => p.id === rec.petId);
                return (
                  <div
                    key={rec.id}
                    style={{
                      padding: '12px 14px',
                      borderRadius: 'var(--radius-sm)',
                      backgroundColor: 'var(--bg-subtle)',
                      border: '1px solid var(--border-subtle)'
                    }}
                  >
                    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 4 }}>
                      <span style={{ fontWeight: 700, fontSize: '0.875rem', color: 'var(--text-primary)' }}>
                        {rec.title}
                      </span>
                      <span className="badge badge-sage" style={{ fontSize: '0.6875rem' }}>
                        {rec.type}
                      </span>
                    </div>
                    <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>
                      {pet?.name} • {rec.date} • {rec.veterinarian}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
