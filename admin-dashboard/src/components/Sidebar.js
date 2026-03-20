import React from 'react';

const navItems = [
  { id: 'dashboard', label: 'Dashboard', icon: '📊' },
  { id: 'workers', label: 'Workers', icon: '👷' },
  { id: 'claims', label: 'Claims', icon: '📋' },
  { id: 'fraud', label: 'Fraud Alerts', icon: '🚨' },
];

export default function Sidebar({ activePage, setActivePage }) {
  return (
    <aside className="sidebar">
      <div className="sidebar-logo">
        <div className="logo-icon">🛡️</div>
        <h1>GigShield</h1>
      </div>
      <nav>
        {navItems.map(item => (
          <div
            key={item.id}
            className={`nav-item ${activePage === item.id ? 'active' : ''}`}
            onClick={() => setActivePage(item.id)}
          >
            <span>{item.icon}</span>
            <span>{item.label}</span>
          </div>
        ))}
      </nav>
      <div style={{ marginTop: 'auto', paddingTop: 32, borderTop: '1px solid var(--border)', marginTop: 'auto' }}>
        <div className="nav-item">
          <span>⚙️</span>
          <span>Settings</span>
        </div>
      </div>
    </aside>
  );
}
