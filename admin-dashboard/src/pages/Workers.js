import React, { useState, useEffect } from 'react';
import { collection, onSnapshot, doc, updateDoc } from 'firebase/firestore';
import { db } from '../firebase';

const riskColor = (r) => r >= 0.7 ? '#ff6b6b' : r >= 0.5 ? '#ffb84d' : '#00d4aa';

export default function Workers() {
  const [workers, setWorkers] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = onSnapshot(collection(db, 'workers'), (snapshot) => {
      const workersData = snapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      }));
      setWorkers(workersData);
      setLoading(false);
    });
    return () => unsubscribe();
  }, []);

  const assignPolicy = async (workerId) => {
    try {
      const workerRef = doc(db, 'workers', workerId);
      await updateDoc(workerRef, {
        hasActivePolicy: true,
      });
    } catch (error) {
      console.error("Error assigning policy: ", error);
      alert("Failed to assign policy");
    }
  };

  if (loading) {
    return <div style={{ padding: 20 }}>Loading workers...</div>;
  }

  return (
    <div>
      <div className="page-header">
        <h2>Insured Workers</h2>
        <p>{workers.length} registered gig workers</p>
      </div>
      <div className="data-table">
        <table>
          <thead>
            <tr>
              <th>Worker</th>
              <th>City / Zone</th>
              <th>Platform</th>
              <th>Daily Income</th>
              <th>Risk Score</th>
              <th>Policy</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {workers.map((w) => {
              const risk = 0.45; // Default risk if not set
              const income = w.avgDailyIncome ? `₹${w.avgDailyIncome}` : 'N/A';
              const isActive = w.hasActivePolicy === true;
              
              return (
                <tr key={w.id}>
                  <td>
                    <div style={{ fontWeight: 600 }}>{w.name}</div>
                    <div style={{ color: 'var(--text-muted)', fontSize: 12 }}>{w.phone}</div>
                  </td>
                  <td>
                    <div>{w.city}</div>
                    <div style={{ color: 'var(--text-muted)', fontSize: 12 }}>{w.zone}</div>
                  </td>
                  <td>{w.platform}</td>
                  <td>{income}/day</td>
                  <td>
                    <span style={{ color: riskColor(risk), fontWeight: 600 }}>{risk.toFixed(2)}</span>
                  </td>
                  <td>
                    <span className={`badge badge-${isActive ? 'active' : 'pending'}`}>
                      {isActive ? '● Active' : '○ Pending'}
                    </span>
                  </td>
                  <td>
                    {!isActive && (
                      <button 
                        onClick={() => assignPolicy(w.id)}
                        style={{
                          background: 'linear-gradient(135deg, #00d4aa 0%, #00b386 100%)',
                          color: '#fff',
                          border: 'none',
                          padding: '6px 12px',
                          borderRadius: '6px',
                          cursor: 'pointer',
                          fontWeight: 600,
                          fontSize: '12px'
                        }}
                      >
                        Assign Policy
                      </button>
                    )}
                    {isActive && (
                      <span style={{ color: '#00d4aa', fontWeight: 600, fontSize: '12px' }}>Assigned</span>
                    )}
                  </td>
                </tr>
              );
            })}
            {workers.length === 0 && (
              <tr>
                <td colSpan="7" style={{ textAlign: 'center', padding: '20px' }}>
                  No workers found in Firestore. Try adding one from the Flutter app.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
