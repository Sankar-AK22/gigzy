import React, { useState } from 'react';
import SearchFilter from '../components/SearchFilter';
import Pagination from '../components/Pagination';
import Modal from '../components/Modal';
import { useToast } from '../components/Toast';

const samplePolicies = [
  { id: 'POL-1001', worker: 'Rahul Kumar', city: 'Mumbai', coverage: 1200, premium: 35, start: '2026-03-03', end: '2026-03-10', status: 'active' },
  { id: 'POL-1002', worker: 'Priya Sharma', city: 'Delhi', coverage: 900, premium: 22, start: '2026-03-03', end: '2026-03-10', status: 'active' },
  { id: 'POL-1003', worker: 'Deepak Verma', city: 'Mumbai', coverage: 1400, premium: 40, start: '2026-02-24', end: '2026-03-03', status: 'expired' },
  { id: 'POL-1004', worker: 'Anjali Rao', city: 'Hyderabad', coverage: 800, premium: 18, start: '2026-03-01', end: '2026-03-08', status: 'claimed' },
  { id: 'POL-1005', worker: 'Amit Patel', city: 'Bangalore', coverage: 1050, premium: 28, start: '2026-03-05', end: '2026-03-12', status: 'active' },
  { id: 'POL-1006', worker: 'Sunita Devi', city: 'Chennai', coverage: 1300, premium: 38, start: '2026-03-05', end: '2026-03-12', status: 'active' },
];

export default function Policies() {
  const [searchTerm, setSearchTerm] = useState('');
  const [filters, setFilters] = useState({});
  const [page, setPage] = useState(1);
  const [itemsPerPage, setItemsPerPage] = useState(10);
  const [showCreateModal, setShowCreateModal] = useState(false);
  const { addToast } = useToast();

  const handleFilterChange = (key, value) => {
    setFilters(prev => ({ ...prev, [key]: value }));
  };

  const getStatusBadge = (status) => {
    switch(status) {
      case 'active': return <span className="badge badge-active">Active</span>;
      case 'expired': return <span className="badge badge-expired">Expired</span>;
      case 'cancelled': return <span className="badge badge-cancelled">Cancelled</span>;
      case 'claimed': return <span className="badge badge-claimed">Claimed</span>;
      default: return <span className="badge badge-pending">{status}</span>;
    }
  };

  const handleCreatePolicy = () => {
    addToast('Success', 'New policy template created', 'success');
    setShowCreateModal(false);
  };

  return (
    <div>
      <div className="page-header">
        <div className="page-header-text">
          <h2>📑 Policy Management</h2>
          <p>Manage parametric insurance policies and coverage parameters</p>
        </div>
        <div className="page-actions">
          <button className="btn btn-secondary" onClick={() => addToast('Export', 'Downloading CSV...', 'info')}>📥 Export</button>
          <button className="btn btn-primary" onClick={() => setShowCreateModal(true)}>+ New Policy</button>
        </div>
      </div>

      <div className="stats-grid" style={{ gridTemplateColumns: 'repeat(4,1fr)' }}>
        <div className="stat-card">
          <div className="stat-value">1,245</div>
          <div className="stat-label">Total Active Policies</div>
        </div>
        <div className="stat-card">
          <div className="stat-value" style={{ color: 'var(--accent-teal)' }}>₹43,500</div>
          <div className="stat-label">Weekly Premium</div>
        </div>
        <div className="stat-card">
          <div className="stat-value" style={{ color: 'var(--accent-purple)' }}>₹1,150</div>
          <div className="stat-label">Avg Coverage Limit</div>
        </div>
        <div className="stat-card">
          <div className="stat-value" style={{ color: 'var(--accent-orange)' }}>8.4%</div>
          <div className="stat-label">Claim Rate</div>
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
              { key: 'status', label: 'All Statuses', values: [{value: 'active', label: 'Active'}, {value: 'expired', label: 'Expired'}, {value: 'claimed', label: 'Claimed'}] },
              { key: 'city', label: 'All Cities', values: [{value: 'Mumbai', label: 'Mumbai'}, {value: 'Delhi', label: 'Delhi'}, {value: 'Bangalore', label: 'Bangalore'}] }
            ]}
          />
        </div>

        <table className="data-table">
          <thead>
            <tr>
              <th>Policy ID</th>
              <th>Worker / City</th>
              <th>Coverage</th>
              <th>Premium (Wk)</th>
              <th>Valid Period</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {samplePolicies.map(p => (
              <tr key={p.id}>
                <td style={{ fontWeight: 600, color: 'var(--accent-purple)' }}>{p.id}</td>
                <td>
                  <div style={{ fontWeight: 500 }}>{p.worker}</div>
                  <div style={{ fontSize: '12px', color: 'var(--text-muted)' }}>{p.city}</div>
                </td>
                <td style={{ fontWeight: 600 }}>₹{p.coverage}</td>
                <td>₹{p.premium}</td>
                <td>
                  <div style={{ fontSize: '13px' }}>{p.start}</div>
                  <div style={{ fontSize: '12px', color: 'var(--text-muted)' }}>to {p.end}</div>
                </td>
                <td>{getStatusBadge(p.status)}</td>
                <td>
                  <button className="btn btn-secondary" style={{ padding: '6px 12px', fontSize: '12px' }}>View</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        
        <Pagination 
          currentPage={page} 
          totalPages={1} 
          onPageChange={setPage} 
          itemsPerPage={itemsPerPage}
          onItemsPerPageChange={setItemsPerPage}
        />
      </div>

      <Modal
        isOpen={showCreateModal}
        onClose={() => setShowCreateModal(false)}
        title="Create Custom Policy Template"
        footer={
          <>
            <button className="btn btn-secondary" onClick={() => setShowCreateModal(false)}>Cancel</button>
            <button className="btn btn-primary" onClick={handleCreatePolicy}>Create Template</button>
          </>
        }
      >
        <div style={{ display: 'grid', gap: '20px' }}>
          <div className="form-group">
            <label>Template Name</label>
            <input type="text" className="form-control" placeholder="e.g. Monsoon Special Cover" />
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '20px' }}>
            <div className="form-group">
              <label>Default Coverage (₹)</label>
              <input type="number" className="form-control" defaultValue={1000} />
            </div>
            <div className="form-group">
              <label>Base Premium (₹)</label>
              <input type="number" className="form-control" defaultValue={30} />
            </div>
          </div>
          <div className="form-group">
            <label>Applicable Triggers (Select multiple)</label>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', background: 'var(--bg-surface)', padding: '16px', borderRadius: '8px', border: '1px solid var(--border)' }}>
              <label className="checkbox-container"><input type="checkbox" defaultChecked /> Rainfall {'>'} 50mm</label>
              <label className="checkbox-container"><input type="checkbox" defaultChecked /> Temp {'>'} 42°C</label>
              <label className="checkbox-container"><input type="checkbox" /> AQI {'>'} 350</label>
              <label className="checkbox-container"><input type="checkbox" /> Flood Alert</label>
            </div>
          </div>
        </div>
      </Modal>
    </div>
  );
}
