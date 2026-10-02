import React, { useState } from 'react';
import { X, Camera, Heart, Sparkles } from 'lucide-react';
import { Pet } from '../../types';

interface AddPetModalProps {
  isOpen: boolean;
  onClose: () => void;
  onAddPet: (pet: Pet) => void;
}

const PRESET_PET_PHOTOS: { label: string; url: string; species: Pet['animalType'] }[] = [
  { label: 'Golden Retriever', url: 'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=600&q=80', species: 'Dog' },
  { label: 'French Bulldog', url: 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&w=600&q=80', species: 'Dog' },
  { label: 'Shorthair Cat', url: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=600&q=80', species: 'Cat' },
  { label: 'Tabby Kitten', url: 'https://images.unsplash.com/photo-1574158622682-e40e69881006?auto=format&fit=crop&w=600&q=80', species: 'Cat' },
  { label: 'Holland Lop Rabbit', url: 'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?auto=format&fit=crop&w=600&q=80', species: 'Rabbit' },
  { label: 'Canary / Parrot', url: 'https://images.unsplash.com/photo-1552728089-57bdde30beb3?auto=format&fit=crop&w=600&q=80', species: 'Bird' }
];

export const AddPetModal: React.FC<AddPetModalProps> = ({ isOpen, onClose, onAddPet }) => {
  const [name, setName] = useState('');
  const [species, setSpecies] = useState<Pet['animalType']>('Dog');
  const [breed, setBreed] = useState('');
  const [age, setAge] = useState(2);
  const [weightKg, setWeightKg] = useState(12.5);
  const [gender, setGender] = useState<'Male' | 'Female'>('Male');
  const [category, setCategory] = useState<Pet['category']>('Companion');
  const [notes, setNotes] = useState('');
  const [allergies, setAllergies] = useState('');
  const [selectedPhoto, setSelectedPhoto] = useState(PRESET_PET_PHOTOS[0].url);

  if (!isOpen) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) return;

    const newPet: Pet = {
      id: Date.now(),
      name: name.trim(),
      animalType: species,
      breed: breed.trim() || 'Mixed Breed',
      age: Number(age),
      gender,
      weightKg: Number(weightKg),
      category,
      imageUrl: selectedPhoto,
      notes: notes.trim(),
      disease: allergies.trim() || 'None reported',
      lastCheckup: new Date().toISOString().split('T')[0],
      lastVaccination: new Date().toISOString().split('T')[0],
      avatarBg: '#edf4f0',
      availableForAdoption: false
    };

    onAddPet(newPet);
    onClose();
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-card" onClick={e => e.stopPropagation()}>
        <div className="modal-header">
          <div>
            <h2 className="modal-title">Add a Pet</h2>
            <p style={{ fontSize: '0.8125rem', color: 'var(--text-secondary)', marginTop: 2 }}>
              Create a personalized profile for your furry family member.
            </p>
          </div>
          <button onClick={onClose} style={{ color: 'var(--text-muted)' }} aria-label="Close">
            <X style={{ width: 22, height: 22 }} />
          </button>
        </div>

        <form onSubmit={handleSubmit}>
          {/* Photo Picker */}
          <div style={{ marginBottom: 20 }}>
            <label className="form-label" style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
              <Camera style={{ width: 14, height: 14 }} />
              Choose a Profile Photo
            </label>
            <div style={{ display: 'flex', gap: 10, overflowX: 'auto', paddingBottom: 6 }}>
              {PRESET_PET_PHOTOS.map((p, idx) => (
                <button
                  type="button"
                  key={idx}
                  onClick={() => setSelectedPhoto(p.url)}
                  style={{
                    width: 60,
                    height: 60,
                    borderRadius: 14,
                    overflow: 'hidden',
                    border: selectedPhoto === p.url ? '3px solid var(--primary)' : '2px solid var(--border-color)',
                    flexShrink: 0,
                    position: 'relative'
                  }}
                >
                  <img src={p.url} alt={p.label} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                </button>
              ))}
            </div>
          </div>

          <div className="form-group">
            <label className="form-label">Pet Name *</label>
            <input
              type="text"
              required
              className="form-control"
              placeholder="e.g. Mochi, Biscuit, Cleo"
              value={name}
              onChange={e => setName(e.target.value)}
            />
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
            <div className="form-group">
              <label className="form-label">Pet Type *</label>
              <select
                className="form-control"
                value={species}
                onChange={e => setSpecies(e.target.value as any)}
              >
                <option value="Dog">Dog</option>
                <option value="Cat">Cat</option>
                <option value="Rabbit">Rabbit</option>
                <option value="Bird">Bird</option>
                <option value="Other">Other</option>
              </select>
            </div>

            <div className="form-group">
              <label className="form-label">Breed</label>
              <input
                type="text"
                className="form-control"
                placeholder="e.g. Golden Retriever"
                value={breed}
                onChange={e => setBreed(e.target.value)}
              />
            </div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 12 }}>
            <div className="form-group">
              <label className="form-label">Age (Years)</label>
              <input
                type="number"
                min="0"
                max="35"
                className="form-control"
                value={age}
                onChange={e => setAge(Number(e.target.value))}
              />
            </div>

            <div className="form-group">
              <label className="form-label">Weight (kg)</label>
              <input
                type="number"
                step="0.1"
                min="0.1"
                className="form-control"
                value={weightKg}
                onChange={e => setWeightKg(Number(e.target.value))}
              />
            </div>

            <div className="form-group">
              <label className="form-label">Sex</label>
              <select
                className="form-control"
                value={gender}
                onChange={e => setGender(e.target.value as any)}
              >
                <option value="Male">Male</option>
                <option value="Female">Female</option>
              </select>
            </div>
          </div>

          <div className="form-group">
            <label className="form-label">Known Allergies / Health Conditions</label>
            <input
              type="text"
              className="form-control"
              placeholder="e.g. Grass pollen, Chicken sensitivity, or None"
              value={allergies}
              onChange={e => setAllergies(e.target.value)}
            />
          </div>

          <div className="form-group">
            <label className="form-label">Special Notes / Personality</label>
            <textarea
              rows={2}
              className="form-control"
              placeholder="e.g. Loves belly rubs, scared of thunder, microchipped"
              value={notes}
              onChange={e => setNotes(e.target.value)}
            />
          </div>

          <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 12, marginTop: 24 }}>
            <button type="button" className="btn btn-secondary" onClick={onClose}>
              Cancel
            </button>
            <button type="submit" className="btn btn-primary">
              <Sparkles style={{ width: 16, height: 16 }} />
              <span>Save Pet Profile</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
