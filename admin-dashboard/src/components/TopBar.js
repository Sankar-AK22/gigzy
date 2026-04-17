import React, { useState, useEffect } from 'react';

export default function TopBar({ onMenuClick }) {
  const [theme, setTheme] = useState('dark');

  useEffect(() => {
    document.documentElement.setAttribute('data-theme', theme);
  }, [theme]);

  const toggleTheme = () => {
    setTheme(prev => prev === 'dark' ? 'light' : 'dark');
  };

  return (
    <header className="topbar">
      <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
        <button className="action-btn" onClick={onMenuClick} style={{ border: 'none', background: 'transparent' }}>
          ☰
        </button>
        <div className="search-bar">
          <span>🔍</span>
          <input type="text" placeholder="Search workers, claims, policies..." />
          <span className="search-shortcut">Ctrl+K</span>
        </div>
      </div>

      <div className="topbar-actions">
        <button className="action-btn" onClick={toggleTheme} title="Toggle Theme">
          {theme === 'dark' ? '☀️' : '🌙'}
        </button>
        <div className="action-btn">
          🔔
          <span className="indicator"></span>
        </div>
        
        <div className="admin-profile">
          <div className="admin-avatar">AD</div>
          <div className="admin-info">
            <span className="admin-name">Admin User</span>
            <span className="admin-role">System Administrator</span>
          </div>
          <span style={{ fontSize: '10px', color: 'var(--text-muted)' }}>▼</span>
        </div>
      </div>
    </header>
  );
}
