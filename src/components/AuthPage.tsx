import React, { useState } from 'react';
import { ArrowRight, UserCheck, ShieldCheck, Sparkles } from 'lucide-react';
import { PawlyLogo } from './brand/PawlyLogo';
import { User } from '../types';

interface AuthPageProps {
  initialMode: 'login' | 'signup';
  onSuccess: (user: User, isNewUser: boolean) => void;
  onCancel: () => void;
}

export const AuthPage: React.FC<AuthPageProps> = ({ initialMode, onSuccess, onCancel }) => {
  const [mode, setMode] = useState<'login' | 'signup'>(initialMode);
  const [name, setName] = useState(initialMode === 'signup' ? '' : 'Lady');
  const [email, setEmail] = useState(initialMode === 'signup' ? '' : 'lady@pawly.app');
  const [password, setPassword] = useState('pawly123');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const user: User = {
      id: `user_${Date.now()}`,
      name: name.trim() || 'Pet Parent',
      email: email.trim() || 'user@pawly.app',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80'
    };
    onSuccess(user, mode === 'signup');
  };

  const handleQuickDemo = () => {
    const demoUser: User = {
      id: 'demo_lady',
      name: 'Lady',
      email: 'lady@pawly.app',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80'
    };
    onSuccess(demoUser, false);
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
      <div style={{ marginBottom: 28 }} onClick={onCancel}>
        <PawlyLogo size="lg" showTagline />
      </div>

      <div
        className="pawly-card"
        style={{
          maxWidth: 440,
          width: '100%',
          padding: '36px 32px',
          boxShadow: 'var(--shadow-md)'
        }}
      >
        <div style={{ marginBottom: 24, textAlign: 'center' }}>
          <h2 style={{ fontSize: '1.5rem', fontWeight: 800, color: 'var(--text-primary)', letterSpacing: '-0.02em' }}>
            {mode === 'login' ? 'Welcome back to Pawly' : 'Create your Pawly account'}
          </h2>
          <p style={{ fontSize: '0.875rem', color: 'var(--text-secondary)', marginTop: 6 }}>
            {mode === 'login'
              ? 'Sign in to access your pets’ health and care routines.'
              : 'Sign up to keep all your pets’ essentials organized in one place.'}
          </p>
        </div>

        {/* Quick Demo Access Bar */}
        <div
          style={{
            backgroundColor: 'var(--primary-light)',
            border: '1px solid var(--primary-border)',
            borderRadius: 'var(--radius-md)',
            padding: '12px 14px',
            marginBottom: 20,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between'
          }}
        >
          <div>
            <div style={{ fontSize: '0.8125rem', fontWeight: 700, color: 'var(--primary)' }}>
              Quick Portfolio Review
            </div>
            <div style={{ fontSize: '0.75rem', color: 'var(--text-secondary)' }}>
              Sign in as Lady with preloaded pets & routines
            </div>
          </div>
          <button
            type="button"
            className="btn btn-primary btn-sm"
            onClick={handleQuickDemo}
          >
            Demo Login
          </button>
        </div>

        <form onSubmit={handleSubmit}>
          {mode === 'signup' && (
            <div className="form-group">
              <label className="form-label">Your Name</label>
              <input
                type="text"
                required
                className="form-control"
                placeholder="e.g. Lady Liberty"
                value={name}
                onChange={e => setName(e.target.value)}
              />
            </div>
          )}

          <div className="form-group">
            <label className="form-label">Email Address</label>
            <input
              type="email"
              required
              className="form-control"
              placeholder="you@example.com"
              value={email}
              onChange={e => setEmail(e.target.value)}
            />
          </div>

          <div className="form-group">
            <label className="form-label">Password</label>
            <input
              type="password"
              required
              className="form-control"
              placeholder="••••••••"
              value={password}
              onChange={e => setPassword(e.target.value)}
            />
          </div>

          <button
            type="submit"
            className="btn btn-primary btn-lg"
            style={{ width: '100%', marginTop: 8 }}
          >
            <span>{mode === 'login' ? 'Sign in to Pawly' : 'Continue to pet setup'}</span>
            <ArrowRight style={{ width: 16, height: 16 }} />
          </button>
        </form>

        <div style={{ textAlign: 'center', marginTop: 24, fontSize: '0.8125rem', color: 'var(--text-muted)' }}>
          {mode === 'login' ? (
            <>
              Don't have an account yet?{' '}
              <button
                type="button"
                onClick={() => setMode('signup')}
                style={{ color: 'var(--primary)', fontWeight: 700 }}
              >
                Create free account
              </button>
            </>
          ) : (
            <>
              Already have an account?{' '}
              <button
                type="button"
                onClick={() => setMode('login')}
                style={{ color: 'var(--primary)', fontWeight: 700 }}
              >
                Sign in
              </button>
            </>
          )}
        </div>

        <div style={{ textAlign: 'center', marginTop: 16 }}>
          <button
            type="button"
            onClick={onCancel}
            style={{ fontSize: '0.8125rem', color: 'var(--text-muted)' }}
          >
            ← Back to Pawly Homepage
          </button>
        </div>
      </div>
    </div>
  );
};
