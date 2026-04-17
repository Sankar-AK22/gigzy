import React, { useState } from 'react';
import { useToast } from '../components/Toast';

export default function Settings() {
  const { addToast } = useToast();
  const [loading, setLoading] = useState(false);

  const handleSave = () => {
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      addToast('Settings Saved', 'Your preferences have been updated successfully.', 'success');
    }, 800);
  };

  return (
    <div>
      <div className="page-header">
        <div className="page-header-text">
          <h2>⚙️ System Settings</h2>
          <p>Manage application preferences, integrations, and security.</p>
        </div>
        <button className="btn btn-primary" onClick={handleSave} disabled={loading}>
          {loading ? 'Saving...' : 'Save Changes'}
        </button>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '250px 1fr', gap: '32px' }}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
          <div className="nav-item active">👤 Profile</div>
          <div className="nav-item">🔔 Notifications</div>
          <div className="nav-item">🔒 Security</div>
          <div className="nav-item">🔌 Integrations</div>
          <div className="nav-item">💾 Backup & Restore</div>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: '24px' }}>
          
          <div className="table-container" style={{ padding: '24px' }}>
            <h3 style={{ fontSize: '18px', marginBottom: '24px', paddingBottom: '16px', borderBottom: '1px solid var(--border)' }}>Admin Profile</h3>
            <div style={{ display: 'flex', gap: '24px', alignItems: 'flex-start' }}>
              <div style={{ width: '100px', height: '100px', borderRadius: '50%', background: 'linear-gradient(135deg, #ff6b6b, #ffb84d)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '32px', color: 'white', fontWeight: 'bold' }}>
                AD
              </div>
              <div style={{ flex: 1, display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '20px' }}>
                <div className="form-group">
                  <label>Full Name</label>
                  <input type="text" className="form-control" defaultValue="Admin User" />
                </div>
                <div className="form-group">
                  <label>Email Address</label>
                  <input type="email" className="form-control" defaultValue="admin@gigshield.com" />
                </div>
                <div className="form-group">
                  <label>Role</label>
                  <input type="text" className="form-control" defaultValue="System Administrator" disabled style={{ opacity: 0.7 }} />
                </div>
                <div className="form-group">
                  <label>Timezone</label>
                  <select className="form-control">
                    <option>Asia/Kolkata (IST)</option>
                    <option>UTC</option>
                  </select>
                </div>
              </div>
            </div>
          </div>

          <div className="table-container" style={{ padding: '24px' }}>
            <h3 style={{ fontSize: '18px', marginBottom: '24px', paddingBottom: '16px', borderBottom: '1px solid var(--border)' }}>Integrations Health</h3>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '16px', background: 'var(--bg-surface)', borderRadius: '8px', border: '1px solid var(--border)' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                  <div style={{ width: '40px', height: '40px', background: 'rgba(255,184,77,0.15)', borderRadius: '8px', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '20px' }}>🔥</div>
                  <div>
                    <div style={{ fontWeight: 600 }}>Firebase Services</div>
                    <div style={{ fontSize: '12px', color: 'var(--text-muted)' }}>Auth & Firestore real-time sync</div>
                  </div>
                </div>
                <span className="badge badge-active">Connected</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '16px', background: 'var(--bg-surface)', borderRadius: '8px', border: '1px solid var(--border)' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                  <div style={{ width: '40px', height: '40px', background: 'rgba(78,205,196,0.15)', borderRadius: '8px', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '20px' }}>🧠</div>
                  <div>
                    <div style={{ fontWeight: 600 }}>Groq AI Service</div>
                    <div style={{ fontSize: '12px', color: 'var(--text-muted)' }}>LLaMA 3.3 model integration</div>
                  </div>
                </div>
                <span className="badge badge-active">Connected</span>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>
  );
}
