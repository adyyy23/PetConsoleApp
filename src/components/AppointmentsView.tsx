import React, { useState } from 'react';
import { Calendar, Plus, MapPin, User as DoctorIcon, Clock, CheckCircle2, ChevronRight } from 'lucide-react';
import { Pet, Appointment } from '../types';

interface AppointmentsViewProps {
  pets: Pet[];
  appointments: Appointment[];
  onOpenAddAppointment: () => void;
  onMarkAppointmentCompleted: (id: number) => void;
}

export const AppointmentsView: React.FC<AppointmentsViewProps> = ({
  pets,
  appointments,
  onOpenAddAppointment,
  onMarkAppointmentCompleted
}) => {
  const [selectedPetFilter, setSelectedPetFilter] = useState<number | 'All'>('All');

  const filteredAppts = appointments.filter(a => {
    return selectedPetFilter === 'All' || a.petId === selectedPetFilter;
  });

  const scheduled = filteredAppts.filter(a => a.status === 'Scheduled');
  const past = filteredAppts.filter(a => a.status === 'Completed' || a.status === 'Cancelled');

  const upcomingHero = scheduled[0];
  const otherScheduled = scheduled.slice(1);

  return (
    <div className="app-container">
      <div className="page-header">
        <div>
          <h1 className="page-title">Vet Appointments</h1>
          <p className="page-subtitle">
            Upcoming checkups, vaccination visits, and past veterinary consultations.
          </p>
        </div>

        <button className="btn btn-primary" onClick={onOpenAddAppointment}>
          <Plus style={{ width: 16, height: 16 }} />
          <span>Book Consultation</span>
        </button>
      </div>

      {/* Pet filter pills */}
      {pets.length > 1 && (
        <div style={{ display: 'flex', gap: 8, marginBottom: 28, overflowX: 'auto', paddingBottom: 4 }}>
          <button
            className={`btn btn-sm ${selectedPetFilter === 'All' ? 'btn-primary' : 'btn-secondary'}`}
            onClick={() => setSelectedPetFilter('All')}
          >
            All Pets
          </button>
          {pets.map(p => (
            <button
              key={p.id}
              className={`btn btn-sm ${selectedPetFilter === p.id ? 'btn-primary' : 'btn-secondary'}`}
              onClick={() => setSelectedPetFilter(p.id)}
            >
              {p.name}
            </button>
          ))}
        </div>
      )}

      {/* ========================================================
          HERO UPCOMING APPOINTMENT (Pet Owner View)
          ======================================================== */}
      {upcomingHero ? (
        <div style={{ maxWidth: 840, marginBottom: 36 }}>
          <div style={{ fontSize: '0.8125rem', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.05em', color: 'var(--primary)', marginBottom: 10 }}>
            Next Scheduled Visit
          </div>

          {(() => {
            const pet = pets.find(p => p.id === upcomingHero.petId);
            return (
              <div
                className="pawly-card"
                style={{
                  padding: '28px 32px',
                  border: '1.5px solid var(--primary-border)',
                  backgroundColor: 'var(--bg-surface)',
                  boxShadow: 'var(--shadow-md)'
                }}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', flexWrap: 'wrap', gap: 16, marginBottom: 20 }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
                    <img
                      src={pet?.imageUrl || 'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=150&q=80'}
                      alt={pet?.name}
                      style={{ width: 56, height: 56, borderRadius: 'var(--radius-md)', objectFit: 'cover' }}
                    />
                    <div>
                      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                        <h3 style={{ fontSize: '1.375rem', fontWeight: 800, color: 'var(--text-primary)' }}>
                          {pet?.name}
                        </h3>
                        <span className="badge badge-sage">Confirmed</span>
                      </div>
                      <div style={{ fontSize: '1rem', fontWeight: 700, color: 'var(--primary)', marginTop: 2 }}>
                        {upcomingHero.purpose}
                      </div>
                    </div>
                  </div>

                  <div style={{ textAlign: 'right' }}>
                    <div style={{ fontSize: '1.1875rem', fontWeight: 800, color: 'var(--text-primary)' }}>
                      {upcomingHero.appointmentDate}
                    </div>
                    <div style={{ fontSize: '0.875rem', color: 'var(--text-muted)', fontWeight: 600 }}>
                      {upcomingHero.time}
                    </div>
                  </div>
                </div>

                <div
                  style={{
                    display: 'grid',
                    gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))',
                    gap: 16,
                    padding: '16px 20px',
                    borderRadius: 'var(--radius-md)',
                    backgroundColor: 'var(--bg-subtle)',
                    marginBottom: 20
                  }}
                >
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                    <MapPin style={{ width: 18, height: 18, color: 'var(--primary)' }} />
                    <div>
                      <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>Clinic Location</div>
                      <div style={{ fontSize: '0.875rem', fontWeight: 600, color: 'var(--text-primary)' }}>
                        {upcomingHero.clinic}
                      </div>
                    </div>
                  </div>

                  <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                    <DoctorIcon style={{ width: 18, height: 18, color: 'var(--primary)' }} />
                    <div>
                      <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>Veterinarian</div>
                      <div style={{ fontSize: '0.875rem', fontWeight: 600, color: 'var(--text-primary)' }}>
                        {upcomingHero.vetName}
                      </div>
                    </div>
                  </div>
                </div>

                {upcomingHero.notes && (
                  <p style={{ fontSize: '0.875rem', color: 'var(--text-secondary)', marginBottom: 20 }}>
                    <strong>Visit notes:</strong> {upcomingHero.notes}
                  </p>
                )}

                <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 10 }}>
                  <button
                    className="btn btn-secondary btn-sm"
                    onClick={() => onMarkAppointmentCompleted(upcomingHero.id)}
                  >
                    <CheckCircle2 style={{ width: 14, height: 14 }} />
                    <span>Mark as Completed</span>
                  </button>
                </div>
              </div>
            );
          })()}
        </div>
      ) : (
        <div className="pawly-card" style={{ maxWidth: 840, textAlign: 'center', padding: '40px 20px', marginBottom: 36, color: 'var(--text-muted)' }}>
          <Calendar style={{ width: 36, height: 36, margin: '0 auto 12px', color: 'var(--border-color)' }} />
          <h3 style={{ fontSize: '1.125rem', fontWeight: 700, color: 'var(--text-primary)' }}>
            No upcoming appointments scheduled
          </h3>
          <p style={{ fontSize: '0.875rem', marginTop: 4 }}>
            Keep track of routine visits, checkups, and vaccinations.
          </p>
          <button className="btn btn-primary btn-sm" style={{ marginTop: 16 }} onClick={onOpenAddAppointment}>
            Book a Visit
          </button>
        </div>
      )}

      {/* Other scheduled appointments */}
      {otherScheduled.length > 0 && (
        <div style={{ maxWidth: 840, marginBottom: 36 }}>
          <div style={{ fontSize: '0.8125rem', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.05em', color: 'var(--text-muted)', marginBottom: 12 }}>
            Other Scheduled Consultations
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
            {otherScheduled.map(appt => {
              const pet = pets.find(p => p.id === appt.petId);
              return (
                <div key={appt.id} className="pawly-card" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: 12 }}>
                  <div>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 2 }}>
                      <span style={{ fontWeight: 700, fontSize: '0.9375rem' }}>{pet?.name}</span>
                      <span>•</span>
                      <span style={{ fontWeight: 600, color: 'var(--primary)' }}>{appt.purpose}</span>
                    </div>
                    <div style={{ fontSize: '0.8125rem', color: 'var(--text-muted)' }}>
                      {appt.clinic} ({appt.vetName})
                    </div>
                  </div>

                  <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
                    <div style={{ textAlign: 'right' }}>
                      <div style={{ fontWeight: 700, fontSize: '0.875rem' }}>{appt.appointmentDate}</div>
                      <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>{appt.time}</div>
                    </div>
                    <button
                      className="btn btn-secondary btn-sm"
                      onClick={() => onMarkAppointmentCompleted(appt.id)}
                    >
                      Done
                    </button>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* Past Appointments History (Quieter Section) */}
      <div style={{ maxWidth: 840 }}>
        <div style={{ fontSize: '0.8125rem', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.05em', color: 'var(--text-muted)', marginBottom: 12 }}>
          Past Visits & History
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          {past.map(appt => {
            const pet = pets.find(p => p.id === appt.petId);
            return (
              <div
                key={appt.id}
                style={{
                  padding: '14px 18px',
                  borderRadius: 'var(--radius-md)',
                  backgroundColor: 'var(--bg-subtle)',
                  border: '1px solid var(--border-subtle)',
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  flexWrap: 'wrap',
                  gap: 12
                }}
              >
                <div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                    <span style={{ fontWeight: 700, fontSize: '0.875rem', color: 'var(--text-primary)' }}>
                      {appt.purpose}
                    </span>
                    <span style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>
                      for <strong>{pet?.name}</strong>
                    </span>
                  </div>
                  <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)', marginTop: 2 }}>
                    {appt.clinic} • {appt.vetName}
                  </div>
                </div>

                <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                  <div style={{ fontSize: '0.8125rem', color: 'var(--text-muted)', fontWeight: 600 }}>
                    {appt.appointmentDate}
                  </div>
                  <span className="badge badge-subtle">{appt.status}</span>
                </div>
              </div>
            );
          })}

          {past.length === 0 && (
            <div style={{ fontSize: '0.875rem', color: 'var(--text-muted)', padding: '12px 0' }}>
              No previous visit history recorded yet.
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
