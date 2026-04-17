import React, { useState, useEffect } from 'react';
import SearchFilter from '../components/SearchFilter';
import Pagination from '../components/Pagination';
import Modal from '../components/Modal';
import { useToast } from '../components/Toast';

const MOCK_WORKERS = [
  { id: 'usr_001', name: 'Rahul Kumar', phone: '+91 98765 43210', city: 'Mumbai', zone: 'Andheri West', platform: 'Swiggy', avgDailyIncome: 800, riskScore: 0.65, status: 'active' },
  { id: 'usr_002', name: 'Priya Sharma', phone: '+91 98765 43211', city: 'Delhi', zone: 'Connaught Place', platform: 'Zomato', avgDailyIncome: 750, riskScore: 0.45, status: 'active' },
  { id: 'usr_003', name: 'Amit Patel', phone: '+91 98765 43212', city: 'Bangalore', zone: 'Koramangala', platform: 'Blinkit', avgDailyIncome: 900, riskScore: 0.55, status: 'active' },
  { id: 'usr_004', name: 'Sunita Devi', phone: '+91 98765 43213', city: 'Chennai', zone: 'T Nagar', platform: 'Amazon', avgDailyIncome: 700, riskScore: 0.70, status: 'inactive' },
  { id: 'usr_005', name: 'Vikram Singh', phone: '+91 98765 43214', city: 'Pune', zone: 'Kothrud', platform: 'Dunzo', avgDailyIncome: 850, riskScore: 0.40, status: 'active' },
  { id: 'usr_006', name: 'Anjali Rao', phone: '+91 98765 43215', city: 'Hyderabad', zone: 'Madhapur', platform: 'Swiggy', avgDailyIncome: 780, riskScore: 0.50, status: 'inactive' },
  { id: 'usr_007', name: 'Deepak Verma', phone: '+91 98765 43216', city: 'Mumbai', zone: 'Bandra', platform: 'Zomato', avgDailyIncome: 820, riskScore: 0.72, status: 'inactive' },
  { id: 'usr_008', name: 'Kavitha Nair', phone: '+91 98765 43217', city: 'Bangalore', zone: 'Indiranagar', platform: 'Zepto', avgDailyIncome: 680, riskScore: 0.35, status: 'active' }
];

export default function Workers() {
  const [workers, setWorkers] = useState([]);
  const [filteredWorkers, setFilteredWorkers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [filters, setFilters] = useState({});
  const [page, setPage] = useState(1);
  const [itemsPerPage, setItemsPerPage] = useState(10);
  const [selectedWorker, setSelectedWorker] = useState(null);
  const { addToast } = useToast();

  useEffect(() => {
    // Simulate network load
    const timer = setTimeout(() => {
      setWorkers(MOCK_WORKERS);
      setLoading(false);
    }, 500);
    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    let result = workers;
    
    if (searchTerm) {
      const lower = searchTerm.toLowerCase();
      result = result.filter(w => 
        (w.name && w.name.toLowerCase().includes(lower)) || 
        (w.city && w.city.toLowerCase().includes(lower)) ||
        (w.phone && w.phone.includes(lower))
      );
    }
    
    if (filters.platform) result = result.filter(w => w.platform === filters.platform);
    if (filters.status) result = result.filter(w => w.status === filters.status);
    
    setFilteredWorkers(result);
    setPage(1); 
  }, [workers, searchTerm, filters]);

  const assignPolicy = async (workerId) => {
    try {
      // Mock update
      setWorkers(prev => prev.map(w => w.id === workerId ? { ...w, status: 'active' } : w));
      addToast('Success', 'Policy assigned successfully', 'success');
    } catch (error) {
      console.error("Error assigning policy: ", error);
      addToast('Error', 'Failed to assign policy', 'error');
    }
  };

  const handleFilterChange = (key, value) => {
    setFilters(prev => ({ ...prev, [key]: value }));
  };

  const totalPages = Math.ceil(filteredWorkers.length / itemsPerPage);
  const paginatedWorkers = filteredWorkers.slice((page - 1) * itemsPerPage, page * itemsPerPage);

  const getRiskBadge = (score) => {
    if (score >= 0.7) return <span className="badge badge-critical">High Risk</span>;
    if (score >= 0.4) return <span className="badge badge-medium">Medium Risk</span>;
    return <span className="badge badge-low">Low Risk</span>;
  };

  const exportCSV = () => {
    addToast('Export', 'Downloading workers list...', 'info');
  };

  return (
    <div>
      <div className="page-header">
        <div className="page-header-text">
          <h2>👷 Workers Management</h2>
          <p>{workers.length} registered gig workers in the system</p>
        </div>
        <div className="page-actions">
          <button className="btn btn-secondary" onClick={exportCSV}>📥 Export CSV</button>
          <button className="btn btn-primary" onClick={() => addToast('Info', 'Add Worker via App', 'info')}>+ Add Worker</button>
        </div>
      </div>

      <div className="stats-grid" style={{ gridTemplateColumns: 'repeat(4,1fr)' }}>
        <div className="stat-card">
          <div className="stat-value">{workers.length}</div>
          <div className="stat-label">Total Workers</div>
        </div>
        <div className="stat-card">
          <div className="stat-value" style={{ color: 'var(--accent-teal)' }}>{workers.filter(w => w.status === 'active').length}</div>
          <div className="stat-label">Active Policies</div>
        </div>
        <div className="stat-card">
          <div className="stat-value" style={{ color: 'var(--accent-red)' }}>{workers.filter(w => w.riskScore >= 0.7).length}</div>
          <div className="stat-label">High Risk Profiling</div>
        </div>
        <div className="stat-card">
          <div className="stat-value">₹{(workers.reduce((acc, w) => acc + (w.avgDailyIncome || 0), 0) / (workers.length || 1)).toFixed(0)}</div>
          <div className="stat-label">Avg Daily Income</div>
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
              { key: 'platform', label: 'All Platforms', values: [{value: 'Swiggy', label: 'Swiggy'}, {value: 'Zomato', label: 'Zomato'}, {value: 'Blinkit', label: 'Blinkit'}] },
              { key: 'status', label: 'All Statuses', values: [{value: 'active', label: 'Insured'}, {value: 'inactive', label: 'Uninsured'}] }
            ]}
          />
        </div>

        {loading ? (
          <div style={{ padding: '40px', textAlign: 'center', color: 'var(--text-muted)' }}>Loading workers data...</div>
        ) : (
          <table className="data-table">
            <thead>
              <tr>
                <th style={{ width: '40px' }}><input type="checkbox" /></th>
                <th>Worker Details</th>
                <th>Location</th>
                <th>Platform</th>
                <th>Income</th>
                <th>Risk Profile</th>
                <th>Policy Status</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              {paginatedWorkers.map(w => (
                <tr key={w.id} onClick={() => setSelectedWorker(w)}>
                  <td onClick={e => e.stopPropagation()}><input type="checkbox" /></td>
                  <td>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                      <div style={{ width: '36px', height: '36px', borderRadius: '50%', background: 'var(--bg-secondary)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 'bold' }}>
                        {w.name ? w.name.charAt(0).toUpperCase() : 'U'}
                      </div>
                      <div>
                        <div style={{ fontWeight: 600 }}>{w.name || 'Unknown User'}</div>
                        <div style={{ color: 'var(--text-muted)', fontSize: 12 }}>{w.phone || 'No phone'}</div>
                      </div>
                    </div>
                  </td>
                  <td>
                    <div style={{ fontWeight: 500 }}>{w.city || 'N/A'}</div>
                    <div style={{ color: 'var(--text-muted)', fontSize: 12 }}>{w.zone}</div>
                  </td>
                  <td><span className="badge badge-low">{w.platform}</span></td>
                  <td>₹{w.avgDailyIncome || 0}/day</td>
                  <td>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                      {getRiskBadge(w.riskScore)}
                    </div>
                  </td>
                  <td>
                    <span className={`badge badge-${w.status === 'active' ? 'active' : 'pending'}`}>
                      {w.status === 'active' ? 'Active' : 'Uninsured'}
                    </span>
                  </td>
                  <td onClick={e => e.stopPropagation()}>
                    {w.status !== 'active' ? (
                      <button className="btn btn-success" style={{ padding: '6px 12px', fontSize: '12px' }} onClick={() => assignPolicy(w.id)}>
                        Assign
                      </button>
                    ) : (
                      <button className="btn btn-secondary" style={{ padding: '6px 12px', fontSize: '12px' }}>
                        View
                      </button>
                    )}
                  </td>
                </tr>
              ))}
              {paginatedWorkers.length === 0 && (
                <tr>
                  <td colSpan="8" style={{ textAlign: 'center', padding: '40px', color: 'var(--text-muted)' }}>
                    No workers found matching your criteria.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        )}
        
        {!loading && (
          <Pagination 
            currentPage={page} 
            totalPages={totalPages} 
            onPageChange={setPage} 
            itemsPerPage={itemsPerPage}
            onItemsPerPageChange={setItemsPerPage}
          />
        )}
      </div>

      <Modal 
        isOpen={!!selectedWorker} 
        onClose={() => setSelectedWorker(null)}
        title="Worker Profile"
        footer={
          <>
            <button className="btn btn-secondary" onClick={() => setSelectedWorker(null)}>Close</button>
            <button className="btn btn-primary" onClick={() => {
              addToast('Message Sent', `Sent message to ${selectedWorker?.name}`, 'success');
              setSelectedWorker(null);
            }}>Send Message</button>
          </>
        }
      >
        {selectedWorker && (
          <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
              <div style={{ width: '64px', height: '64px', borderRadius: '50%', background: 'linear-gradient(135deg, var(--accent-purple), var(--accent-blue))', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '24px', color: 'white', fontWeight: 'bold' }}>
                {selectedWorker.name ? selectedWorker.name.charAt(0).toUpperCase() : 'U'}
              </div>
              <div>
                <h2 style={{ fontSize: '20px', marginBottom: '4px' }}>{selectedWorker.name || 'Unknown'}</h2>
                <div style={{ color: 'var(--text-secondary)' }}>ID: {selectedWorker.id}</div>
              </div>
              <div style={{ marginLeft: 'auto' }}>
                <span className={`badge badge-${selectedWorker.status === 'active' ? 'active' : 'pending'}`} style={{ fontSize: '14px', padding: '8px 16px' }}>
                  {selectedWorker.status === 'active' ? 'Policy Active' : 'No Policy'}
                </span>
              </div>
            </div>
            
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', background: 'var(--bg-surface)', padding: '16px', borderRadius: '8px' }}>
              <div>
                <div style={{ color: 'var(--text-muted)', fontSize: '12px', marginBottom: '4px' }}>Phone</div>
                <div style={{ fontWeight: 500 }}>{selectedWorker.phone || 'N/A'}</div>
              </div>
              <div>
                <div style={{ color: 'var(--text-muted)', fontSize: '12px', marginBottom: '4px' }}>Platform</div>
                <div style={{ fontWeight: 500 }}>{selectedWorker.platform}</div>
              </div>
              <div>
                <div style={{ color: 'var(--text-muted)', fontSize: '12px', marginBottom: '4px' }}>Location</div>
                <div style={{ fontWeight: 500 }}>{selectedWorker.zone}, {selectedWorker.city}</div>
              </div>
              <div>
                <div style={{ color: 'var(--text-muted)', fontSize: '12px', marginBottom: '4px' }}>Avg Daily Income</div>
                <div style={{ fontWeight: 500 }}>₹{selectedWorker.avgDailyIncome}</div>
              </div>
            </div>

            <div>
              <h4 style={{ marginBottom: '12px' }}>Risk Assessment</h4>
              <div style={{ background: 'var(--bg-surface)', padding: '16px', borderRadius: '8px' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
                  <span>Risk Score</span>
                  <span style={{ fontWeight: 'bold' }}>{(selectedWorker.riskScore * 100).toFixed(0)} / 100</span>
                </div>
                <div style={{ width: '100%', height: '8px', background: 'rgba(255,255,255,0.1)', borderRadius: '4px', overflow: 'hidden' }}>
                  <div style={{ 
                    height: '100%', 
                    width: `${selectedWorker.riskScore * 100}%`,
                    background: selectedWorker.riskScore >= 0.7 ? 'var(--accent-red)' : selectedWorker.riskScore >= 0.4 ? 'var(--accent-orange)' : 'var(--accent-teal)'
                  }}></div>
                </div>
              </div>
            </div>
          </div>
        )}
      </Modal>
    </div>
  );
}
