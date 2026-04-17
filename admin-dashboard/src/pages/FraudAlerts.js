import React, { useState } from 'react';
import { useToast } from '../components/Toast';

const alerts = [
  { id: 'FRD-001', worker: 'Anjali Rao', type: 'GPS Distance Mismatch', score: 0.85, reason: 'Worker is 45km from disruption zone (max: 25km)', claim: '₹260', time: '2h ago', severity: 'critical', status: 'open' },
  { id: 'FRD-002', worker: 'Unknown User', type: 'GPS Spoofing', score: 0.92, reason: 'Coordinates (0,0) — default/null island detected', claim: '₹500', time: '5h ago', severity: 'critical', status: 'open' },
  { id: 'FRD-003', worker: 'Demo Worker', type: 'High Claim Frequency', score: 0.55, reason: '5 claims in 7 days (threshold: 3/week)', claim: '₹320', time: '1d ago', severity: 'high', status: 'investigating' },
];

export default function FraudAlerts() {
  const { addToast } = useToast();
  const [activeAlerts, setActiveAlerts] = useState(alerts);

  const resolveAlert = (id, action) => {
    setActiveAlerts(prev => prev.filter(a => a.id !== id));
    addToast('Alert Resolved', `Alert ${id} has been ${action}.`, 'success');
  };

  return (
    <div>
      <div className="page-header">
        <div className="page-header-text">
          <h2>🚨 Fraud Detection Alerts</h2>
          <p>AI-powered anomaly detection for suspicious claims</p>
        </div>
      </div>

      <div className="stats-grid" style={{ gridTemplateColumns: 'repeat(3,1fr)' }}>
        <div className="stat-card">
          <div className="stat-value" style={{ color: 'var(--accent-red)' }}>{activeAlerts.length}</div>
          <div className="stat-label">Active Alerts</div>
        </div>
        <div className="stat-card">
          <div className="stat-value" style={{ color: 'var(--accent-orange)' }}>{activeAlerts.filter(a => a.severity === 'critical').length}</div>
          <div className="stat-label">Critical Severity</div>
        </div>
        <div className="stat-card">
          <div className="stat-value" style={{ color: 'var(--accent-teal)' }}>98.2%</div>
          <div className="stat-label">Legitimate Claims</div>
        </div>
      </div>

      {activeAlerts.length === 0 ? (
        <div style={{ textAlign: 'center', padding: '60px', background: 'var(--bg-card)', borderRadius: 'var(--radius)', border: '1px solid var(--border)' }}>
          <div style={{ fontSize: '48px', marginBottom: '16px' }}>🎉</div>
          <h3>No Active Alerts</h3>
          <p style={{ color: 'var(--text-secondary)' }}>Your system is clean. AI has not detected any anomalous claims.</p>
        </div>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
          {activeAlerts.map((a, i) => (
            <div key={i} style={{
              background: 'var(--bg-card)', borderRadius: 'var(--radius)', padding: 24,
              border: `1px solid ${a.severity === 'critical' ? 'rgba(255,107,107,0.3)' : 'rgba(255,184,77,0.3)'}`,
              boxShadow: '0 4px 20px rgba(0,0,0,0.1)'
            }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 16 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
                  <div style={{ width: '48px', height: '48px', borderRadius: '12px', background: 'rgba(255,107,107,0.1)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 24 }}>🚩</div>
                  <div>
                    <div style={{ fontWeight: 600, fontSize: 18, marginBottom: 4 }}>{a.type}</div>
                    <div style={{ color: 'var(--text-muted)', fontSize: 13, display: 'flex', gap: '8px', alignItems: 'center' }}>
                      <span style={{ color: 'var(--text-primary)' }}>{a.id}</span> • {a.worker} • {a.time}
                    </div>
                  </div>
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-end', gap: '8px' }}>
                  <span className={`badge badge-${a.severity}`}>{a.severity.toUpperCase()}</span>
                  <span className="badge badge-pending" style={{ background: 'transparent', border: '1px solid var(--border)', color: 'var(--text-secondary)' }}>{a.status}</span>
                </div>
              </div>
              
              <div style={{ display: 'grid', gridTemplateColumns: '3fr 1fr', gap: '24px', alignItems: 'center' }}>
                <div style={{ background: 'rgba(255,107,107,0.05)', borderLeft: '4px solid var(--accent-red)', borderRadius: '0 8px 8px 0', padding: 16 }}>
                  <div style={{ color: 'var(--text-secondary)', fontSize: 13, marginBottom: 4, fontWeight: 500 }}>AI Detection Reason</div>
                  <div style={{ fontSize: 14, lineHeight: 1.5 }}>{a.reason}</div>
                </div>
                
                <div style={{ display: 'flex', gap: 24, justifyContent: 'flex-end' }}>
                  <div style={{ textAlign: 'right' }}><div style={{ color: 'var(--text-muted)', fontSize: 12, marginBottom: 4 }}>Fraud Score</div><div style={{ color: '#ff6b6b', fontWeight: 700, fontSize: 24 }}>{(a.score * 100).toFixed(0)}%</div></div>
                  <div style={{ textAlign: 'right' }}><div style={{ color: 'var(--text-muted)', fontSize: 12, marginBottom: 4 }}>Claim Amount</div><div style={{ fontWeight: 600, fontSize: 24 }}>{a.claim}</div></div>
                </div>
              </div>

              <div style={{ marginTop: '24px', paddingTop: '16px', borderTop: '1px solid var(--border)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <button className="btn btn-secondary" style={{ padding: '6px 12px', fontSize: '13px' }} onClick={() => addToast('Notes', 'Added note to investigation.', 'info')}>📝 Add Investigation Note</button>
                <div style={{ display: 'flex', gap: 12 }}>
                  <button className="btn btn-danger" onClick={() => resolveAlert(a.id, 'rejected')}>Reject Claim</button>
                  <button className="btn btn-success" onClick={() => resolveAlert(a.id, 'approved')}>Override & Approve</button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
