import React, { useState } from 'react';
import { HeartPulse, Plus, Shield, Stethoscope, Scissors, Sparkles, Filter } from 'lucide-react';
import { Pet, HealthRecord } from '../types';

interface HealthViewProps {
  pets: Pet[];
  healthRecords: HealthRecord[];
  onOpenAddRecord: () => void;
}

export const HealthView: React.FC<HealthViewProps> = ({ pets, healthRecords, onOpenAddRecord }) => {
  const [selectedPetId, setSelectedPetId] = useState<number | 'All'>('All');
  const [selectedType, setSelectedType] = useState<string>('All');

  const filteredRecords = healthRecords
    .filter(r => {
      const matchPet = selectedPetId === 'All' || r.petId === selectedPetId;
      const matchType = selectedType === 'All' || r.type === selectedType;
      return matchPet && matchType;
    })
    .sort((a, b) => b.date.localeCompare(a.date));

  const types = ['All', 'Vaccination', 'Checkup', 'Medication', 'Surgery', 'Grooming'];

  const getTypeIcon = (type: HealthRecord['type']) => {
    switch (type) {
      case 'Vaccination':
        return <Shield style={{ width: 16, height: 16 }} />;
      case 'Checkup':
        return <Stethoscope style={{ width: 16, height: 16 }} />;
      case 'Grooming':
        return <Scissors style={{ width: 16, height: 16 }} />;
      default:
        return <HeartPulse style={{ width: 16, height: 16 }} />;
    }
  };

  const getTypeBadgeClass = (type: HealthRecord['type']) => {
    switch (type) {
      case 'Vaccination':
        return 'badge-sage';
      case 'Checkup':
        return 'badge-honey';
      case 'Medication':
        return 'badge-blue';
      case 'Surgery':
        return 'badge-rose';
      default:
        return 'badge-subtle';
    }
  };

  return (
    <div className="app-container">
      <div className="page-header">
        <div>
          <h1 className="page-title">Health History</h1>
          <p className="page-subtitle">
            A readable medical timeline of vaccinations, health checkups, and treatments.
          </p>
        </div>

        <button className="btn btn-primary" onClick={onOpenAddRecord}>
          <Plus style={{ width: 16, height: 16 }} />
          <span>Log Health Event</span>
        </button>
      </div>

      {/* Filters: Pets and Event Types */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: 12, marginBottom: 28 }}>
        {pets.length > 1 && (
          <div style={{ display: 'flex', gap: 8, overflowX: 'auto', paddingBottom: 4 }}>
            <button
              className={`btn btn-sm ${selectedPetId === 'All' ? 'btn-primary' : 'btn-secondary'}`}
              onClick={() => setSelectedPetId('All')}
            >
              All Pets
            </button>
            {pets.map(p => (
              <button
                key={p.id}
                className={`btn btn-sm ${selectedPetId === p.id ? 'btn-primary' : 'btn-secondary'}`}
                onClick={() => setSelectedPetId(p.id)}
              >
                {p.name}
              </button>
            ))}
          </div>
        )}

        <div style={{ display: 'flex', gap: 8, overflowX: 'auto', paddingBottom: 4 }}>
          {types.map(t => (
            <button
              key={t}
              className={`btn btn-sm ${selectedType === t ? 'btn-secondary' : 'btn-subtle'}`}
              style={{
                border: selectedType === t ? '1.5px solid var(--primary)' : '1px solid var(--border-color)',
                color: selectedType === t ? 'var(--primary)' : 'var(--text-secondary)',
                fontWeight: selectedType === t ? 700 : 500
              }}
              onClick={() => setSelectedType(t)}
            >
              {t}
            </button>
          ))}
        </div>
      </div>

      {/* Chronological Health Timeline */}
      <div style={{ maxWidth: 840 }}>
        {filteredRecords.length === 0 ? (
          <div className="pawly-card" style={{ textAlign: 'center', padding: '48px 20px', color: 'var(--text-muted)' }}>
            <HeartPulse style={{ width: 36, height: 36, margin: '0 auto 12px', color: 'var(--border-color)' }} />
            <h3 style={{ fontSize: '1.125rem', fontWeight: 700, color: 'var(--text-primary)' }}>
              No health events recorded
            </h3>
            <p style={{ fontSize: '0.875rem', marginTop: 4 }}>
              Record past vaccinations, booster shots, physical checkups, or prescriptions.
            </p>
            <button className="btn btn-primary btn-sm" style={{ marginTop: 16 }} onClick={onOpenAddRecord}>
              Log First Event
            </button>
          </div>
        ) : (
          <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
            {filteredRecords.map(record => {
              const pet = pets.find(p => p.id === record.petId);
              return (
                <div key={record.id} className="pawly-card" style={{ padding: '24px 28px' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', flexWrap: 'wrap', gap: 12, marginBottom: 12 }}>
                    <div>
                      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 4 }}>
                        <span className={`badge ${getTypeBadgeClass(record.type)}`}>
                          {getTypeIcon(record.type)}
                          <span>{record.type}</span>
                        </span>
                        <span style={{ fontSize: '0.8125rem', fontWeight: 700, color: 'var(--text-muted)' }}>
                          for <strong>{pet?.name}</strong>
                        </span>
                      </div>
                      <h3 style={{ fontSize: '1.1875rem', fontWeight: 800, color: 'var(--text-primary)' }}>
                        {record.title}
                      </h3>
                    </div>

                    <div style={{ fontSize: '0.875rem', fontWeight: 700, color: 'var(--primary)' }}>
                      {record.date}
                    </div>
                  </div>

                  <p style={{ fontSize: '0.9375rem', color: 'var(--text-secondary)', lineHeight: 1.6, marginBottom: 16 }}>
                    {record.notes}
                  </p>

                  <div
                    style={{
                      display: 'flex',
                      justifyContent: 'space-between',
                      alignItems: 'center',
                      fontSize: '0.75rem',
                      color: 'var(--text-muted)',
                      borderTop: '1px solid var(--border-subtle)',
                      paddingTop: 12,
                      flexWrap: 'wrap',
                      gap: 8
                    }}
                  >
                    <span>
                      Attending Vet: <strong>{record.veterinarian}</strong>
                    </span>
                    {record.clinic && (
                      <span>
                        Clinic: <strong>{record.clinic}</strong>
                      </span>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
};
