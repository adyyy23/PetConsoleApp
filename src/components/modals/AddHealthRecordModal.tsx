import React, { useState } from 'react';
import { X, HeartPulse } from 'lucide-react';
import { Pet, HealthRecord } from '../../types';

interface AddHealthRecordModalProps {
  isOpen: boolean;
  onClose: () => void;
  pets: Pet[];
  onAddRecord: (record: HealthRecord) => void;
  defaultPetId?: number;
}

export const AddHealthRecordModal: React.FC<AddHealthRecordModalProps> = ({
  isOpen,
  onClose,
  pets,
  onAddRecord,
  defaultPetId
}) => {
  const [petId, setPetId] = useState(defaultPetId || (pets[0]?.id ?? 1));
  const [type, setType] = useState<HealthRecord['type']>('Vaccination');
  const [title, setTitle] = useState('');
  const [notes, setNotes] = useState('');
  const [veterinarian, setVeterinarian] = useState('Dr. Sarah Ramos, DVM');
  const [clinic, setClinic] = useState('CityVet Wellness Center');
  const [date, setDate] = useState(() => new Date().toISOString().split('T')[0]);

  if (!isOpen) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim()) return;

    const newRec: HealthRecord = {
      id: Date.now(),
      petId: Number(petId),
      type,
      title: title.trim(),
      notes: notes.trim(),
      veterinarian: veterinarian.trim() || 'Attending Vet',
      clinic: clinic.trim(),
      date
    };

    onAddRecord(newRec);
    onClose();
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-card" onClick={e => e.stopPropagation()}>
        <div className="modal-header">
          <div>
            <h2 className="modal-title">Log Health Event</h2>
            <p style={{ fontSize: '0.8125rem', color: 'var(--text-secondary)', marginTop: 2 }}>
              Keep an accurate timeline of vaccinations, exams, and treatments.
            </p>
          </div>
          <button onClick={onClose} style={{ color: 'var(--text-muted)' }} aria-label="Close">
            <X style={{ width: 22, height: 22 }} />
          </button>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label className="form-label">Which Pet? *</label>
            <select
              className="form-control"
              value={petId}
              onChange={e => setPetId(Number(e.target.value))}
            >
              {pets.map(p => (
                <option key={p.id} value={p.id}>
                  {p.name} ({p.animalType} • {p.breed})
                </option>
              ))}
            </select>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
            <div className="form-group">
              <label className="form-label">Event Type *</label>
              <select
                className="form-control"
                value={type}
                onChange={e => setType(e.target.value as any)}
              >
                <option value="Vaccination">Vaccination Booster</option>
                <option value="Checkup">General Checkup</option>
                <option value="Medication">Medication Prescribed</option>
                <option value="Surgery">Procedure / Surgery</option>
                <option value="Grooming">Sanitary / Grooming Exam</option>
              </select>
            </div>

            <div className="form-group">
              <label className="form-label">Date Recorded *</label>
              <input
                type="date"
                required
                className="form-control"
                value={date}
                onChange={e => setDate(e.target.value)}
              />
            </div>
          </div>

          <div className="form-group">
            <label className="form-label">Event Title / Description *</label>
            <input
              type="text"
              required
              className="form-control"
              placeholder="e.g. Core Canine DHPP Booster, Ear Cytology Clear"
              value={title}
              onChange={e => setTitle(e.target.value)}
            />
          </div>

          <div className="form-group">
            <label className="form-label">Clinical Notes & Observations</label>
            <textarea
              rows={3}
              className="form-control"
              placeholder="e.g. Administered subcutaneous. Normal vitals, heart rate 92 bpm, no reactions noted."
              value={notes}
              onChange={e => setNotes(e.target.value)}
            />
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
            <div className="form-group">
              <label className="form-label">Veterinarian Name</label>
              <input
                type="text"
                className="form-control"
                placeholder="Dr. Sarah Ramos, DVM"
                value={veterinarian}
                onChange={e => setVeterinarian(e.target.value)}
              />
            </div>

            <div className="form-group">
              <label className="form-label">Clinic</label>
              <input
                type="text"
                className="form-control"
                placeholder="CityVet Wellness Center"
                value={clinic}
                onChange={e => setClinic(e.target.value)}
              />
            </div>
          </div>

          <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 12, marginTop: 24 }}>
            <button type="button" className="btn btn-secondary" onClick={onClose}>
              Cancel
            </button>
            <button type="submit" className="btn btn-primary">
              <HeartPulse style={{ width: 16, height: 16 }} />
              <span>Record Health Event</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
