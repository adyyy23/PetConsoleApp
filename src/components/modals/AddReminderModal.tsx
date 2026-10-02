import React, { useState } from 'react';
import { X, Clock, Calendar } from 'lucide-react';
import { Pet, Reminder } from '../../types';

interface AddReminderModalProps {
  isOpen: boolean;
  onClose: () => void;
  pets: Pet[];
  onAddReminder: (reminder: Reminder) => void;
  defaultPetId?: number;
}

export const AddReminderModal: React.FC<AddReminderModalProps> = ({
  isOpen,
  onClose,
  pets,
  onAddReminder,
  defaultPetId
}) => {
  const [petId, setPetId] = useState(defaultPetId || (pets[0]?.id ?? 1));
  const [category, setCategory] = useState<Reminder['category']>('Medication');
  const [priority, setPriority] = useState<Reminder['priority']>('Medium');
  const [scheduleDate, setScheduleDate] = useState(() => new Date().toISOString().split('T')[0]);
  const [time, setTime] = useState('08:00 AM');
  const [suggestion, setSuggestion] = useState('');

  if (!isOpen) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!suggestion.trim()) return;

    const newReminder: Reminder = {
      id: Date.now(),
      petId: Number(petId),
      category,
      priority,
      scheduleDate,
      time,
      suggestion: suggestion.trim(),
      completed: false
    };

    onAddReminder(newReminder);
    setSuggestion('');
    onClose();
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-card" onClick={e => e.stopPropagation()}>
        <div className="modal-header">
          <div>
            <h2 className="modal-title">Schedule Care Reminder</h2>
            <p style={{ fontSize: '0.8125rem', color: 'var(--text-secondary)', marginTop: 2 }}>
              Keep daily routines, medications, and care tasks on track.
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
              <label className="form-label">Care Category</label>
              <select
                className="form-control"
                value={category}
                onChange={e => setCategory(e.target.value as any)}
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
              <label className="form-label">Priority</label>
              <select
                className="form-control"
                value={priority}
                onChange={e => setPriority(e.target.value as any)}
              >
                <option value="High">High (Important)</option>
                <option value="Medium">Medium (Regular)</option>
                <option value="Low">Low (Casual)</option>
              </select>
            </div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1.2fr 1fr', gap: 14 }}>
            <div className="form-group">
              <label className="form-label">Date *</label>
              <input
                type="date"
                required
                className="form-control"
                value={scheduleDate}
                onChange={e => setScheduleDate(e.target.value)}
              />
            </div>

            <div className="form-group">
              <label className="form-label">Time</label>
              <input
                type="text"
                className="form-control"
                placeholder="08:00 AM"
                value={time}
                onChange={e => setTime(e.target.value)}
              />
            </div>
          </div>

          <div className="form-group">
            <label className="form-label">Care Instructions / Description *</label>
            <textarea
              required
              rows={3}
              className="form-control"
              placeholder="e.g. Dose 16mg Apoquel with breakfast kibble"
              value={suggestion}
              onChange={e => setSuggestion(e.target.value)}
            />
          </div>

          <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 12, marginTop: 24 }}>
            <button type="button" className="btn btn-secondary" onClick={onClose}>
              Cancel
            </button>
            <button type="submit" className="btn btn-primary">
              <Clock style={{ width: 16, height: 16 }} />
              <span>Save Reminder</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
