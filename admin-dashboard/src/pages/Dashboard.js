import React, { useState, useEffect } from 'react';
import { BarChart, Bar, LineChart, Line, PieChart, Pie, Cell, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, AreaChart, Area, ComposedChart } from 'recharts';
import StatCard from '../components/StatCard';
import { useToast } from '../components/Toast';

const claimsData = [
  { name: 'Mon', claims: 12, revenue: 8400 },
  { name: 'Tue', claims: 8, revenue: 5200 },
  { name: 'Wed', claims: 15, revenue: 11200 },
  { name: 'Thu', claims: 22, revenue: 16800 },
  { name: 'Fri', claims: 18, revenue: 13500 },
  { name: 'Sat', claims: 25, revenue: 19200 },
  { name: 'Sun', claims: 10, revenue: 7000 },
];

const disruptionTypes = [
  { name: 'Rainfall', value: 35, color: '#4ecdc4' },
  { name: 'Heatwave', value: 25, color: '#ff6b6b' },
  { name: 'Pollution', value: 20, color: '#ffb84d' },
  { name: 'Flood', value: 12, color: '#6c63ff' },
  { name: 'Curfew', value: 8, color: '#00d4aa' },
];

export default function Dashboard() {
  const [time, setTime] = useState(new Date());
  const [period, setPeriod] = useState('Week');
  const { addToast } = useToast();

  useEffect(() => {
    const timer = setInterval(() => setTime(new Date()), 1000);
    setTimeout(() => addToast('System Health', 'All services operating normally.', 'success'), 1000);
    return () => clearInterval(timer);
  }, [addToast]);

  const greeting = time.getHours() < 12 ? 'Good Morning' : time.getHours() < 18 ? 'Good Afternoon' : 'Good Evening';

  return (
    <div>
      <div className="page-header">
        <div className="page-header-text">
          <h2>{greeting}, Admin <span>👋</span></h2>
          <p>{time.toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })} · {time.toLocaleTimeString()}</p>
        </div>
        <div className="page-actions">
          <select className="form-control" value={period} onChange={e => setPeriod(e.target.value)}>
            <option>Today</option>
            <option>Week</option>
            <option>Month</option>
          </select>
          <button className="btn btn-primary" onClick={() => addToast('Report', 'Generating report...', 'info')}>
            📄 Export Report
          </button>
        </div>
      </div>

      <div style={{ background: 'linear-gradient(90deg, rgba(78,205,196,0.1), rgba(108,99,255,0.1))', padding: '12px 24px', borderRadius: 'var(--radius)', border: '1px solid var(--border)', marginBottom: '32px', display: 'flex', alignItems: 'center', gap: '16px' }}>
        <span style={{ fontSize: '20px' }}>🟢</span>
        <div style={{ flex: 1 }}>
          <div style={{ fontWeight: 600, fontSize: '14px' }}>All Systems Operational</div>
          <div style={{ color: 'var(--text-secondary)', fontSize: '13px' }}>AI Engine: 45ms latency · Database: 12ms latency</div>
        </div>
      </div>

      <div className="stats-grid">
        <StatCard icon="👷" iconBg="rgba(108,99,255,0.15)" value={260} label="Insured Workers" change="+12%" changeType="up" />
        <StatCard icon="💰" iconBg="rgba(0,212,170,0.15)" value={9100} prefix="₹" label="Premium Collected" change="+11%" changeType="up" />
        <StatCard icon="📋" iconBg="rgba(255,184,77,0.15)" value={25} label="Claims Processed" change="+38%" changeType="up" />
        <StatCard icon="🚨" iconBg="rgba(255,107,107,0.15)" value={3} label="Fraud Alerts" change="-2" changeType="down" />
      </div>

      <div className="charts-grid">
        <div className="chart-card">
          <div className="chart-header">
            <h3>📈 Revenue vs Claims</h3>
          </div>
          <ResponsiveContainer width="100%" height={300}>
            <ComposedChart data={claimsData}>
              <defs>
                <linearGradient id="colorRev" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#00d4aa" stopOpacity={0.8}/>
                  <stop offset="95%" stopColor="#00d4aa" stopOpacity={0}/>
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.05)" vertical={false} />
              <XAxis dataKey="name" stroke="rgba(255,255,255,0.3)" fontSize={12} tickLine={false} axisLine={false} />
              <YAxis yAxisId="left" stroke="rgba(255,255,255,0.3)" fontSize={12} tickLine={false} axisLine={false} tickFormatter={val => `₹${val/1000}k`} />
              <YAxis yAxisId="right" orientation="right" stroke="rgba(255,255,255,0.3)" fontSize={12} tickLine={false} axisLine={false} />
              <Tooltip contentStyle={{ background: 'var(--bg-card)', border: '1px solid var(--border)', borderRadius: '8px', color: 'var(--text-primary)' }} />
              <Area yAxisId="left" type="monotone" dataKey="revenue" fill="url(#colorRev)" stroke="#00d4aa" />
              <Line yAxisId="right" type="monotone" dataKey="claims" stroke="#6c63ff" strokeWidth={3} dot={{ r: 4 }} activeDot={{ r: 6 }} />
            </ComposedChart>
          </ResponsiveContainer>
        </div>

        <div className="chart-card">
          <div className="chart-header">
            <h3>🎯 Disruptions</h3>
          </div>
          <ResponsiveContainer width="100%" height={300}>
            <PieChart>
              <Pie data={disruptionTypes} cx="50%" cy="50%" innerRadius={60} outerRadius={100} paddingAngle={4} dataKey="value" stroke="none">
                {disruptionTypes.map((entry, i) => <Cell key={i} fill={entry.color} />)}
              </Pie>
              <Tooltip contentStyle={{ background: 'var(--bg-card)', border: '1px solid var(--border)', borderRadius: '8px', color: 'var(--text-primary)' }} />
            </PieChart>
          </ResponsiveContainer>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: '12px', justifyContent: 'center', marginTop: '16px' }}>
            {disruptionTypes.map(d => (
              <div key={d.name} style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '12px', color: 'var(--text-secondary)' }}>
                <div style={{ width: '10px', height: '10px', borderRadius: '50%', background: d.color }}></div>
                {d.name}
              </div>
            ))}
          </div>
        </div>
      </div>
      
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '24px' }}>
        <div className="chart-card">
          <h3>⚡ Live Activity</h3>
          <div style={{ marginTop: '16px', display: 'flex', flexDirection: 'column', gap: '16px' }}>
            {[1,2,3,4].map(i => (
              <div key={i} style={{ display: 'flex', gap: '12px', paddingBottom: '16px', borderBottom: i < 4 ? '1px solid var(--border)' : 'none' }}>
                <div style={{ width: '32px', height: '32px', borderRadius: '50%', background: i%2===0?'rgba(0,212,170,0.15)':'rgba(108,99,255,0.15)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '16px' }}>
                  {i%2===0 ? '💰' : '📋'}
                </div>
                <div>
                  <div style={{ fontSize: '14px', fontWeight: 500 }}>{i%2===0 ? 'Payout Processed' : 'New Policy Issued'}</div>
                  <div style={{ fontSize: '12px', color: 'var(--text-muted)' }}>{i*10} minutes ago · Worker {1000+i}</div>
                </div>
              </div>
            ))}
          </div>
        </div>
        <div className="chart-card">
          <h3>🎯 Weekly Targets</h3>
          <div style={{ display: 'flex', justifyContent: 'space-around', alignItems: 'center', height: '100%' }}>
            <div style={{ textAlign: 'center' }}>
              <div style={{ width: '100px', height: '100px', borderRadius: '50%', border: '8px solid var(--border)', borderTopColor: 'var(--accent-purple)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '24px', fontWeight: 'bold', margin: '0 auto 12px', transform: 'rotate(45deg)' }}>
                <span style={{ transform: 'rotate(-45deg)' }}>85%</span>
              </div>
              <div style={{ fontSize: '14px', color: 'var(--text-secondary)' }}>Policies Goal</div>
            </div>
            <div style={{ textAlign: 'center' }}>
              <div style={{ width: '100px', height: '100px', borderRadius: '50%', border: '8px solid var(--border)', borderTopColor: 'var(--accent-teal)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '24px', fontWeight: 'bold', margin: '0 auto 12px', transform: 'rotate(120deg)' }}>
                <span style={{ transform: 'rotate(-120deg)' }}>92%</span>
              </div>
              <div style={{ fontSize: '14px', color: 'var(--text-secondary)' }}>Claim Speed</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
