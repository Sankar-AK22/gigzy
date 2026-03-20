import React from 'react';

const alerts = [
  { id: 'FRD-001', worker: 'Anjali Rao', type: 'GPS Distance Mismatch', score: 0.85, reason: 'Worker is 45km from disruption zone (max: 25km)', claim: '₹260', time: '2h ago', severity: 'critical' },
  { id: 'FRD-002', worker: 'Unknown User', type: 'GPS Spoofing', score: 0.92, reason: 'Coordinates (0,0) — default/null island detected', claim: '₹500', time: '5h ago', severity: 'critical' },
  { id: 'FRD-003', worker: 'Demo Worker', type: 'High Claim Frequency', score: 0.55, reason: '5 claims in 7 days (threshold: 3/week)', claim: '₹320', time: '1d ago', severity: 'high' },
];

export default function FraudAlerts() {
  return (
    <div>
      <div className="page-header">
        <h2>🚨 Fraud Detection Alerts</h2>
        <p>AI-powered anomaly detection for suspicious claims</p>
      </div>
      <div className="stats-grid" style={{ gridTemplateColumns: 'repeat(3,1fr)' }}>
        <div className="stat-card">
          <div className="stat-value" style={{ color: 'var(--accent-red)' }}>3</div>
          <div className="stat-label">Active Alerts</div>
        </div>
        <div className="stat-card">
          <div className="stat-value" style={{ color: 'var(--accent-orange)' }}>2</div>
          <div className="stat-label">Critical Severity</div>
        </div>
        <div className="stat-card">
          <div className="stat-value" style={{ color: 'var(--accent-teal)' }}>98.2%</div>
          <div className="stat-label">Legitimate Claims</div>
        </div>
      </div>

      {alerts.map((a, i) => (
        <div key={i} style={{
          background: 'var(--bg-card)', borderRadius: 'var(--radius)', padding: 24, marginBottom: 16,
          border: `1px solid ${a.severity === 'critical' ? 'rgba(255,107,107,0.3)' : 'rgba(255,184,77,0.3)'}`,
        }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
              <span style={{ fontSize: 24 }}>🚩</span>
              <div>
                <div style={{ fontWeight: 600, fontSize: 16 }}>{a.type}</div>
                <div style={{ color: 'var(--text-muted)', fontSize: 13 }}>{a.id} · {a.worker} · {a.time}</div>
              </div>
            </div>
            <span className={`badge badge-${a.severity}`}>{a.severity.toUpperCase()}</span>
          </div>
          <div style={{ background: 'rgba(255,107,107,0.08)', borderRadius: 10, padding: 16, marginBottom: 16 }}>
            <div style={{ color: 'var(--text-secondary)', fontSize: 13, marginBottom: 4 }}>Detection Reason</div>
            <div style={{ fontSize: 14 }}>{a.reason}</div>
          </div>
          <div style={{ display: 'flex', gap: 24 }}>
            <div><span style={{ color: 'var(--text-muted)', fontSize: 12 }}>Fraud Score</span><div style={{ color: '#ff6b6b', fontWeight: 700, fontSize: 18 }}>{(a.score * 100).toFixed(0)}%</div></div>
            <div><span style={{ color: 'var(--text-muted)', fontSize: 12 }}>Claim Amount</span><div style={{ fontWeight: 600, fontSize: 18 }}>{a.claim}</div></div>
            <div style={{ marginLeft: 'auto', display: 'flex', gap: 8 }}>
              <button style={{ padding: '8px 20px', borderRadius: 8, border: 'none', background: 'rgba(255,107,107,0.15)', color: '#ff6b6b', cursor: 'pointer', fontWeight: 600, fontSize: 13 }}>Reject</button>
              <button style={{ padding: '8px 20px', borderRadius: 8, border: 'none', background: 'rgba(0,212,170,0.15)', color: '#00d4aa', cursor: 'pointer', fontWeight: 600, fontSize: 13 }}>Approve</button>
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}
