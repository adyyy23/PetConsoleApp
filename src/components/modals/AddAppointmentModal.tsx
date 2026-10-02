import React, { useState } from 'react';
import { X, Calendar } from 'lucide-react';
import { Pet, Appointment } from '../../types';

interface AddAppointmentModalProps {
  isOpen: boolean;
  onClose: () => void;
  pets: Pet[];
  onAddAppointment: (appointment: Appointment) => void;
  defaultPetId?: number;
}

export const AddAppointmentModal: React.FC<AddAppointmentModalProps> = ({
  isOpen,
  onClose,
  pets,
  onAddAppointment,
  defaultPetId
}) => {
  const [petId, setPetId] = useState(defaultPetId || (pets[0]?.id ?? 1));
  const [clinic, setClinic] = useState('CityVet Wellness Center');
  const [vetName, setVetName] = useState('Dr. Sarah Ramos, DVM');
  const [purpose, setPurpose] = useState<Appointment['purpose']>('Annual Checkup');
  const [date, setDate] = useState(() => new Date(Date.now() + 86400000 * 3).toISOString().split('T')[0]);
  const [time, setTime] = useState('10:00 AM');
  const [notes, setNotes] = useState('');

  if (!isOpen) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();

    const newAppt: Appointment = {
      id: Date.now(),
      petId: Number(petId),
      clinic: clinic.trim() || 'CityVet Wellness Center',
      vetName: vetName.trim() || 'Attending Veterinarian',
      purpose,
      appointmentDate: date,
      time,
      status: 'Scheduled',
      notes: notes.trim()
    };

    onAddAppointment(newAppt);
    onClose();
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-card" onClick={e => e.stopPropagation()}>
        <div className="modal-header">
          <div>
            <h2 className="modal-title">Schedule Vet Visit</h2>
            <p style={{ fontSize: '0.8125rem', color: 'var(--text-secondary)', marginTop: 2 }}>
              Book or record an upcoming veterinary consultation.
            </p>
          </div>
          <button onClick={onClose} style={{ color: 'var(--text-muted)' }} aria-label="Close">
            <X style={{ width: 22, height: 22 }} />
          </button>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label className="form-label">Patient Pet *</label>
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

          <div className="form-group">
            <label className="form-label">Reason for Visit *</label>
            <select
              className="form-control"
              value={purpose}
              onChange={e => setPurpose(e.target.value as any)}
            >
              <option value="Annual Checkup">Annual Checkup & Vitals</option>
              <option value="Vaccination Booster">Vaccination Booster</option>
              <option value="Dental Cleaning">Dental Cleaning</option>
              <option value="Dermatology">Dermatology / Skin & Coat</option>
              <option value="Surgery Follow-up">Surgery Follow-up</option>
              <option value="Emergency">Urgent Care / Illness</option>
            </select>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
            <div className="form-group">
              <label className="form-label">Veterinary Clinic</label>
              <input
                type="text"
                className="form-control"
                placeholder="e.g. CityVet Wellness Center"
                value={clinic}
                onChange={e => setClinic(e.target.value)}
              />
            </div>

            <div className="form-group">
              <label className="form-label">Doctor / Veterinarian</label>
              <input
                type="text"
                className="form-control"
                placeholder="e.g. Dr. Sarah Ramos, DVM"
                value={vetName}
                onChange={e => setVetName(e.target.value)}
              />
            </div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1.2fr 1fr', gap: 14 }}>
            <div className="form-group">
              <label className="form-label">Appointment Date *</label>
              <input
                type="date"
                required
                className="form-control"
                value={date}
                onChange={e => setDate(e.target.value)}
              />
            </div>

            <div className="form-group">
              <label className="form-label">Time</label>
              <input
                type="text"
                className="form-control"
                placeholder="10:30 AM"
                value={time}
                onChange={e => setTime(e.target.value)}
              />
            </div>
          </div>

          <div className="form-group">
            <label className="form-label">Symptoms / Notes for Vet</label>
            <textarea
              rows={2}
              className="form-control"
              placeholder="e.g. Distal paw scratching after lawn walks"
              value={notes}
              onChange={e => setNotes(e.target.value)}
            />
          </div>

          <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 12, marginTop: 24 }}>
            <button type="button" className="btn btn-secondary" onClick={onClose}>
              Cancel
            </button>
            <button type="submit" className="btn btn-primary">
              <Calendar style={{ width: 16, height: 16 }} />
              <span>Confirm Appointment</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
