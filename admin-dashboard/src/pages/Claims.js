import React from 'react';

const claims = [
  { id: 'CLM-001', worker: 'Rahul Kumar', type: '🌧️ Rainfall', city: 'Mumbai', hours: 5, rate: 80, payout: 400, status: 'paid' },
  { id: 'CLM-002', worker: 'Priya Sharma', type: '🌡️ Heatwave', city: 'Delhi', hours: 4, rate: 93, payout: 375, status: 'approved' },
  { id: 'CLM-003', worker: 'Deepak Verma', type: '🌊 Flood', city: 'Mumbai', hours: 8, rate: 82, payout: 656, status: 'paid' },
  { id: 'CLM-004', worker: 'Anjali Rao', type: '😷 Pollution', city: 'Hyderabad', hours: 3, rate: 87, payout: 260, status: 'fraud_flagged' },
  { id: 'CLM-005', worker: 'Amit Patel', type: '🌧️ Rainfall', city: 'Bangalore', hours: 3, rate: 100, payout: 300, status: 'pending' },
  { id: 'CLM-006', worker: 'Sunita Devi', type: '🌡️ Heatwave', city: 'Chennai', hours: 6, rate: 87, payout: 525, status: 'approved' },
];

const statusClass = (s) => s === 'paid' ? 'badge-paid' : s === 'fraud_flagged' ? 'badge-fraud' : s === 'approved' ? 'badge-active' : 'badge-pending';
const statusText = (s) => s === 'fraud_flagged' ? '🚩 Fraud Flagged' : s.charAt(0).toUpperCase() + s.slice(1);

export default function Claims() {
  return (
    <div>
      <div className="page-header">
        <h2>Claims Management</h2>
        <p>Auto-triggered parametric insurance claims</p>
      </div>
      <div className="stats-grid" style={{ gridTemplateColumns: 'repeat(4,1fr)' }}>
        <div className="stat-card"><div className="stat-value">6</div><div className="stat-label">Total Claims</div></div>
        <div className="stat-card"><div className="stat-value" style={{ color: 'var(--accent-teal)' }}>₹2,516</div><div className="stat-label">Total Payouts</div></div>
        <div className="stat-card"><div className="stat-value" style={{ color: 'var(--accent-orange)' }}>1</div><div className="stat-label">Pending</div></div>
        <div className="stat-card"><div className="stat-value" style={{ color: 'var(--accent-red)' }}>1</div><div className="stat-label">Fraud Flagged</div></div>
      </div>
      <div className="data-table">
        <table>
          <thead>
            <tr><th>Claim ID</th><th>Worker</th><th>Disruption</th><th>City</th><th>Lost Hours</th><th>Payout</th><th>Status</th></tr>
          </thead>
          <tbody>
            {claims.map((c, i) => (
              <tr key={i}>
                <td style={{ fontWeight: 600, color: 'var(--accent-purple)' }}>{c.id}</td>
                <td>{c.worker}</td>
                <td>{c.type}</td>
                <td>{c.city}</td>
                <td>{c.hours}h × ₹{c.rate}/hr</td>
                <td style={{ fontWeight: 600 }}>₹{c.payout}</td>
                <td><span className={`badge ${statusClass(c.status)}`}>{statusText(c.status)}</span></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
