import React, { useState } from 'react';
import {
  Bell,
  Search,
  Plus,
  LogOut,
  ChevronDown,
  User as UserIcon,
  Check,
  Compass,
  Calendar,
  HeartPulse,
  Clock,
  PawPrint,
  Home
} from 'lucide-react';
import { PawlyLogo } from './brand/PawlyLogo';
import { Pet, AppNotification, User } from '../types';

interface NavbarProps {
  currentUser: User | null;
  activeRoute: string;
  onNavigate: (route: string) => void;
  pets: Pet[];
  activePetId: number;
  onSelectActivePet: (id: number) => void;
  notifications: AppNotification[];
  onMarkNotificationsRead: () => void;
  onOpenAddPet: () => void;
  onLogout: () => void;
  searchQuery: string;
  onSearchChange: (q: string) => void;
}

export const Navbar: React.FC<NavbarProps> = ({
  currentUser,
  activeRoute,
  onNavigate,
  pets,
  activePetId,
  onSelectActivePet,
  notifications,
  onMarkNotificationsRead,
  onOpenAddPet,
  onLogout,
  searchQuery,
  onSearchChange
}) => {
  const [notifOpen, setNotifOpen] = useState(false);
  const [profileOpen, setProfileOpen] = useState(false);
  const [petSelectorOpen, setPetSelectorOpen] = useState(false);

  const activePet = pets.find(p => p.id === activePetId) || pets[0];
  const unreadCount = notifications.filter(n => !n.read).length;

  // PUBLIC NAVBAR
  if (!currentUser) {
    return (
      <header className="public-header">
        <div className="header-inner">
          <div onClick={() => onNavigate('landing')}>
            <PawlyLogo />
          </div>

          <nav className="public-nav-links">
            <button className="nav-text-btn" onClick={() => onNavigate('landing-features')}>
              Features
            </button>
            <button className="nav-text-btn" onClick={() => onNavigate('landing-how')}>
              How it works
            </button>
            <button className="nav-text-btn" onClick={() => onNavigate('landing-care')}>
              Pet Care
            </button>
            <button className="nav-text-btn" onClick={() => onNavigate('discover')}>
              Adoption
            </button>
          </nav>

          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <button className="btn btn-subtle" onClick={() => onNavigate('login')}>
              Log in
            </button>
            <button className="btn btn-primary" onClick={() => onNavigate('signup')}>
              Create account
            </button>
          </div>
        </div>
      </header>
    );
  }

  // LOGGED-IN CONSUMER APP NAVBAR
  return (
    <header className="app-header">
      <div className="header-inner">
        <div style={{ display: 'flex', alignItems: 'center', gap: 28 }}>
          <div onClick={() => onNavigate('home')}>
            <PawlyLogo size="sm" />
          </div>

          {/* Desktop Nav Tabs */}
          <nav className="app-nav-tabs">
            <button
              className={`app-tab-btn ${activeRoute === 'home' ? 'active' : ''}`}
              onClick={() => onNavigate('home')}
            >
              <Home style={{ width: 16, height: 16 }} />
              <span>Home</span>
            </button>

            <button
              className={`app-tab-btn ${activeRoute === 'pets' || activeRoute === 'pet-profile' ? 'active' : ''}`}
              onClick={() => onNavigate('pets')}
            >
              <PawPrint style={{ width: 16, height: 16 }} />
              <span>My Pets</span>
              <span className="badge badge-subtle" style={{ fontSize: '0.6875rem', padding: '1px 6px' }}>
                {pets.length}
              </span>
            </button>

            <button
              className={`app-tab-btn ${activeRoute === 'care' ? 'active' : ''}`}
              onClick={() => onNavigate('care')}
            >
              <Clock style={{ width: 16, height: 16 }} />
              <span>Care</span>
            </button>

            <button
              className={`app-tab-btn ${activeRoute === 'health' ? 'active' : ''}`}
              onClick={() => onNavigate('health')}
            >
              <HeartPulse style={{ width: 16, height: 16 }} />
              <span>Health</span>
            </button>

            <button
              className={`app-tab-btn ${activeRoute === 'appointments' ? 'active' : ''}`}
              onClick={() => onNavigate('appointments')}
            >
              <Calendar style={{ width: 16, height: 16 }} />
              <span>Appointments</span>
            </button>

            <button
              className={`app-tab-btn ${activeRoute === 'discover' ? 'active' : ''}`}
              onClick={() => onNavigate('discover')}
            >
              <Compass style={{ width: 16, height: 16 }} />
              <span>Adopt</span>
            </button>
          </nav>
        </div>

        {/* Right Area: Search, Active Pet Pill, Notifs, Profile */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
          {/* Active Pet Selector Pill */}
          {activePet && (
            <div style={{ position: 'relative' }}>
              <button
                className="btn btn-secondary btn-sm"
                onClick={() => setPetSelectorOpen(!petSelectorOpen)}
                style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '4px 10px 4px 6px' }}
                title="Switch active pet"
              >
                <img
                  src={activePet.imageUrl || 'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=100&q=80'}
                  alt={activePet.name}
                  style={{ width: 24, height: 24, borderRadius: '50%', objectFit: 'cover' }}
                />
                <span style={{ fontWeight: 700, fontSize: '0.8125rem' }}>{activePet.name}</span>
                <ChevronDown style={{ width: 12, height: 12, color: 'var(--text-muted)' }} />
              </button>

              {petSelectorOpen && (
                <div
                  style={{
                    position: 'absolute',
                    top: 38,
                    left: 0,
                    width: 200,
                    backgroundColor: 'var(--bg-surface)',
                    border: '1px solid var(--border-color)',
                    borderRadius: 'var(--radius-md)',
                    boxShadow: 'var(--shadow-lg)',
                    zIndex: 150,
                    padding: 6
                  }}
                >
                  <div style={{ fontSize: '0.6875rem', fontWeight: 700, color: 'var(--text-muted)', textTransform: 'uppercase', padding: '6px 8px' }}>
                    Your Pets
                  </div>
                  {pets.map(p => (
                    <button
                      key={p.id}
                      onClick={() => {
                        onSelectActivePet(p.id);
                        setPetSelectorOpen(false);
                      }}
                      style={{
                        width: '100%',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'space-between',
                        padding: '8px 10px',
                        borderRadius: 'var(--radius-sm)',
                        backgroundColor: p.id === activePetId ? 'var(--primary-light)' : 'transparent',
                        color: p.id === activePetId ? 'var(--primary)' : 'var(--text-primary)',
                        fontSize: '0.8125rem',
                        fontWeight: 600,
                        textAlign: 'left'
                      }}
                    >
                      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                        <img
                          src={p.imageUrl || 'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=100&q=80'}
                          alt={p.name}
                          style={{ width: 22, height: 22, borderRadius: '50%', objectFit: 'cover' }}
                        />
                        <span>{p.name}</span>
                      </div>
                      {p.id === activePetId && <Check style={{ width: 14, height: 14 }} />}
                    </button>
                  ))}
                  <div style={{ borderTop: '1px solid var(--border-subtle)', marginTop: 4, paddingTop: 4 }}>
                    <button
                      onClick={() => {
                        setPetSelectorOpen(false);
                        onOpenAddPet();
                      }}
                      style={{
                        width: '100%',
                        display: 'flex',
                        alignItems: 'center',
                        gap: 8,
                        padding: '8px 10px',
                        color: 'var(--primary)',
                        fontSize: '0.8125rem',
                        fontWeight: 600
                      }}
                    >
                      <Plus style={{ width: 14, height: 14 }} />
                      <span>Add another pet</span>
                    </button>
                  </div>
                </div>
              )}
            </div>
          )}

          {/* Quick Search */}
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              backgroundColor: 'var(--bg-subtle)',
              border: '1px solid var(--border-color)',
              borderRadius: 'var(--radius-full)',
              padding: '6px 12px',
              width: 180
            }}
            className="navbar-search"
          >
            <Search style={{ width: 14, height: 14, color: 'var(--text-muted)', marginRight: 6 }} />
            <input
              type="text"
              placeholder="Search..."
              value={searchQuery}
              onChange={e => onSearchChange(e.target.value)}
              style={{
                border: 'none',
                background: 'transparent',
                outline: 'none',
                width: '100%',
                fontSize: '0.8125rem',
                color: 'var(--text-primary)'
              }}
            />
          </div>

          {/* Notifications Button */}
          <div style={{ position: 'relative' }}>
            <button
              className="btn btn-secondary btn-sm"
              onClick={() => {
                setNotifOpen(!notifOpen);
                setProfileOpen(false);
              }}
              style={{ width: 36, height: 36, padding: 0, position: 'relative' }}
              aria-label="Notifications"
            >
              <Bell style={{ width: 16, height: 16, color: 'var(--text-secondary)' }} />
              {unreadCount > 0 && (
                <span
                  style={{
                    position: 'absolute',
                    top: -2,
                    right: -2,
                    backgroundColor: 'var(--accent-clay)',
                    color: '#ffffff',
                    fontSize: '0.625rem',
                    fontWeight: 700,
                    width: 16,
                    height: 16,
                    borderRadius: '50%',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center'
                  }}
                >
                  {unreadCount}
                </span>
              )}
            </button>

            {/* Notifications Dropdown */}
            {notifOpen && (
              <div
                style={{
                  position: 'absolute',
                  top: 44,
                  right: 0,
                  width: 320,
                  backgroundColor: 'var(--bg-surface)',
                  border: '1px solid var(--border-color)',
                  borderRadius: 'var(--radius-lg)',
                  boxShadow: 'var(--shadow-lg)',
                  zIndex: 200,
                  padding: 16
                }}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
                  <div style={{ fontWeight: 700, fontSize: '0.875rem' }}>
                    Notifications {unreadCount > 0 ? `(${unreadCount})` : ''}
                  </div>
                  {unreadCount > 0 && (
                    <button
                      onClick={onMarkNotificationsRead}
                      style={{ fontSize: '0.75rem', color: 'var(--primary)', fontWeight: 600 }}
                    >
                      Mark all read
                    </button>
                  )}
                </div>

                <div style={{ display: 'flex', flexDirection: 'column', gap: 8, maxHeight: 280, overflowY: 'auto' }}>
                  {notifications.map(n => (
                    <div
                      key={n.id}
                      style={{
                        padding: '10px',
                        borderRadius: 'var(--radius-sm)',
                        backgroundColor: n.read ? 'var(--bg-subtle)' : 'var(--primary-light)',
                        border: '1px solid var(--border-subtle)',
                        fontSize: '0.8125rem'
                      }}
                    >
                      <div style={{ fontWeight: 700, color: 'var(--text-primary)', marginBottom: 2 }}>
                        {n.title}
                      </div>
                      <div style={{ color: 'var(--text-secondary)', fontSize: '0.75rem' }}>
                        {n.description}
                      </div>
                      <div style={{ fontSize: '0.6875rem', color: 'var(--text-muted)', marginTop: 4 }}>
                        {n.timestamp}
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>

          {/* User Profile Avatar */}
          <div style={{ position: 'relative' }}>
            <button
              onClick={() => {
                setProfileOpen(!profileOpen);
                setNotifOpen(false);
              }}
              style={{
                width: 36,
                height: 36,
                borderRadius: '50%',
                overflow: 'hidden',
                border: '2px solid var(--primary-border)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                backgroundColor: 'var(--bg-subtle)'
              }}
              aria-label="User menu"
            >
              {currentUser.avatarUrl ? (
                <img src={currentUser.avatarUrl} alt={currentUser.name} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
              ) : (
                <UserIcon style={{ width: 18, height: 18, color: 'var(--primary)' }} />
              )}
            </button>

            {profileOpen && (
              <div
                style={{
                  position: 'absolute',
                  top: 44,
                  right: 0,
                  width: 220,
                  backgroundColor: 'var(--bg-surface)',
                  border: '1px solid var(--border-color)',
                  borderRadius: 'var(--radius-md)',
                  boxShadow: 'var(--shadow-lg)',
                  zIndex: 200,
                  padding: 8
                }}
              >
                <div style={{ padding: '8px 10px', borderBottom: '1px solid var(--border-subtle)', marginBottom: 4 }}>
                  <div style={{ fontWeight: 700, fontSize: '0.875rem' }}>{currentUser.name}</div>
                  <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>{currentUser.email}</div>
                </div>

                <button
                  onClick={() => {
                    setProfileOpen(false);
                    onNavigate('pets');
                  }}
                  style={{
                    width: '100%',
                    display: 'flex',
                    alignItems: 'center',
                    gap: 8,
                    padding: '8px 10px',
                    fontSize: '0.8125rem',
                    color: 'var(--text-primary)',
                    borderRadius: 'var(--radius-xs)'
                  }}
                >
                  <PawPrint style={{ width: 14, height: 14 }} />
                  <span>Manage Pets</span>
                </button>

                <button
                  onClick={() => {
                    setProfileOpen(false);
                    onLogout();
                  }}
                  style={{
                    width: '100%',
                    display: 'flex',
                    alignItems: 'center',
                    gap: 8,
                    padding: '8px 10px',
                    fontSize: '0.8125rem',
                    color: 'var(--accent-rose)',
                    borderRadius: 'var(--radius-xs)',
                    borderTop: '1px solid var(--border-subtle)',
                    marginTop: 4
                  }}
                >
                  <LogOut style={{ width: 14, height: 14 }} />
                  <span>Log out</span>
                </button>
              </div>
            )}
          </div>
        </div>
      </div>
    </header>
  );
};
