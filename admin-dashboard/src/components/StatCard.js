import React from 'react';

export default function StatCard({ icon, iconBg, value, label, change, changeType }) {
  return (
    <div className="stat-card">
      <div className="stat-icon" style={{ background: iconBg }}>
        {icon}
      </div>
      <div className="stat-value">{value}</div>
      <div className="stat-label">{label}</div>
      {change && (
        <div className="stat-change" style={{ color: changeType === 'up' ? 'var(--accent-teal)' : 'var(--accent-red)' }}>
          {changeType === 'up' ? '↑' : '↓'} {change}
        </div>
      )}
    </div>
  );
}
