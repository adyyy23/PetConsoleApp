import React, { useState } from 'react';
import { Plus, PawPrint, Clock, Calendar, HeartPulse, ChevronRight, Search } from 'lucide-react';
import { Pet, Reminder, Appointment } from '../types';

interface MyPetsViewProps {
  pets: Pet[];
  reminders: Reminder[];
  appointments: Appointment[];
  onSelectPet: (petId: number) => void;
  onOpenAddPet: () => void;
  searchQuery: string;
}

export const MyPetsView: React.FC<MyPetsViewProps> = ({
  pets,
  reminders,
  appointments,
  onSelectPet,
  onOpenAddPet,
  searchQuery
}) => {
  const [speciesFilter, setSpeciesFilter] = useState<string>('All');

  const filteredPets = pets.filter(p => {
    const matchesSearch =
      p.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      p.breed.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesSpecies = speciesFilter === 'All' || p.animalType === speciesFilter;
    return matchesSearch && matchesSpecies;
  });

  return (
    <div className="app-container">
      <div className="page-header">
        <div>
          <h1 className="page-title">My Pets</h1>
          <p className="page-subtitle">
            Your family companions, their digital passports, and everyday care.
          </p>
        </div>

        <button className="btn btn-primary" onClick={onOpenAddPet}>
          <Plus style={{ width: 16, height: 16 }} />
          <span>Add a Pet</span>
        </button>
      </div>

      {/* Species Filter Tabs */}
      <div style={{ display: 'flex', gap: 8, marginBottom: 24, flexWrap: 'wrap' }}>
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
        <div
          className="pawly-card"
          style={{ textAlign: 'center', padding: '60px 20px', color: 'var(--text-muted)' }}
        >
          <PawPrint style={{ width: 36, height: 36, margin: '0 auto 12px', color: 'var(--border-color)' }} />
          <h3 style={{ fontSize: '1.125rem', fontWeight: 700, color: 'var(--text-primary)' }}>
            No pets found
          </h3>
          <p style={{ fontSize: '0.875rem', marginTop: 4 }}>
            No pets match the current filter or search criteria.
          </p>
          <button
            className="btn btn-secondary btn-sm"
            style={{ marginTop: 16 }}
            onClick={() => setSpeciesFilter('All')}
          >
            Reset Filters
          </button>
        </div>
      ) : (
        <div className="pets-collection-grid">
          {filteredPets.map(pet => {
            const nextReminder = reminders.find(r => r.petId === pet.id && !r.completed);
            const nextAppt = appointments.find(a => a.petId === pet.id && a.status === 'Scheduled');

            return (
              <div
                key={pet.id}
                className="pet-passport-card"
                onClick={() => onSelectPet(pet.id)}
              >
                <div className="pet-card-image-wrap">
                  <img
                    src={pet.imageUrl || 'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=600&q=80'}
                    alt={pet.name}
                  />
                  <div
                    style={{
                      position: 'absolute',
                      top: 12,
                      right: 12,
                      backgroundColor: 'rgba(255,255,255,0.92)',
                      backdropFilter: 'blur(4px)',
                      padding: '3px 10px',
                      borderRadius: 'var(--radius-full)',
                      fontSize: '0.75rem',
                      fontWeight: 700,
                      color: 'var(--primary)'
                    }}
                  >
                    {pet.category}
                  </div>
                </div>

                <div className="pet-card-body">
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 4 }}>
                    <h3 style={{ fontSize: '1.25rem', fontWeight: 800, color: 'var(--text-primary)', letterSpacing: '-0.02em' }}>
                      {pet.name}
                    </h3>
                    <span style={{ fontSize: '0.8125rem', color: 'var(--text-muted)' }}>
                      {pet.gender}
                    </span>
                  </div>

                  <div style={{ fontSize: '0.875rem', color: 'var(--text-secondary)', marginBottom: 12 }}>
                    {pet.animalType} • {pet.breed}
                  </div>

                  <div style={{ display: 'flex', gap: 12, fontSize: '0.8125rem', color: 'var(--text-muted)', marginBottom: 16 }}>
                    <span>{pet.age} year{pet.age > 1 ? 's' : ''} old</span>
                    <span>•</span>
                    <span>{pet.weightKg} kg</span>
                  </div>

                  {/* Next Care item indicator */}
                  <div
                    style={{
                      marginTop: 'auto',
                      padding: '10px 12px',
                      borderRadius: 'var(--radius-sm)',
                      backgroundColor: 'var(--bg-subtle)',
                      border: '1px solid var(--border-subtle)',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'space-between'
                    }}
                  >
                    <div style={{ display: 'flex', alignItems: 'center', gap: 8, overflow: 'hidden' }}>
                      <Clock style={{ width: 14, height: 14, color: 'var(--accent-honey)', flexShrink: 0 }} />
                      <div style={{ fontSize: '0.75rem', color: 'var(--text-primary)', fontWeight: 600, whiteSpace: 'nowrap', textOverflow: 'ellipsis', overflow: 'hidden' }}>
                        {nextReminder ? `Next: ${nextReminder.suggestion}` : nextAppt ? `Visit: ${nextAppt.purpose}` : 'All routines up to date'}
                      </div>
                    </div>
                    <ChevronRight style={{ width: 14, height: 14, color: 'var(--text-muted)', flexShrink: 0 }} />
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
};
