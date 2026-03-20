import React from 'react';
import { BarChart, Bar, LineChart, Line, PieChart, Pie, Cell, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, AreaChart, Area } from 'recharts';
import StatCard from '../components/StatCard';

const claimsData = [
  { week: 'W1', claims: 12, payouts: 8400 },
  { week: 'W2', claims: 8, payouts: 5200 },
  { week: 'W3', claims: 15, payouts: 11200 },
  { week: 'W4', claims: 22, payouts: 16800 },
  { week: 'W5', claims: 18, payouts: 13500 },
  { week: 'W6', claims: 25, payouts: 19200 },
];

const premiumData = [
  { week: 'W1', collected: 4200, workers: 120 },
  { week: 'W2', collected: 5100, workers: 145 },
  { week: 'W3', collected: 6300, workers: 180 },
  { week: 'W4', collected: 7800, workers: 220 },
  { week: 'W5', collected: 8200, workers: 235 },
  { week: 'W6', collected: 9100, workers: 260 },
];

const disruptionTypes = [
  { name: 'Rainfall', value: 35, color: '#4ecdc4' },
  { name: 'Heatwave', value: 25, color: '#ff6b6b' },
  { name: 'Pollution', value: 20, color: '#ffb84d' },
  { name: 'Flood', value: 12, color: '#6c63ff' },
  { name: 'Curfew', value: 8, color: '#00d4aa' },
];

const cityRisk = [
  { city: 'Mumbai', risk: 0.82 },
  { city: 'Delhi', risk: 0.75 },
  { city: 'Chennai', risk: 0.70 },
  { city: 'Kolkata', risk: 0.65 },
  { city: 'Hyderabad', risk: 0.50 },
  { city: 'Bangalore', risk: 0.45 },
  { city: 'Pune', risk: 0.40 },
];

export default function Dashboard() {
  return (
    <div>
      <div className="page-header">
        <h2>Dashboard Overview</h2>
        <p>Real-time analytics for GigShield parametric insurance platform</p>
      </div>

      <div className="stats-grid">
        <StatCard icon="👷" iconBg="rgba(108,99,255,0.15)" value="260" label="Total Insured Workers" change="+12% this week" changeType="up" />
        <StatCard icon="💰" iconBg="rgba(0,212,170,0.15)" value="₹9,100" label="Weekly Premium Collected" change="+11% this week" changeType="up" />
        <StatCard icon="📋" iconBg="rgba(255,184,77,0.15)" value="25" label="Claims This Week" change="+38% vs last week" changeType="up" />
        <StatCard icon="🚨" iconBg="rgba(255,107,107,0.15)" value="3" label="Fraud Alerts" change="-2 from last week" changeType="down" />
      </div>

      <div className="charts-grid">
        <div className="chart-card">
          <h3>📈 Claims Trend</h3>
          <ResponsiveContainer width="100%" height={280}>
            <AreaChart data={claimsData}>
              <defs>
                <linearGradient id="claimGrad" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#6c63ff" stopOpacity={0.3} />
                  <stop offset="95%" stopColor="#6c63ff" stopOpacity={0} />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.05)" />
              <XAxis dataKey="week" stroke="rgba(255,255,255,0.3)" fontSize={12} />
              <YAxis stroke="rgba(255,255,255,0.3)" fontSize={12} />
              <Tooltip contentStyle={{ background: '#1d1e33', border: '1px solid rgba(255,255,255,0.1)', borderRadius: 8, color: '#fff' }} />
              <Area type="monotone" dataKey="claims" stroke="#6c63ff" fill="url(#claimGrad)" strokeWidth={2} />
            </AreaChart>
          </ResponsiveContainer>
        </div>

        <div className="chart-card">
          <h3>💰 Premium Collection</h3>
          <ResponsiveContainer width="100%" height={280}>
            <BarChart data={premiumData}>
              <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.05)" />
              <XAxis dataKey="week" stroke="rgba(255,255,255,0.3)" fontSize={12} />
              <YAxis stroke="rgba(255,255,255,0.3)" fontSize={12} />
              <Tooltip contentStyle={{ background: '#1d1e33', border: '1px solid rgba(255,255,255,0.1)', borderRadius: 8, color: '#fff' }} />
              <Bar dataKey="collected" fill="#00d4aa" radius={[6, 6, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>

        <div className="chart-card">
          <h3>🎯 Disruption Types</h3>
          <ResponsiveContainer width="100%" height={280}>
            <PieChart>
              <Pie data={disruptionTypes} cx="50%" cy="50%" innerRadius={60} outerRadius={100} paddingAngle={4} dataKey="value" label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`} labelLine={{ stroke: 'rgba(255,255,255,0.3)' }}>
                {disruptionTypes.map((entry, i) => <Cell key={i} fill={entry.color} />)}
              </Pie>
              <Tooltip contentStyle={{ background: '#1d1e33', border: '1px solid rgba(255,255,255,0.1)', borderRadius: 8, color: '#fff' }} />
            </PieChart>
          </ResponsiveContainer>
        </div>

        <div className="chart-card">
          <h3>🗺️ City Risk Heatmap</h3>
          <ResponsiveContainer width="100%" height={280}>
            <BarChart data={cityRisk} layout="vertical">
              <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.05)" />
              <XAxis type="number" domain={[0, 1]} stroke="rgba(255,255,255,0.3)" fontSize={12} />
              <YAxis dataKey="city" type="category" stroke="rgba(255,255,255,0.3)" fontSize={12} width={80} />
              <Tooltip contentStyle={{ background: '#1d1e33', border: '1px solid rgba(255,255,255,0.1)', borderRadius: 8, color: '#fff' }} />
              <Bar dataKey="risk" radius={[0, 6, 6, 0]}>
                {cityRisk.map((entry, i) => (
                  <Cell key={i} fill={entry.risk > 0.7 ? '#ff6b6b' : entry.risk > 0.5 ? '#ffb84d' : '#00d4aa'} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>
    </div>
  );
}
