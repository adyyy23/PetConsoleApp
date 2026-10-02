import React from 'react';
import {
  PawPrint,
  Clock,
  HeartPulse,
  Calendar,
  CheckCircle,
  Shield,
  Sparkles,
  ArrowRight,
  Heart,
  FileText,
  BellRing
} from 'lucide-react';
import { PawlyLogo } from './brand/PawlyLogo';

interface LandingPageProps {
  onStartAuth: (mode: 'login' | 'signup') => void;
  onExploreDemo: () => void;
}

export const LandingPage: React.FC<LandingPageProps> = ({ onStartAuth, onExploreDemo }) => {
  return (
    <div style={{ backgroundColor: 'var(--bg-app)', minHeight: '100vh' }}>
      {/* ========================================================
          1. HERO SECTION
          ======================================================== */}
      <section className="hero-section">
        <div className="hero-grid">
          <div>
            <div className="hero-badge">
              <Sparkles style={{ width: 14, height: 14, color: 'var(--primary)' }} />
              <span>The warm, modern companion for pet owners</span>
            </div>

            <h1 className="hero-title">
              Everything your pet needs, <br />
              <span style={{ color: 'var(--primary)' }}>in one place.</span>
            </h1>

            <p className="hero-subtitle">
              Keep health records, daily routines, medication reminders, and vet appointments effortlessly organized around your pet.
            </p>

            <div className="hero-actions">
              <button className="btn btn-primary btn-lg" onClick={() => onStartAuth('signup')}>
                <span>Create free account</span>
                <ArrowRight style={{ width: 16, height: 16 }} />
              </button>

              <button className="btn btn-secondary btn-lg" onClick={onExploreDemo}>
                <span>Explore Live Demo</span>
              </button>
            </div>

            <div style={{ display: 'flex', alignItems: 'center', gap: 16, marginTop: 32, fontSize: '0.8125rem', color: 'var(--text-muted)' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
                <CheckCircle style={{ width: 15, height: 15, color: 'var(--primary)' }} />
                <span>Zero clinical jargon</span>
              </div>
              <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
                <CheckCircle style={{ width: 15, height: 15, color: 'var(--primary)' }} />
                <span>Works on phone & desktop</span>
              </div>
              <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
                <CheckCircle style={{ width: 15, height: 15, color: 'var(--primary)' }} />
                <span>100% Free for pet parents</span>
              </div>
            </div>
          </div>

          {/* Hero Visual Preview */}
          <div className="hero-visual-card">
            <div className="hero-pet-banner">
              <img
                src="https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=1000&q=80"
                alt="Golden Retriever Mochi"
              />
              <div className="hero-pet-pill">
                <div style={{ width: 8, height: 8, borderRadius: '50%', backgroundColor: '#4ade80' }} />
                <span>Mochi • 3 years old • Golden Retriever</span>
              </div>
            </div>

            {/* Simulated Live Care Reminder Card */}
            <div className="hero-floating-reminder">
              <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                <div
                  style={{
                    width: 36,
                    height: 36,
                    borderRadius: 10,
                    backgroundColor: 'var(--accent-honey-light)',
                    color: 'var(--accent-honey)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center'
                  }}
                >
                  <Clock style={{ width: 18, height: 18 }} />
                </div>
                <div>
                  <div style={{ fontSize: '0.875rem', fontWeight: 700, color: 'var(--text-primary)' }}>
                    Allergy medication due
                  </div>
                  <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>
                    Today at 8:00 AM • Apoquel 16mg with breakfast
                  </div>
                </div>
              </div>
              <span className="badge badge-sage">Scheduled</span>
            </div>

            {/* Upcoming Vet Appointment Card */}
            <div
              style={{
                marginTop: 10,
                backgroundColor: 'var(--bg-surface)',
                border: '1px solid var(--border-color)',
                borderRadius: 'var(--radius-md)',
                padding: '12px 16px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between'
              }}
            >
              <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                <Calendar style={{ width: 16, height: 16, color: 'var(--primary)' }} />
                <span style={{ fontSize: '0.8125rem', color: 'var(--text-secondary)' }}>
                  Vet Consultation with <strong>Dr. Sarah Ramos</strong>
                </span>
              </div>
              <span style={{ fontSize: '0.75rem', fontWeight: 600, color: 'var(--primary)' }}>Oct 02 · 10:30 AM</span>
            </div>
          </div>
        </div>
      </section>

      {/* ========================================================
          2. YOUR PET'S LIFE, ORGANIZED
          ======================================================== */}
      <section className="story-section" id="landing-features">
        <div className="story-container">
          <div style={{ textAlign: 'center', maxWidth: 680, margin: '0 auto' }}>
            <div className="section-label">Your pet's life, organized</div>
            <h2 className="section-heading">Designed for pet parents, not hospital administrators</h2>
            <p className="section-subheading" style={{ margin: '0 auto' }}>
              Unlike complicated clinic software or forgotten paper booklets, Pawly brings every vaccination, feeding routine, and vet checkup right to your fingertips.
            </p>
          </div>

          <div className="feature-split" style={{ marginTop: 56 }}>
            <div className="feature-list">
              <div className="feature-point">
                <div className="feature-point-icon">
                  <PawPrint style={{ width: 20, height: 20 }} />
                </div>
                <div>
                  <h3 className="feature-point-title">Personal Pet Profiles</h3>
                  <p className="feature-point-desc">
                    Keep your pets' birthdays, microchip numbers, weight history, and quirks together in a warm digital passport.
                  </p>
                </div>
              </div>

              <div className="feature-point">
                <div className="feature-point-icon" style={{ backgroundColor: 'var(--accent-honey-light)', color: 'var(--accent-honey)' }}>
                  <Clock style={{ width: 20, height: 20 }} />
                </div>
                <div>
                  <h3 className="feature-point-title">Everyday Care Reminders</h3>
                  <p className="feature-point-desc">
                    Never second-guess whether heartworm medication was given or when the next flea treatment is due.
                  </p>
                </div>
              </div>

              <div className="feature-point">
                <div className="feature-point-icon" style={{ backgroundColor: 'var(--accent-clay-light)', color: 'var(--accent-clay)' }}>
                  <HeartPulse style={{ width: 20, height: 20 }} />
                </div>
                <div>
                  <h3 className="feature-point-title">Clear Medical Timeline</h3>
                  <p className="feature-point-desc">
                    Read your pet’s health history in human language. Have boosters, dosages, and doctor notes ready whenever you visit the vet.
                  </p>
                </div>
              </div>

              <div className="feature-point">
                <div className="feature-point-icon" style={{ backgroundColor: 'var(--accent-blue-light)', color: 'var(--accent-blue)' }}>
                  <Calendar style={{ width: 20, height: 20 }} />
                </div>
                <div>
                  <h3 className="feature-point-title">Vet Visits & Checkups</h3>
                  <p className="feature-point-desc">
                    Keep track of appointments, doctors, clinics, and reasons for each visit without digging through email confirmations.
                  </p>
                </div>
              </div>
            </div>

            {/* Visual showcase */}
            <div
              style={{
                backgroundColor: 'var(--bg-surface)',
                border: '1px solid var(--border-color)',
                borderRadius: 'var(--radius-xl)',
                padding: '28px',
                boxShadow: 'var(--shadow-sm)'
              }}
            >
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 20 }}>
                <div style={{ fontWeight: 700, fontSize: '1rem', color: 'var(--text-primary)' }}>
                  Today's Care Routine
                </div>
                <span className="badge badge-sage">3 tasks scheduled</span>
              </div>

              <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
                <div
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: 12,
                    padding: '12px 14px',
                    borderRadius: 'var(--radius-md)',
                    backgroundColor: 'var(--bg-subtle)'
                  }}
                >
                  <div style={{ width: 20, height: 20, borderRadius: 4, backgroundColor: 'var(--primary)', color: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                    <CheckCircle style={{ width: 14, height: 14 }} />
                  </div>
                  <div>
                    <div style={{ fontSize: '0.875rem', fontWeight: 600, textDecoration: 'line-through', color: 'var(--text-muted)' }}>
                      Morning exercise & recall drill
                    </div>
                    <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>Mochi · 7:30 AM</div>
                  </div>
                </div>

                <div
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: 12,
                    padding: '12px 14px',
                    borderRadius: 'var(--radius-md)',
                    border: '1px solid var(--border-color)',
                    backgroundColor: 'var(--bg-surface)'
                  }}
                >
                  <div style={{ width: 20, height: 20, borderRadius: 4, border: '2px solid #ccc', backgroundColor: '#fff' }} />
                  <div>
                    <div style={{ fontSize: '0.875rem', fontWeight: 600, color: 'var(--text-primary)' }}>
                      Allergy medication (Apoquel 16mg)
                    </div>
                    <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>Mochi · Today at 8:00 AM</div>
                  </div>
                  <span className="badge badge-rose" style={{ marginLeft: 'auto' }}>High</span>
                </div>

                <div
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: 12,
                    padding: '12px 14px',
                    borderRadius: 'var(--radius-md)',
                    border: '1px solid var(--border-color)',
                    backgroundColor: 'var(--bg-surface)'
                  }}
                >
                  <div style={{ width: 20, height: 20, borderRadius: 4, border: '2px solid #ccc', backgroundColor: '#fff' }} />
                  <div>
                    <div style={{ fontSize: '0.875rem', fontWeight: 600, color: 'var(--text-primary)' }}>
                      Undercoat deshedding brush session
                    </div>
                    <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>Luna · Today at 6:00 PM</div>
                  </div>
                  <span className="badge badge-honey" style={{ marginLeft: 'auto' }}>Regular</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ========================================================
          3. EVERYTHING ABOUT THEM — PET PROFILE SHOWCASE
          ======================================================== */}
      <section className="story-section" id="landing-care" style={{ backgroundColor: 'var(--bg-surface)' }}>
        <div className="story-container">
          <div className="feature-split">
            <div style={{ order: 1 }}>
              <div className="section-label">Everything about them</div>
              <h2 className="section-heading">A dedicated digital passport for every companion</h2>
              <p className="section-subheading">
                Whether you have one playful puppy, a quiet senior cat, or a multi-pet household, Pawly gives each companion their own focused space.
              </p>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16, marginTop: 28 }}>
                <div style={{ padding: '16px', borderRadius: 'var(--radius-md)', backgroundColor: 'var(--bg-subtle)' }}>
                  <div style={{ fontWeight: 700, fontSize: '0.9375rem', color: 'var(--text-primary)' }}>
                    Physical & Vitals
                  </div>
                  <div style={{ fontSize: '0.8125rem', color: 'var(--text-secondary)', marginTop: 4 }}>
                    Track weight progressions, birth dates, and physical checkups effortlessly.
                  </div>
                </div>

                <div style={{ padding: '16px', borderRadius: 'var(--radius-md)', backgroundColor: 'var(--bg-subtle)' }}>
                  <div style={{ fontWeight: 700, fontSize: '0.9375rem', color: 'var(--text-primary)' }}>
                    Allergies & Sensitivities
                  </div>
                  <div style={{ fontSize: '0.8125rem', color: 'var(--text-secondary)', marginTop: 4 }}>
                    Keep dietary restrictions and seasonal sensitivities front and center.
                  </div>
                </div>
              </div>
            </div>

            {/* Profile Card Preview */}
            <div
              style={{
                order: 2,
                backgroundColor: 'var(--bg-app)',
                border: '1px solid var(--border-color)',
                borderRadius: 'var(--radius-xl)',
                padding: '24px',
                boxShadow: 'var(--shadow-sm)'
              }}
            >
              <div style={{ display: 'flex', alignItems: 'center', gap: 16, marginBottom: 20 }}>
                <img
                  src="https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=300&q=80"
                  alt="Luna the cat"
                  style={{ width: 72, height: 72, borderRadius: 16, objectFit: 'cover' }}
                />
                <div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                    <h3 style={{ fontSize: '1.25rem', fontWeight: 800, color: 'var(--text-primary)' }}>Luna</h3>
                    <span className="badge badge-sage">Companion</span>
                  </div>
                  <div style={{ fontSize: '0.8125rem', color: 'var(--text-muted)' }}>
                    British Shorthair • 2 years old • Female
                  </div>
                  <div style={{ fontSize: '0.75rem', color: 'var(--text-secondary)', marginTop: 4 }}>
                    Weight: <strong>4.2 kg</strong> • Microchip: <strong>#985-1410</strong>
                  </div>
                </div>
              </div>

              <div style={{ borderTop: '1px solid var(--border-color)', paddingTop: 16, display: 'flex', flexDirection: 'column', gap: 10 }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.8125rem' }}>
                  <span style={{ color: 'var(--text-muted)' }}>Last Checkup:</span>
                  <span style={{ fontWeight: 600 }}>July 10, 2026 (Metro Pet Hospital)</span>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.8125rem' }}>
                  <span style={{ color: 'var(--text-muted)' }}>Last Vaccination:</span>
                  <span style={{ fontWeight: 600 }}>Feline FVRCP Annual Booster</span>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.8125rem' }}>
                  <span style={{ color: 'var(--text-muted)' }}>Special Notes:</span>
                  <span style={{ color: 'var(--primary)', fontWeight: 600 }}>Calm, sensitive to loud sounds</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ========================================================
          4. HEALTH HISTORY WITHOUT THE PAPERWORK
          ======================================================== */}
      <section className="story-section" id="landing-how">
        <div className="story-container">
          <div style={{ textAlign: 'center', maxWidth: 680, margin: '0 auto 48px' }}>
            <div className="section-label">Medical clarity</div>
            <h2 className="section-heading">Health history without the paperwork</h2>
            <p className="section-subheading" style={{ margin: '0 auto' }}>
              No more searching through file folders or deciphering scribbled clinical slips. Pawly records treatments in a clean, chronological timeline.
            </p>
          </div>

          <div style={{ maxWidth: 760, margin: '0 auto' }}>
            <div className="story-timeline-card">
              <div className="story-timeline-item">
                <div className="timeline-dot">
                  <HeartPulse style={{ width: 18, height: 18 }} />
                </div>
                <div style={{ flex: 1 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                    <div>
                      <span className="badge badge-sage" style={{ marginBottom: 4 }}>Vaccination</span>
                      <h4 style={{ fontWeight: 700, fontSize: '1rem', color: 'var(--text-primary)' }}>
                        Core Canine Booster (DHPP + Leptospirosis)
                      </h4>
                    </div>
                    <span style={{ fontSize: '0.8125rem', color: 'var(--text-muted)', fontWeight: 600 }}>Aug 15, 2026</span>
                  </div>
                  <p style={{ fontSize: '0.875rem', color: 'var(--text-secondary)', marginTop: 6, lineHeight: 1.5 }}>
                    Mochi received the subcutaneous booster. Temperature 38.4°C normal. No adverse reactions observed.
                  </p>
                  <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)', marginTop: 8 }}>
                    Dr. Sarah Ramos, DVM • CityVet Wellness Center
                  </div>
                </div>
              </div>

              <div className="story-timeline-item">
                <div className="timeline-dot" style={{ backgroundColor: 'var(--accent-honey-light)', color: 'var(--accent-honey)' }}>
                  <Shield style={{ width: 18, height: 18 }} />
                </div>
                <div style={{ flex: 1 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                    <div>
                      <span className="badge badge-honey" style={{ marginBottom: 4 }}>Annual Checkup</span>
                      <h4 style={{ fontWeight: 700, fontSize: '1rem', color: 'var(--text-primary)' }}>
                        Comprehensive Physical & Vitals Check
                      </h4>
                    </div>
                    <span style={{ fontSize: '0.8125rem', color: 'var(--text-muted)', fontWeight: 600 }}>Jul 10, 2026</span>
                  </div>
                  <p style={{ fontSize: '0.875rem', color: 'var(--text-secondary)', marginTop: 6, lineHeight: 1.5 }}>
                    Eyes and ears clear. Heart and lungs auscultated normal. Mild distal paw redness consistent with seasonal contact allergy.
                  </p>
                  <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)', marginTop: 8 }}>
                    Dr. Sarah Ramos, DVM • CityVet Wellness Center
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ========================================================
          5. CALL TO ACTION BANNER
          ======================================================== */}
      <section style={{ padding: '0 24px' }}>
        <div className="cta-banner">
          <h2>Ready to make pet care simpler?</h2>
          <p>
            Join pet parents who keep their pets happy, healthy, and on routine with Pawly.
          </p>
          <div style={{ display: 'flex', justifyContent: 'center', gap: 14, flexWrap: 'wrap' }}>
            <button
              className="btn btn-clay btn-lg"
              onClick={() => onStartAuth('signup')}
            >
              <span>Create your free account</span>
              <ArrowRight style={{ width: 16, height: 16 }} />
            </button>
            <button
              className="btn btn-secondary btn-lg"
              onClick={onExploreDemo}
            >
              <span>Try with demo pets</span>
            </button>
          </div>
        </div>
      </section>

      {/* ========================================================
          6. FOOTER
          ======================================================== */}
      <footer className="public-footer">
        <div className="footer-inner">
          <PawlyLogo size="sm" showTagline />

          <div style={{ fontSize: '0.8125rem', color: 'var(--text-muted)' }}>
            Pawly • Everything your pet needs, in one place. Crafted for individual pet owners.
          </div>

          <div style={{ display: 'flex', gap: 16, fontSize: '0.8125rem', color: 'var(--text-secondary)' }}>
            <button onClick={() => onStartAuth('login')} className="nav-text-btn">Log in</button>
            <button onClick={() => onStartAuth('signup')} className="nav-text-btn">Sign up</button>
          </div>
        </div>
      </footer>
    </div>
  );
};
