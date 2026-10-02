import React, { useState } from 'react';
import { X, Send, Heart, CheckCircle2 } from 'lucide-react';
import { Pet } from '../../types';

interface AdoptionInquiryModalProps {
  isOpen: boolean;
  onClose: () => void;
  pet: Pet | null;
  onSubmitInquiry: (petId: number, name: string, message: string) => void;
}

export const AdoptionInquiryModal: React.FC<AdoptionInquiryModalProps> = ({
  isOpen,
  onClose,
  pet,
  onSubmitInquiry
}) => {
  const [applicantName, setApplicantName] = useState('Lady');
  const [email, setEmail] = useState('lady@pawly.app');
  const [phone, setPhone] = useState('(555) 392-8821');
  const [livingSituation, setLivingSituation] = useState('Own home with fenced yard');
  const [message, setMessage] = useState('');
  const [submitted, setSubmitted] = useState(false);

  if (!isOpen || !pet) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSubmitInquiry(pet.id, applicantName, message);
    setSubmitted(true);
    setTimeout(() => {
      setSubmitted(false);
      onClose();
    }, 1800);
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-card" onClick={e => e.stopPropagation()}>
        <div className="modal-header">
          <div>
            <h2 className="modal-title">Adopt {pet.name}</h2>
            <p style={{ fontSize: '0.8125rem', color: 'var(--text-secondary)', marginTop: 2 }}>
              Send an inquiry to connect with the foster guardian.
            </p>
          </div>
          <button onClick={onClose} style={{ color: 'var(--text-muted)' }} aria-label="Close">
            <X style={{ width: 22, height: 22 }} />
          </button>
        </div>

        {submitted ? (
          <div style={{ textAlign: 'center', padding: '36px 12px' }}>
            <div
              style={{
                width: 52,
                height: 52,
                borderRadius: '50%',
                backgroundColor: 'var(--primary-light)',
                color: 'var(--primary)',
                display: 'inline-flex',
                alignItems: 'center',
                justifyContent: 'center',
                marginBottom: 16
              }}
            >
              <CheckCircle2 style={{ width: 30, height: 30 }} />
            </div>
            <h3 style={{ fontSize: '1.25rem', fontWeight: 800, color: 'var(--text-primary)' }}>
              Inquiry Sent!
            </h3>
            <p style={{ fontSize: '0.875rem', color: 'var(--text-secondary)', marginTop: 6, maxWidth: 360, margin: '6px auto 0' }}>
              Thank you for caring about {pet.name}. The foster coordinator will contact you at {email}.
            </p>
          </div>
        ) : (
          <form onSubmit={handleSubmit}>
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: 14,
                padding: '12px 14px',
                borderRadius: 'var(--radius-md)',
                backgroundColor: 'var(--bg-subtle)',
                marginBottom: 20
              }}
            >
              <img
                src={pet.imageUrl || 'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=150&q=80'}
                alt={pet.name}
                style={{ width: 48, height: 48, borderRadius: 10, objectFit: 'cover' }}
              />
              <div>
                <div style={{ fontWeight: 700, fontSize: '0.9375rem', color: 'var(--text-primary)' }}>
                  {pet.name}
                </div>
                <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>
                  {pet.animalType} • {pet.breed} • {pet.age} year{pet.age > 1 ? 's' : ''} old
                </div>
              </div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
              <div className="form-group">
                <label className="form-label">Your Name *</label>
                <input
                  type="text"
                  required
                  className="form-control"
                  value={applicantName}
                  onChange={e => setApplicantName(e.target.value)}
                />
              </div>

              <div className="form-group">
                <label className="form-label">Email Address *</label>
                <input
                  type="email"
                  required
                  className="form-control"
                  value={email}
                  onChange={e => setEmail(e.target.value)}
                />
              </div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
              <div className="form-group">
                <label className="form-label">Phone Number</label>
                <input
                  type="tel"
                  className="form-control"
                  value={phone}
                  onChange={e => setPhone(e.target.value)}
                />
              </div>

              <div className="form-group">
                <label className="form-label">Home Type</label>
                <input
                  type="text"
                  className="form-control"
                  value={livingSituation}
                  onChange={e => setLivingSituation(e.target.value)}
                />
              </div>
            </div>

            <div className="form-group">
              <label className="form-label">Tell us why you would be a great home for {pet.name}</label>
              <textarea
                rows={3}
                required
                className="form-control"
                placeholder={`Tell us about your household routines, other pets, and experience...`}
                value={message}
                onChange={e => setMessage(e.target.value)}
              />
            </div>

            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 12, marginTop: 24 }}>
              <button type="button" className="btn btn-secondary" onClick={onClose}>
                Cancel
              </button>
              <button type="submit" className="btn btn-clay">
                <Heart style={{ width: 16, height: 16 }} />
                <span>Submit Inquiry</span>
              </button>
            </div>
          </form>
        )}
      </div>
    </div>
  );
};
