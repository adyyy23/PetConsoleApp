import React, { useState } from 'react';
import {
  ArrowLeft,
  Clock,
  Calendar,
  HeartPulse,
  AlertCircle,
  FileText,
  Shield,
  Edit2,
  Trash2,
  Check,
  Plus,
  MapPin,
  Sparkles
} from 'lucide-react';
import { Pet, Reminder, Appointment, HealthRecord } from '../types';

interface PetProfileViewProps {
  pet: Pet;
  reminders: Reminder[];
  appointments: Appointment[];
  healthRecords: HealthRecord[];
  onBack: () => void;
  onToggleReminder: (id: number) => void;
  onDeletePet: (petId: number) => void;
  onUpdatePet: (pet: Pet) => void;
  onOpenAddReminder: () => void;
  onOpenAddAppointment: () => void;
  onOpenAddHealthRecord: () => void;
}

export const PetProfileView: React.FC<PetProfileViewProps> = ({
  pet,
  reminders,
  appointments,
  healthRecords,
  onBack,
  onToggleReminder,
  onDeletePet,
  onUpdatePet,
  onOpenAddReminder,
  onOpenAddAppointment,
  onOpenAddHealthRecord
}) => {
  const [activeTab, setActiveTab] = useState<'overview' | 'care' | 'health' | 'appointments' | 'details'>('overview');
  const [isEditing, setIsEditing] = useState(false);

  // Edit states
  const [editName, setEditName] = useState(pet.name);
  const [editBreed, setEditBreed] = useState(pet.breed);
  const [editAge, setEditAge] = useState(pet.age);
  const [editWeight, setEditWeight] = useState(pet.weightKg);
  const [editNotes, setEditNotes] = useState(pet.notes || '');
  const [editDisease, setEditDisease] = useState(pet.disease || '');

  const petReminders = reminders.filter(r => r.petId === pet.id);
  const petAppointments = appointments.filter(a => a.petId === pet.id);
  const petHealth = healthRecords.filter(h => h.petId === pet.id);

  const nextAppt = petAppointments.find(a => a.status === 'Scheduled');
  const pendingReminders = petReminders.filter(r => !r.completed);

  const handleSaveEdit = (e: React.FormEvent) => {
    e.preventDefault();
    const updated: Pet = {
      ...pet,
      name: editName.trim() || pet.name,
      breed: editBreed.trim() || pet.breed,
      age: Number(editAge),
      weightKg: Number(editWeight),
      notes: editNotes.trim(),
      disease: editDisease.trim() || 'None reported'
    };
    onUpdatePet(updated);
    setIsEditing(false);
  };

  return (
    <div className="app-container">
      {/* Back Button & Header Actions */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 20 }}>
        <button className="btn btn-subtle" onClick={onBack}>
          <ArrowLeft style={{ width: 16, height: 16 }} />
          <span>Back to My Pets</span>
        </button>

        <div style={{ display: 'flex', gap: 10 }}>
          <button className="btn btn-secondary btn-sm" onClick={() => setIsEditing(!isEditing)}>
            <Edit2 style={{ width: 14, height: 14 }} />
            <span>{isEditing ? 'Cancel Edit' : 'Edit Profile'}</span>
          </button>
        </div>
      </div>

      {/* Hero Profile Banner */}
      <div
        className="pawly-card"
        style={{
          display: 'grid',
          gridTemplateColumns: 'minmax(200px, 280px) 1fr',
          gap: 32,
          alignItems: 'center',
          padding: 28,
          marginBottom: 28
        }}
      >
        <div
          style={{
            height: 240,
            borderRadius: 'var(--radius-lg)',
            overflow: 'hidden',
            backgroundColor: 'var(--bg-subtle)',
            boxShadow: 'var(--shadow-sm)'
          }}
        >
          <img
            src={pet.imageUrl || 'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=800&q=80'}
            alt={pet.name}
            style={{ width: '100%', height: '100%', objectFit: 'cover' }}
          />
        </div>

        <div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 6 }}>
            <h1 style={{ fontSize: '2.25rem', fontWeight: 800, color: 'var(--text-primary)', letterSpacing: '-0.03em' }}>
              {pet.name}
            </h1>
            <span className="badge badge-sage">{pet.category}</span>
          </div>

          <div style={{ fontSize: '1.0625rem', color: 'var(--text-secondary)', marginBottom: 16 }}>
            {pet.animalType} • {pet.breed}
          </div>

          <div style={{ display: 'flex', gap: 16, flexWrap: 'wrap', marginBottom: 20 }}>
            <div style={{ padding: '6px 14px', borderRadius: 'var(--radius-md)', backgroundColor: 'var(--bg-subtle)', fontSize: '0.875rem' }}>
              <span style={{ color: 'var(--text-muted)' }}>Age: </span>
              <strong>{pet.age} years old</strong>
            </div>

            <div style={{ padding: '6px 14px', borderRadius: 'var(--radius-md)', backgroundColor: 'var(--bg-subtle)', fontSize: '0.875rem' }}>
              <span style={{ color: 'var(--text-muted)' }}>Sex: </span>
              <strong>{pet.gender}</strong>
            </div>

            <div style={{ padding: '6px 14px', borderRadius: 'var(--radius-md)', backgroundColor: 'var(--bg-subtle)', fontSize: '0.875rem' }}>
              <span style={{ color: 'var(--text-muted)' }}>Weight: </span>
              <strong>{pet.weightKg} kg</strong>
            </div>

            {pet.microchipNumber && (
              <div style={{ padding: '6px 14px', borderRadius: 'var(--radius-md)', backgroundColor: 'var(--bg-subtle)', fontSize: '0.875rem' }}>
                <span style={{ color: 'var(--text-muted)' }}>Microchip: </span>
                <strong>{pet.microchipNumber}</strong>
              </div>
            )}
          </div>

          {pet.disease && pet.disease !== 'None reported' && (
            <div
              style={{
                display: 'inline-flex',
                alignItems: 'center',
                gap: 8,
                padding: '6px 14px',
                borderRadius: 'var(--radius-sm)',
                backgroundColor: 'var(--accent-clay-light)',
                border: '1px solid var(--accent-clay-border)',
                color: 'var(--accent-clay)',
                fontSize: '0.8125rem',
                fontWeight: 600
              }}
            >
              <AlertCircle style={{ width: 14, height: 14 }} />
              <span>Sensitivities: {pet.disease}</span>
            </div>
          )}
        </div>
      </div>

      {/* Edit Form Drawer if active */}
      {isEditing && (
        <div className="pawly-card" style={{ marginBottom: 28, border: '2px solid var(--primary-border)' }}>
          <h3 style={{ fontSize: '1.125rem', fontWeight: 800, marginBottom: 16 }}>Edit {pet.name}’s Profile</h3>
          <form onSubmit={handleSaveEdit}>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: 14 }}>
              <div className="form-group">
                <label className="form-label">Name</label>
                <input className="form-control" value={editName} onChange={e => setEditName(e.target.value)} />
              </div>
              <div className="form-group">
                <label className="form-label">Breed</label>
                <input className="form-control" value={editBreed} onChange={e => setEditBreed(e.target.value)} />
              </div>
              <div className="form-group">
                <label className="form-label">Age (years)</label>
                <input type="number" className="form-control" value={editAge} onChange={e => setEditAge(Number(e.target.value))} />
              </div>
              <div className="form-group">
                <label className="form-label">Weight (kg)</label>
                <input type="number" step="0.1" className="form-control" value={editWeight} onChange={e => setEditWeight(Number(e.target.value))} />
              </div>
            </div>

            <div className="form-group">
              <label className="form-label">Allergies / Health Conditions</label>
              <input className="form-control" value={editDisease} onChange={e => setEditDisease(e.target.value)} />
            </div>

            <div className="form-group">
              <label className="form-label">Personality / Important Notes</label>
              <textarea rows={2} className="form-control" value={editNotes} onChange={e => setEditNotes(e.target.value)} />
            </div>

            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 10, marginTop: 12 }}>
              <button type="button" className="btn btn-secondary btn-sm" onClick={() => setIsEditing(false)}>
                Cancel
              </button>
              <button type="submit" className="btn btn-primary btn-sm">
                Save Changes
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Profile Section Tabs */}
      <div style={{ display: 'flex', gap: 8, borderBottom: '1px solid var(--border-color)', marginBottom: 24, overflowX: 'auto', paddingBottom: 6 }}>
        <button
          className={`btn btn-sm ${activeTab === 'overview' ? 'btn-primary' : 'btn-secondary'}`}
          onClick={() => setActiveTab('overview')}
        >
          Overview
        </button>
        <button
          className={`btn btn-sm ${activeTab === 'care' ? 'btn-primary' : 'btn-secondary'}`}
          onClick={() => setActiveTab('care')}
        >
          Care Routines ({petReminders.length})
        </button>
        <button
          className={`btn btn-sm ${activeTab === 'health' ? 'btn-primary' : 'btn-secondary'}`}
          onClick={() => setActiveTab('health')}
        >
          Health Records ({petHealth.length})
        </button>
        <button
          className={`btn btn-sm ${activeTab === 'appointments' ? 'btn-primary' : 'btn-secondary'}`}
          onClick={() => setActiveTab('appointments')}
        >
          Appointments ({petAppointments.length})
        </button>
        <button
          className={`btn btn-sm ${activeTab === 'details' ? 'btn-primary' : 'btn-secondary'}`}
          onClick={() => setActiveTab('details')}
        >
          Settings & Records
        </button>
      </div>

      {/* ========================================================
          TAB 1: OVERVIEW
          ======================================================== */}
      {activeTab === 'overview' && (
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(320px, 1fr))', gap: 24 }}>
          {/* About & Personality Card */}
          <div className="pawly-card">
            <h3 style={{ fontSize: '1.125rem', fontWeight: 800, marginBottom: 12 }}>
              About {pet.name}
            </h3>
            <p style={{ fontSize: '0.9375rem', color: 'var(--text-secondary)', lineHeight: 1.6, marginBottom: 20 }}>
              {pet.notes || `${pet.name} is a beloved family companion with up-to-date health and routine care.`}
            </p>

            <div style={{ display: 'flex', flexDirection: 'column', gap: 12, borderTop: '1px solid var(--border-subtle)', paddingTop: 16 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.875rem' }}>
                <span style={{ color: 'var(--text-muted)' }}>Last Checkup:</span>
                <strong>{pet.lastCheckup}</strong>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.875rem' }}>
                <span style={{ color: 'var(--text-muted)' }}>Last Vaccination:</span>
                <strong>{pet.lastVaccination}</strong>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.875rem' }}>
                <span style={{ color: 'var(--text-muted)' }}>Category:</span>
                <span className="badge badge-sage">{pet.category}</span>
              </div>
            </div>
          </div>

          {/* Upcoming Care & Appointments */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: 20 }}>
            {/* Immediate Next Reminder */}
            <div className="pawly-card">
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
                <h4 style={{ fontWeight: 800, fontSize: '1rem', color: 'var(--text-primary)' }}>
                  Upcoming Care Today
                </h4>
                <button className="btn btn-subtle btn-sm" onClick={onOpenAddReminder}>
                  <Plus style={{ width: 14, height: 14 }} />
                  <span>Add</span>
                </button>
              </div>

              {pendingReminders.length > 0 ? (
                <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
                  {pendingReminders.slice(0, 3).map(rem => (
                    <div key={rem.id} className="routine-item">
                      <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                        <button
                          className="routine-check-btn"
                          onClick={() => onToggleReminder(rem.id)}
                          aria-label="Mark done"
                        />
                        <div>
                          <div style={{ fontSize: '0.875rem', fontWeight: 600 }}>{rem.suggestion}</div>
                          <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>{rem.time} • {rem.category}</div>
                        </div>
                      </div>
                      <span className="badge badge-honey">{rem.priority}</span>
                    </div>
                  ))}
                </div>
              ) : (
                <div style={{ fontSize: '0.875rem', color: 'var(--text-muted)' }}>
                  All care routines are marked complete for {pet.name}.
                </div>
              )}
            </div>

            {/* Next Vet Appointment */}
            {nextAppt && (
              <div
                className="pawly-card"
                style={{ backgroundColor: 'var(--primary-light)', borderColor: 'var(--primary-border)' }}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
                  <div style={{ fontWeight: 800, fontSize: '0.9375rem', color: 'var(--text-primary)' }}>
                    Next Vet Appointment
                  </div>
                  <span className="badge badge-sage">{nextAppt.appointmentDate} · {nextAppt.time}</span>
                </div>
                <div style={{ fontSize: '0.875rem', color: 'var(--text-secondary)' }}>
                  <strong>{nextAppt.purpose}</strong> with {nextAppt.vetName} at {nextAppt.clinic}.
                </div>
              </div>
            )}
          </div>
        </div>
      )}

      {/* ========================================================
          TAB 2: CARE ROUTINES
          ======================================================== */}
      {activeTab === 'care' && (
        <div className="pawly-card">
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20 }}>
            <div>
              <h3 style={{ fontSize: '1.125rem', fontWeight: 800 }}>Care Routines for {pet.name}</h3>
              <p style={{ fontSize: '0.8125rem', color: 'var(--text-muted)' }}>Medication, feeding, grooming, and activities</p>
            </div>
            <button className="btn btn-primary btn-sm" onClick={onOpenAddReminder}>
              <Plus style={{ width: 14, height: 14 }} />
              <span>Add Routine</span>
            </button>
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
            {petReminders.map(rem => (
              <div key={rem.id} className={`routine-item ${rem.completed ? 'completed' : ''}`}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                  <button
                    className={`routine-check-btn ${rem.completed ? 'checked' : ''}`}
                    onClick={() => onToggleReminder(rem.id)}
                    aria-label="Toggle completed"
                  >
                    {rem.completed && <Check style={{ width: 14, height: 14 }} />}
                  </button>
                  <div>
                    <div style={{ fontSize: '0.9375rem', fontWeight: 600, textDecoration: rem.completed ? 'line-through' : 'none' }}>
                      {rem.suggestion}
                    </div>
                    <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)', marginTop: 2 }}>
                      {rem.category} • Scheduled: {rem.scheduleDate} at {rem.time}
                    </div>
                  </div>
                </div>
                <span className={`badge ${rem.priority === 'High' ? 'badge-rose' : 'badge-honey'}`}>
                  {rem.priority}
                </span>
              </div>
            ))}

            {petReminders.length === 0 && (
              <div style={{ textAlign: 'center', padding: '36px 12px', color: 'var(--text-muted)' }}>
                No care routines set up for {pet.name} yet.
              </div>
            )}
          </div>
        </div>
      )}

      {/* ========================================================
          TAB 3: HEALTH RECORDS
          ======================================================== */}
      {activeTab === 'health' && (
        <div className="pawly-card">
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20 }}>
            <div>
              <h3 style={{ fontSize: '1.125rem', fontWeight: 800 }}>Medical & Vaccination Timeline</h3>
              <p style={{ fontSize: '0.8125rem', color: 'var(--text-muted)' }}>Complete clinical treatments and records</p>
            </div>
            <button className="btn btn-primary btn-sm" onClick={onOpenAddHealthRecord}>
              <Plus style={{ width: 14, height: 14 }} />
              <span>Log Health Event</span>
            </button>
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
            {petHealth.map(rec => (
              <div
                key={rec.id}
                style={{
                  padding: '16px 18px',
                  borderRadius: 'var(--radius-md)',
                  backgroundColor: 'var(--bg-subtle)',
                  border: '1px solid var(--border-subtle)'
                }}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 6 }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                    <span className="badge badge-sage">{rec.type}</span>
                    <h4 style={{ fontSize: '1rem', fontWeight: 700, color: 'var(--text-primary)' }}>{rec.title}</h4>
                  </div>
                  <span style={{ fontSize: '0.8125rem', color: 'var(--text-muted)', fontWeight: 600 }}>{rec.date}</span>
                </div>
                <p style={{ fontSize: '0.875rem', color: 'var(--text-secondary)', lineHeight: 1.5, marginBottom: 10 }}>
                  {rec.notes}
                </p>
                <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>
                  Veterinarian: <strong>{rec.veterinarian}</strong> {rec.clinic ? `• ${rec.clinic}` : ''}
                </div>
              </div>
            ))}

            {petHealth.length === 0 && (
              <div style={{ textAlign: 'center', padding: '36px 12px', color: 'var(--text-muted)' }}>
                No health records logged for {pet.name} yet.
              </div>
            )}
          </div>
        </div>
      )}

      {/* ========================================================
          TAB 4: APPOINTMENTS
          ======================================================== */}
      {activeTab === 'appointments' && (
        <div className="pawly-card">
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20 }}>
            <div>
              <h3 style={{ fontSize: '1.125rem', fontWeight: 800 }}>Vet Visits for {pet.name}</h3>
              <p style={{ fontSize: '0.8125rem', color: 'var(--text-muted)' }}>Scheduled consultations and past visit history</p>
            </div>
            <button className="btn btn-primary btn-sm" onClick={onOpenAddAppointment}>
              <Plus style={{ width: 14, height: 14 }} />
              <span>Book Consultation</span>
            </button>
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
            {petAppointments.map(appt => (
              <div
                key={appt.id}
                style={{
                  padding: '16px 18px',
                  borderRadius: 'var(--radius-md)',
                  backgroundColor: appt.status === 'Scheduled' ? 'var(--bg-surface)' : 'var(--bg-subtle)',
                  border: '1px solid var(--border-color)',
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  flexWrap: 'wrap',
                  gap: 12
                }}
              >
                <div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 4 }}>
                    <h4 style={{ fontWeight: 800, fontSize: '1rem', color: 'var(--text-primary)' }}>{appt.purpose}</h4>
                    <span className={`badge ${appt.status === 'Scheduled' ? 'badge-sage' : 'badge-subtle'}`}>
                      {appt.status}
                    </span>
                  </div>
                  <div style={{ fontSize: '0.8125rem', color: 'var(--text-secondary)' }}>
                    {appt.clinic} • {appt.vetName}
                  </div>
                  {appt.notes && (
                    <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)', marginTop: 4 }}>
                      Note: {appt.notes}
                    </div>
                  )}
                </div>

                <div style={{ textAlign: 'right' }}>
                  <div style={{ fontWeight: 700, fontSize: '0.9375rem', color: 'var(--text-primary)' }}>
                    {appt.appointmentDate}
                  </div>
                  <div style={{ fontSize: '0.8125rem', color: 'var(--text-muted)' }}>
                    {appt.time}
                  </div>
                </div>
              </div>
            ))}

            {petAppointments.length === 0 && (
              <div style={{ textAlign: 'center', padding: '36px 12px', color: 'var(--text-muted)' }}>
                No appointments recorded for {pet.name}.
              </div>
            )}
          </div>
        </div>
      )}

      {/* ========================================================
          TAB 5: SETTINGS & DELETION
          ======================================================== */}
      {activeTab === 'details' && (
        <div className="pawly-card">
          <h3 style={{ fontSize: '1.125rem', fontWeight: 800, marginBottom: 12 }}>
            Pet Profile Settings
          </h3>
          <p style={{ fontSize: '0.875rem', color: 'var(--text-secondary)', marginBottom: 24 }}>
            Manage identity details, emergency records, or remove this pet profile.
          </p>

          <div
            style={{
              padding: '18px',
              borderRadius: 'var(--radius-md)',
              border: '1px solid var(--accent-rose-border)',
              backgroundColor: 'var(--accent-rose-light)'
            }}
          >
            <div style={{ fontWeight: 700, fontSize: '0.9375rem', color: 'var(--accent-rose)', marginBottom: 4 }}>
              Danger Zone: Remove Pet Profile
            </div>
            <p style={{ fontSize: '0.8125rem', color: 'var(--text-secondary)', marginBottom: 14 }}>
              Removing {pet.name} will delete their care reminders, health events, and appointment records from this device.
            </p>
            <button
              className="btn btn-sm"
              style={{ backgroundColor: 'var(--accent-rose)', color: '#fff' }}
              onClick={() => onDeletePet(pet.id)}
            >
              <Trash2 style={{ width: 14, height: 14 }} />
              <span>Remove {pet.name} from Pawly</span>
            </button>
          </div>
        </div>
      )}
    </div>
  );
};
