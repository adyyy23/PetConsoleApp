import React, { useState } from 'react';
import { Sparkles, ArrowRight, Camera, Check } from 'lucide-react';
import { PawlyLogo } from './brand/PawlyLogo';
import { Pet, User } from '../types';

interface OnboardingProps {
  user: User;
  onComplete: (firstPet: Pet) => void;
}

const ONBOARDING_PHOTOS = [
  { label: 'Golden Retriever', url: 'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=600&q=80' },
  { label: 'Corgi', url: 'https://images.unsplash.com/photo-1546975490-e8b92a360b24?auto=format&fit=crop&w=600&q=80' },
  { label: 'British Shorthair Cat', url: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=600&q=80' },
  { label: 'Ginger Cat', url: 'https://images.unsplash.com/photo-1574158622682-e40e69881006?auto=format&fit=crop&w=600&q=80' },
  { label: 'Bunny', url: 'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?auto=format&fit=crop&w=600&q=80' }
];

export const Onboarding: React.FC<OnboardingProps> = ({ user, onComplete }) => {
  const [step, setStep] = useState<'form' | 'celebrate'>('form');
  const [name, setName] = useState('');
  const [animalType, setAnimalType] = useState<Pet['animalType']>('Dog');
  const [breed, setBreed] = useState('');
  const [age, setAge] = useState(2);
  const [gender, setGender] = useState<'Male' | 'Female'>('Male');
  const [weightKg, setWeightKg] = useState(14.0);
  const [notes, setNotes] = useState('');
  const [photo, setPhoto] = useState(ONBOARDING_PHOTOS[0].url);
  const [createdPet, setCreatedPet] = useState<Pet | null>(null);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) return;

    const pet: Pet = {
      id: Date.now(),
      name: name.trim(),
      animalType,
      breed: breed.trim() || (animalType === 'Dog' ? 'Golden Retriever' : 'Domestic Shorthair'),
      age: Number(age),
      gender,
      weightKg: Number(weightKg),
      category: 'Companion',
      imageUrl: photo,
      notes: notes.trim(),
      disease: 'None reported',
      lastCheckup: new Date().toISOString().split('T')[0],
      lastVaccination: new Date().toISOString().split('T')[0],
      avatarBg: '#edf4f0',
      availableForAdoption: false
    };

    setCreatedPet(pet);
    setStep('celebrate');
  };

  const handleFinish = () => {
    if (createdPet) {
      onComplete(createdPet);
    }
  };

  return (
    <div
      style={{
        minHeight: '100vh',
        backgroundColor: 'var(--bg-app)',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '32px 20px'
      }}
    >
      <div style={{ marginBottom: 24 }}>
        <PawlyLogo size="md" />
      </div>

      {step === 'form' ? (
        <div
          className="pawly-card"
          style={{
            maxWidth: 520,
            width: '100%',
            padding: '36px 32px',
            boxShadow: 'var(--shadow-md)'
          }}
        >
          <div style={{ marginBottom: 24 }}>
            <div style={{ fontSize: '0.75rem', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.08em', color: 'var(--primary)', marginBottom: 6 }}>
              Step 1 of 1 • Pet Setup
            </div>
            <h2 style={{ fontSize: '1.625rem', fontWeight: 800, color: 'var(--text-primary)', letterSpacing: '-0.02em' }}>
              Welcome to Pawly, {user.name}.
            </h2>
            <p style={{ fontSize: '0.875rem', color: 'var(--text-secondary)', marginTop: 4 }}>
              Let’s add your first pet so you can start organizing their daily care and health.
            </p>
          </div>

          <form onSubmit={handleSubmit}>
            {/* Photo Selector */}
            <div style={{ marginBottom: 20 }}>
              <label className="form-label">Choose an avatar or portrait</label>
              <div style={{ display: 'flex', gap: 10, overflowX: 'auto', paddingBottom: 4 }}>
                {ONBOARDING_PHOTOS.map((p, i) => (
                  <button
                    key={i}
                    type="button"
                    onClick={() => setPhoto(p.url)}
                    style={{
                      width: 58,
                      height: 58,
                      borderRadius: 14,
                      overflow: 'hidden',
                      border: photo === p.url ? '3px solid var(--primary)' : '2px solid var(--border-color)',
                      flexShrink: 0
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
                placeholder="e.g. Mochi, Barnaby, Luna"
                value={name}
                onChange={e => setName(e.target.value)}
              />
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
              <div className="form-group">
                <label className="form-label">Pet Type *</label>
                <select
                  className="form-control"
                  value={animalType}
                  onChange={e => setAnimalType(e.target.value as any)}
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
            </div>

            <div className="form-group">
              <label className="form-label">Favorite activities or special notes (optional)</label>
              <textarea
                rows={2}
                className="form-control"
                placeholder="e.g. Loves belly rubs and morning frisbee"
                value={notes}
                onChange={e => setNotes(e.target.value)}
              />
            </div>

            <button type="submit" className="btn btn-primary btn-lg" style={{ width: '100%', marginTop: 8 }}>
              <span>Create Pet Profile</span>
              <ArrowRight style={{ width: 16, height: 16 }} />
            </button>
          </form>
        </div>
      ) : (
        /* Celebration Step */
        <div
          className="pawly-card"
          style={{
            maxWidth: 460,
            width: '100%',
            padding: '40px 32px',
            textAlign: 'center',
            boxShadow: 'var(--shadow-md)'
          }}
        >
          <div
            style={{
              width: 110,
              height: 110,
              borderRadius: '50%',
              overflow: 'hidden',
              margin: '0 auto 20px',
              border: '4px solid var(--primary-border)',
              boxShadow: '0 4px 16px rgba(61, 103, 82, 0.15)'
            }}
          >
            <img
              src={createdPet?.imageUrl}
              alt={createdPet?.name}
              style={{ width: '100%', height: '100%', objectFit: 'cover' }}
            />
          </div>

          <div style={{ display: 'inline-flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
            <h2 style={{ fontSize: '1.75rem', fontWeight: 800, color: 'var(--text-primary)', letterSpacing: '-0.03em' }}>
              Meet {createdPet?.name}
            </h2>
            <div
              style={{
                width: 28,
                height: 28,
                borderRadius: '50%',
                backgroundColor: 'var(--primary)',
                color: '#ffffff',
                display: 'inline-flex',
                alignItems: 'center',
                justifyContent: 'center'
              }}
            >
              <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                <ellipse cx="12" cy="14" rx="4.5" ry="3.8" />
                <circle cx="7" cy="8.5" r="2.2" />
                <circle cx="10.5" cy="5.8" r="2.2" />
                <circle cx="13.5" cy="5.8" r="2.2" />
                <circle cx="17" cy="8.5" r="2.2" />
              </svg>
            </div>
          </div>

          <p style={{ fontSize: '0.9375rem', color: 'var(--text-secondary)', marginBottom: 24 }}>
            {createdPet?.animalType} • {createdPet?.breed} • {createdPet?.age} year{createdPet && createdPet.age > 1 ? 's' : ''} old
          </p>

          <p style={{ fontSize: '0.875rem', color: 'var(--text-muted)', marginBottom: 28 }}>
            Your pet’s space has been configured. Let’s jump into your personalized home and view upcoming care routines.
          </p>

          <button
            type="button"
            className="btn btn-primary btn-lg"
            style={{ width: '100%' }}
            onClick={handleFinish}
          >
            <span>Enter Pawly</span>
            <ArrowRight style={{ width: 16, height: 16 }} />
          </button>
        </div>
      )}
    </div>
  );
};
