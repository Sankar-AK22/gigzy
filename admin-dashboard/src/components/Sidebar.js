import React from 'react';

export default function Sidebar({ activePage, setActivePage, isCollapsed }) {
  const navItems = [
    { id: 'dashboard', label: 'Dashboard', icon: '📊' },
    { id: 'workers', label: 'Workers', icon: '👷' },
    { id: 'policies', label: 'Policies', icon: '📑' },
    { id: 'claims', label: 'Claims', icon: '📋' },
    { id: 'fraud', label: 'Fraud Alerts', icon: '🚨', badge: 3 },
  ];

  return (
    <aside className={`sidebar ${isCollapsed ? 'collapsed' : ''}`}>
      <div className="sidebar-logo">
        <div className="logo-icon">🛡️</div>
        <h1>GigShield</h1>
      </div>
      <nav style={{ flex: 1 }}>
        {navItems.map(item => (
          <div
            key={item.id}
            className={`nav-item ${activePage === item.id ? 'active' : ''}`}
            onClick={() => setActivePage(item.id)}
            title={isCollapsed ? item.label : ''}
          >
            <span>{item.icon}</span>
            <span>{item.label}</span>
            {!isCollapsed && item.badge && (
              <span className="badge-count">{item.badge}</span>
            )}
          </div>
        ))}
      </nav>
      <div style={{ paddingTop: 32, borderTop: '1px solid var(--border)', marginTop: 'auto' }}>
        <div 
          className={`nav-item ${activePage === 'settings' ? 'active' : ''}`}
          onClick={() => setActivePage('settings')}
          title={isCollapsed ? 'Settings' : ''}
        >
          <span>⚙️</span>
          <span>Settings</span>
        </div>
      </div>
    </aside>
  );
}
