import React from 'react';

const workers = [
  { name: 'Rahul Kumar', phone: '+91 9876543210', city: 'Mumbai', platform: 'Swiggy', zone: 'Andheri West', income: '₹800', risk: 0.65, status: 'active' },
  { name: 'Priya Sharma', phone: '+91 9876543211', city: 'Delhi', platform: 'Zomato', zone: 'Connaught Place', income: '₹750', risk: 0.45, status: 'active' },
  { name: 'Amit Patel', phone: '+91 9876543212', city: 'Bangalore', platform: 'Blinkit', zone: 'Koramangala', income: '₹900', risk: 0.55, status: 'active' },
  { name: 'Sunita Devi', phone: '+91 9876543213', city: 'Chennai', platform: 'Amazon', zone: 'T Nagar', income: '₹700', risk: 0.70, status: 'active' },
  { name: 'Vikram Singh', phone: '+91 9876543214', city: 'Pune', platform: 'Dunzo', zone: 'Kothrud', income: '₹850', risk: 0.40, status: 'expired' },
  { name: 'Anjali Rao', phone: '+91 9876543215', city: 'Hyderabad', platform: 'Swiggy', zone: 'Madhapur', income: '₹780', risk: 0.50, status: 'active' },
  { name: 'Deepak Verma', phone: '+91 9876543216', city: 'Mumbai', platform: 'Zomato', zone: 'Bandra', income: '₹820', risk: 0.72, status: 'active' },
  { name: 'Kavitha Nair', phone: '+91 9876543217', city: 'Bangalore', platform: 'Zepto', zone: 'Indiranagar', income: '₹680', risk: 0.35, status: 'active' },
];

const riskColor = (r) => r >= 0.7 ? '#ff6b6b' : r >= 0.5 ? '#ffb84d' : '#00d4aa';

export default function Workers() {
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
            </tr>
          </thead>
          <tbody>
            {workers.map((w, i) => (
              <tr key={i}>
                <td>
                  <div style={{ fontWeight: 600 }}>{w.name}</div>
                  <div style={{ color: 'var(--text-muted)', fontSize: 12 }}>{w.phone}</div>
                </td>
                <td>
                  <div>{w.city}</div>
                  <div style={{ color: 'var(--text-muted)', fontSize: 12 }}>{w.zone}</div>
                </td>
                <td>{w.platform}</td>
                <td>{w.income}/day</td>
                <td>
                  <span style={{ color: riskColor(w.risk), fontWeight: 600 }}>{w.risk.toFixed(2)}</span>
                </td>
                <td>
                  <span className={`badge badge-${w.status === 'active' ? 'active' : 'pending'}`}>
                    {w.status === 'active' ? '● Active' : '○ Expired'}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
