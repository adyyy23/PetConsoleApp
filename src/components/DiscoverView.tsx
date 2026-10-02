import React, { useState } from 'react';
import { Heart, Compass, Sparkles, MapPin, CheckCircle, ArrowRight } from 'lucide-react';
import { Pet, AdoptionRecord } from '../types';
import { AdoptionInquiryModal } from './modals/AdoptionInquiryModal';

interface DiscoverViewProps {
  pets: Pet[];
  adoptions: AdoptionRecord[];
  onInquirySubmitted: (petId: number, applicantName: string, message: string) => void;
}

export const DiscoverView: React.FC<DiscoverViewProps> = ({
  pets,
  adoptions,
  onInquirySubmitted
}) => {
  const [selectedPetForInquiry, setSelectedPetForInquiry] = useState<Pet | null>(null);

  // Adoption pets are those marked availableForAdoption
  const adoptionPets = pets.filter(p => p.availableForAdoption || p.category === 'Rescue' || p.category === 'Foster');

  return (
    <div className="app-container">
      <div className="page-header">
        <div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 4 }}>
            <span style={{ fontSize: '0.8125rem', fontWeight: 700, color: 'var(--accent-clay)', textTransform: 'uppercase', letterSpacing: '0.04em' }}>
              Foster & Rescue Network
            </span>
          </div>
          <h1 className="page-title">Adopt & Foster</h1>
          <p className="page-subtitle">
            Meet gentle rescue companions looking for permanent loving homes.
          </p>
        </div>
      </div>

      {/* Discovery Cards Grid */}
      <div className="pets-collection-grid">
        {adoptionPets.map(pet => {
          const record = adoptions.find(a => a.petId === pet.id);
          const isPending = record?.status === 'Application Pending';

          return (
            <div
              key={pet.id}
              className="pet-passport-card"
              style={{ cursor: 'default' }}
            >
              <div className="pet-card-image-wrap">
                <img
                  src={pet.imageUrl || 'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?auto=format&fit=crop&w=600&q=80'}
                  alt={pet.name}
                />
                <div
                  style={{
                    position: 'absolute',
                    top: 12,
                    right: 12,
                    backgroundColor: isPending ? 'var(--accent-honey)' : 'var(--primary)',
                    color: '#ffffff',
                    padding: '4px 12px',
                    borderRadius: 'var(--radius-full)',
                    fontSize: '0.75rem',
                    fontWeight: 700
                  }}
                >
                  {isPending ? 'Pending Foster Review' : 'Available for Adoption'}
                </div>
              </div>

              <div className="pet-card-body">
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 4 }}>
                  <h3 style={{ fontSize: '1.25rem', fontWeight: 800, color: 'var(--text-primary)' }}>
                    {pet.name}
                  </h3>
                  <span style={{ fontSize: '0.8125rem', color: 'var(--text-muted)' }}>
                    {pet.gender}
                  </span>
                </div>

                <div style={{ fontSize: '0.875rem', color: 'var(--text-secondary)', marginBottom: 8 }}>
                  {pet.breed} • {pet.age} year{pet.age > 1 ? 's' : ''} old
                </div>

                <p style={{ fontSize: '0.875rem', color: 'var(--text-secondary)', lineHeight: 1.5, marginBottom: 18 }}>
                  {record?.adoptionHistory || pet.notes || 'Gentle companion cleared for adoption with vaccinated health records.'}
                </p>

                <div style={{ marginTop: 'auto', display: 'flex', alignItems: 'center', justifyContent: 'space-between', borderTop: '1px solid var(--border-subtle)', paddingTop: 14 }}>
                  <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>
                    Weight: <strong>{pet.weightKg} kg</strong>
                  </div>

                  <button
                    className="btn btn-clay btn-sm"
                    onClick={() => setSelectedPetForInquiry(pet)}
                  >
                    <Heart style={{ width: 14, height: 14 }} />
                    <span>Meet {pet.name}</span>
                  </button>
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {/* Inquiry Modal */}
      <AdoptionInquiryModal
        isOpen={!!selectedPetForInquiry}
        onClose={() => setSelectedPetForInquiry(null)}
        pet={selectedPetForInquiry}
        onSubmitInquiry={(petId, applicantName, msg) => {
          onInquirySubmitted(petId, applicantName, msg);
        }}
      />
    </div>
  );
};
