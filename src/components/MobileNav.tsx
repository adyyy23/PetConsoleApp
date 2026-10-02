import React, { useState } from 'react';
import { Home, PawPrint, Clock, HeartPulse, MoreHorizontal, Calendar, Compass, LogOut, X, Plus } from 'lucide-react';
import { User } from '../types';

interface MobileNavProps {
  currentUser: User | null;
  activeRoute: string;
  onNavigate: (route: string) => void;
  onLogout: () => void;
  onOpenAddPet: () => void;
}

export const MobileNav: React.FC<MobileNavProps> = ({
  currentUser,
  activeRoute,
  onNavigate,
  onLogout,
  onOpenAddPet
}) => {
  const [moreSheetOpen, setMoreSheetOpen] = useState(false);

  if (!currentUser) return null;

  return (
    <>
      <nav className="mobile-bottom-nav">
        <button
          className={`mobile-bottom-link ${activeRoute === 'home' ? 'active' : ''}`}
          onClick={() => onNavigate('home')}
        >
          <Home style={{ width: 20, height: 20 }} />
          <span>Home</span>
        </button>

        <button
          className={`mobile-bottom-link ${activeRoute === 'pets' || activeRoute === 'pet-profile' ? 'active' : ''}`}
          onClick={() => onNavigate('pets')}
        >
          <PawPrint style={{ width: 20, height: 20 }} />
          <span>Pets</span>
        </button>

        <button
          className={`mobile-bottom-link ${activeRoute === 'care' ? 'active' : ''}`}
          onClick={() => onNavigate('care')}
        >
          <Clock style={{ width: 20, height: 20 }} />
          <span>Care</span>
        </button>

        <button
          className={`mobile-bottom-link ${activeRoute === 'health' ? 'active' : ''}`}
          onClick={() => onNavigate('health')}
        >
          <HeartPulse style={{ width: 20, height: 20 }} />
          <span>Health</span>
        </button>

        <button
          className={`mobile-bottom-link ${['appointments', 'discover'].includes(activeRoute) ? 'active' : ''}`}
          onClick={() => setMoreSheetOpen(true)}
        >
          <MoreHorizontal style={{ width: 20, height: 20 }} />
          <span>More</span>
        </button>
      </nav>

      {/* Mobile "More" Drawer */}
      {moreSheetOpen && (
        <div className="modal-overlay" onClick={() => setMoreSheetOpen(false)}>
          <div
            className="modal-card"
            style={{
              position: 'fixed',
              bottom: 0,
              left: 0,
              right: 0,
              borderRadius: '24px 24px 0 0',
              maxHeight: '80vh',
              margin: 0,
              padding: 24
            }}
            onClick={e => e.stopPropagation()}
          >
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
              <div style={{ fontWeight: 800, fontSize: '1.125rem' }}>Menu</div>
              <button onClick={() => setMoreSheetOpen(false)} aria-label="Close">
                <X style={{ width: 20, height: 20, color: 'var(--text-muted)' }} />
              </button>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
              <button
                className="btn btn-secondary"
                style={{ justifyContent: 'flex-start', padding: '12px 16px', borderRadius: 'var(--radius-md)' }}
                onClick={() => {
                  setMoreSheetOpen(false);
                  onNavigate('appointments');
                }}
              >
                <Calendar style={{ width: 18, height: 18, color: 'var(--primary)' }} />
                <span>Appointments</span>
              </button>

              <button
                className="btn btn-secondary"
                style={{ justifyContent: 'flex-start', padding: '12px 16px', borderRadius: 'var(--radius-md)' }}
                onClick={() => {
                  setMoreSheetOpen(false);
                  onNavigate('discover');
                }}
              >
                <Compass style={{ width: 18, height: 18, color: 'var(--accent-clay)' }} />
                <span>Browse Adoptions</span>
              </button>

              <button
                className="btn btn-secondary"
                style={{ justifyContent: 'flex-start', padding: '12px 16px', borderRadius: 'var(--radius-md)' }}
                onClick={() => {
                  setMoreSheetOpen(false);
                  onOpenAddPet();
                }}
              >
                <Plus style={{ width: 18, height: 18, color: 'var(--primary)' }} />
                <span>Add a New Pet</span>
              </button>

              <div style={{ borderTop: '1px solid var(--border-color)', marginTop: 12, paddingTop: 12 }}>
                <div style={{ fontSize: '0.8125rem', color: 'var(--text-muted)', marginBottom: 8, paddingLeft: 4 }}>
                  Signed in as <strong>{currentUser.name}</strong> ({currentUser.email})
                </div>
                <button
                  className="btn btn-secondary"
                  style={{ justifyContent: 'flex-start', width: '100%', color: 'var(--accent-rose)' }}
                  onClick={() => {
                    setMoreSheetOpen(false);
                    onLogout();
                  }}
                >
                  <LogOut style={{ width: 18, height: 18 }} />
                  <span>Log out</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
};
