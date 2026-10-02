import React from 'react';

interface PawlyLogoProps {
  size?: 'sm' | 'md' | 'lg';
  variant?: 'light' | 'dark' | 'brand';
  showTagline?: boolean;
}

export const PawlyLogo: React.FC<PawlyLogoProps> = ({
  size = 'md',
  variant = 'brand',
  showTagline = false
}) => {
  const iconSize = size === 'sm' ? 24 : size === 'lg' ? 36 : 28;
  const textSize = size === 'sm' ? '1.125rem' : size === 'lg' ? '1.625rem' : '1.3125rem';

  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: size === 'sm' ? 8 : 10, cursor: 'pointer' }}>
      <div
        style={{
          width: iconSize + 10,
          height: iconSize + 10,
          borderRadius: 12,
          backgroundColor: variant === 'light' ? '#ffffff' : 'var(--primary)',
          color: variant === 'light' ? 'var(--primary)' : '#ffffff',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          boxShadow: '0 2px 6px rgba(61, 103, 82, 0.18)',
          flexShrink: 0
        }}
      >
        <svg
          width={iconSize}
          height={iconSize}
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2.2"
          strokeLinecap="round"
          strokeLinejoin="round"
        >
          {/* Main paw pad */}
          <ellipse cx="12" cy="14" rx="4.5" ry="3.8" />
          {/* Four toe pads */}
          <circle cx="7" cy="8.5" r="2.2" />
          <circle cx="10.5" cy="5.8" r="2.2" />
          <circle cx="13.5" cy="5.8" r="2.2" />
          <circle cx="17" cy="8.5" r="2.2" />
        </svg>
      </div>

      <div>
        <div
          style={{
            fontSize: textSize,
            fontWeight: 800,
            letterSpacing: '-0.03em',
            color: variant === 'light' ? '#ffffff' : 'var(--text-primary)',
            lineHeight: 1
          }}
        >
          Pawly
        </div>
        {showTagline && (
          <div
            style={{
              fontSize: '0.6875rem',
              color: variant === 'light' ? 'rgba(255,255,255,0.8)' : 'var(--text-muted)',
              marginTop: 2,
              fontWeight: 500
            }}
          >
            Everything your pet needs
          </div>
        )}
      </div>
    </div>
  );
};
