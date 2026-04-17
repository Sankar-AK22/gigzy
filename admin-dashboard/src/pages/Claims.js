import React, { useState } from 'react';
import SearchFilter from '../components/SearchFilter';
import Pagination from '../components/Pagination';
import Modal from '../components/Modal';
import { useToast } from '../components/Toast';

const sampleClaims = [
  { id: 'CLM-001', worker: 'Rahul Kumar', type: '🌧️ Rainfall', city: 'Mumbai', hours: 5, rate: 80, payout: 400, status: 'paid', date: '2026-04-10' },
  { id: 'CLM-002', worker: 'Priya Sharma', type: '🌡️ Heatwave', city: 'Delhi', hours: 4, rate: 93, payout: 375, status: 'approved', date: '2026-04-12' },
  { id: 'CLM-003', worker: 'Deepak Verma', type: '🌊 Flood', city: 'Mumbai', hours: 8, rate: 82, payout: 656, status: 'paid', date: '2026-04-14' },
  { id: 'CLM-004', worker: 'Anjali Rao', type: '😷 Pollution', city: 'Hyderabad', hours: 3, rate: 87, payout: 260, status: 'fraud_flagged', date: '2026-04-15' },
  { id: 'CLM-005', worker: 'Amit Patel', type: '🌧️ Rainfall', city: 'Bangalore', hours: 3, rate: 100, payout: 300, status: 'pending', date: '2026-04-16' },
  { id: 'CLM-006', worker: 'Sunita Devi', type: '🌡️ Heatwave', city: 'Chennai', hours: 6, rate: 87, payout: 525, status: 'approved', date: '2026-04-16' },
];

export default function Claims() {
  const [searchTerm, setSearchTerm] = useState('');
  const [filters, setFilters] = useState({});
  const [page, setPage] = useState(1);
  const [itemsPerPage, setItemsPerPage] = useState(10);
  const [selectedClaim, setSelectedClaim] = useState(null);
  const { addToast } = useToast();

  const handleFilterChange = (key, value) => setFilters(prev => ({ ...prev, [key]: value }));

  const statusClass = (s) => s === 'paid' ? 'badge-paid' : s === 'fraud_flagged' ? 'badge-fraud' : s === 'approved' ? 'badge-active' : 'badge-pending';
  const statusText = (s) => s === 'fraud_flagged' ? '🚩 Fraud Flagged' : s.charAt(0).toUpperCase() + s.slice(1);

  let filtered = sampleClaims;
  if (searchTerm) {
    const lower = searchTerm.toLowerCase();
    filtered = filtered.filter(c => c.worker.toLowerCase().includes(lower) || c.id.toLowerCase().includes(lower));
  }
  if (filters.status) filtered = filtered.filter(c => c.status === filters.status);
  if (filters.type) filtered = filtered.filter(c => c.type.includes(filters.type));

  const paginated = filtered.slice((page - 1) * itemsPerPage, page * itemsPerPage);

  const processClaim = (action) => {
    addToast('Claim Updated', `Claim ${selectedClaim.id} was ${action}.`, action === 'approved' ? 'success' : 'error');
    setSelectedClaim(null);
  };

  return (
    <div>
      <div className="page-header">
        <div className="page-header-text">
          <h2>📋 Claims Management</h2>
          <p>Review and process auto-triggered parametric insurance claims</p>
        </div>
        <div className="page-actions">
          <button className="btn btn-secondary">📥 Export Report</button>
        </div>
      </div>

      <div className="stats-grid" style={{ gridTemplateColumns: 'repeat(4,1fr)' }}>
        <div className="stat-card">
          <div className="stat-value">6</div>
          <div className="stat-label">Total Claims</div>
        </div>
        <div className="stat-card">
          <div className="stat-value" style={{ color: 'var(--accent-teal)' }}>₹2,516</div>
          <div className="stat-label">Total Payouts</div>
        </div>
        <div className="stat-card">
          <div className="stat-value" style={{ color: 'var(--accent-orange)' }}>1</div>
          <div className="stat-label">Pending Approval</div>
        </div>
        <div className="stat-card">
          <div className="stat-value" style={{ color: 'var(--accent-red)' }}>1</div>
          <div className="stat-label">Fraud Flagged</div>
        </div>
      </div>

      <div className="table-container">
        <div className="table-header-tools">
          <SearchFilter 
            searchTerm={searchTerm} 
            onSearchChange={setSearchTerm}
            filters={filters}
            onFilterChange={handleFilterChange}
            filterOptions={[
              { key: 'status', label: 'All Statuses', values: [{value: 'pending', label: 'Pending'}, {value: 'approved', label: 'Approved'}, {value: 'paid', label: 'Paid'}, {value: 'fraud_flagged', label: 'Fraud Flagged'}] },
              { key: 'type', label: 'All Disruptions', values: [{value: 'Rainfall', label: 'Rainfall'}, {value: 'Heatwave', label: 'Heatwave'}, {value: 'Flood', label: 'Flood'}] }
            ]}
          />
        </div>

        <table className="data-table">
          <thead>
            <tr>
              <th>Claim ID</th>
              <th>Date</th>
              <th>Worker</th>
              <th>Disruption</th>
              <th>Calculated Loss</th>
              <th>Payout</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {paginated.map((c) => (
              <tr key={c.id} onClick={() => setSelectedClaim(c)}>
                <td style={{ fontWeight: 600, color: 'var(--accent-purple)' }}>{c.id}</td>
                <td>{c.date}</td>
                <td>
                  <div style={{ fontWeight: 500 }}>{c.worker}</div>
                  <div style={{ fontSize: '12px', color: 'var(--text-muted)' }}>{c.city}</div>
                </td>
                <td>{c.type}</td>
                <td>{c.hours}h × ₹{c.rate}/hr</td>
                <td style={{ fontWeight: 600 }}>₹{c.payout}</td>
                <td><span className={`badge ${statusClass(c.status)}`}>{statusText(c.status)}</span></td>
                <td onClick={e => e.stopPropagation()}>
                  <button className="btn btn-secondary" style={{ padding: '6px 12px', fontSize: '12px' }} onClick={() => setSelectedClaim(c)}>Review</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        <Pagination currentPage={page} totalPages={Math.ceil(filtered.length/itemsPerPage)} onPageChange={setPage} itemsPerPage={itemsPerPage} onItemsPerPageChange={setItemsPerPage} />
      </div>

      <Modal isOpen={!!selectedClaim} onClose={() => setSelectedClaim(null)} title="Claim Review" footer={
        <>
          <button className="btn btn-secondary" onClick={() => setSelectedClaim(null)}>Close</button>
          {selectedClaim?.status === 'pending' || selectedClaim?.status === 'fraud_flagged' ? (
            <>
              <button className="btn btn-danger" onClick={() => processClaim('rejected')}>Reject Claim</button>
              <button className="btn btn-success" onClick={() => processClaim('approved')}>Approve Payout</button>
            </>
          ) : null}
        </>
      }>
        {selectedClaim && (
          <div style={{ display: 'grid', gap: '20px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <h3 style={{ margin: 0, fontSize: '24px' }}>{selectedClaim.id}</h3>
              <span className={`badge ${statusClass(selectedClaim.status)}`} style={{ fontSize: '14px', padding: '8px 16px' }}>{statusText(selectedClaim.status)}</span>
            </div>
            
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', background: 'var(--bg-surface)', padding: '16px', borderRadius: '8px' }}>
              <div><div style={{ color: 'var(--text-muted)', fontSize: '12px', marginBottom: '4px' }}>Worker</div><div style={{ fontWeight: 500 }}>{selectedClaim.worker}</div></div>
              <div><div style={{ color: 'var(--text-muted)', fontSize: '12px', marginBottom: '4px' }}>Date Filed</div><div style={{ fontWeight: 500 }}>{selectedClaim.date}</div></div>
              <div><div style={{ color: 'var(--text-muted)', fontSize: '12px', marginBottom: '4px' }}>Disruption Event</div><div style={{ fontWeight: 500 }}>{selectedClaim.type} in {selectedClaim.city}</div></div>
              <div><div style={{ color: 'var(--text-muted)', fontSize: '12px', marginBottom: '4px' }}>Payout Amount</div><div style={{ fontWeight: 600, color: 'var(--accent-teal)' }}>₹{selectedClaim.payout}</div></div>
            </div>

            {selectedClaim.status === 'fraud_flagged' && (
              <div style={{ padding: '16px', background: 'rgba(255,107,107,0.1)', border: '1px solid rgba(255,107,107,0.3)', borderRadius: '8px' }}>
                <h4 style={{ color: 'var(--accent-red)', margin: '0 0 8px 0', display: 'flex', alignItems: 'center', gap: '8px' }}><span>🚩</span> Fraud Flag Warning</h4>
                <p style={{ fontSize: '14px', margin: 0 }}>This claim was flagged because the worker's GPS coordinates at the time of disruption were 45km away from the declared zone. AI Confidence: 85%.</p>
              </div>
            )}

            <div>
              <h4 style={{ margin: '0 0 12px 0' }}>Timeline</h4>
              <div style={{ borderLeft: '2px solid var(--border)', marginLeft: '8px', paddingLeft: '16px', display: 'flex', flexDirection: 'column', gap: '16px' }}>
                <div style={{ position: 'relative' }}>
                  <div style={{ position: 'absolute', left: '-21px', top: '2px', width: '10px', height: '10px', borderRadius: '50%', background: 'var(--accent-teal)' }}></div>
                  <div style={{ fontSize: '13px', color: 'var(--text-secondary)' }}>{selectedClaim.date} 14:00</div>
                  <div style={{ fontSize: '14px', fontWeight: 500 }}>Disruption Event Detected</div>
                </div>
                <div style={{ position: 'relative' }}>
                  <div style={{ position: 'absolute', left: '-21px', top: '2px', width: '10px', height: '10px', borderRadius: '50%', background: 'var(--accent-purple)' }}></div>
                  <div style={{ fontSize: '13px', color: 'var(--text-secondary)' }}>{selectedClaim.date} 14:05</div>
                  <div style={{ fontSize: '14px', fontWeight: 500 }}>Claim Auto-Generated</div>
                </div>
              </div>
            </div>
          </div>
        )}
      </Modal>
    </div>
  );
}
