import React, { useEffect, useState } from 'react';

export default function StatCard({ icon, iconBg, value, label, change, changeType, prefix = '' }) {
  const [displayValue, setDisplayValue] = useState(0);
  const numericValue = typeof value === 'string' ? parseFloat(value.replace(/,/g, '')) : value;
  const isNumber = !isNaN(numericValue);

  useEffect(() => {
    if (!isNumber) return;
    let start = 0;
    const duration = 1000;
    const increment = numericValue / (duration / 16);
    
    const timer = setInterval(() => {
      start += increment;
      if (start >= numericValue) {
        clearInterval(timer);
        setDisplayValue(numericValue);
      } else {
        setDisplayValue(start);
      }
    }, 16);
    return () => clearInterval(timer);
  }, [numericValue, isNumber]);

  const formattedValue = isNumber 
    ? (displayValue % 1 !== 0 ? displayValue.toFixed(1) : Math.floor(displayValue)).toLocaleString() 
    : value;

  return (
    <div className="stat-card">
      <div className="stat-card-header">
        <div className="stat-icon" style={{ background: iconBg }}>
          {icon}
        </div>
        {change && (
          <div className={`stat-change ${changeType}`}>
            {changeType === 'up' ? '↑' : '↓'} {change}
          </div>
        )}
      </div>
      <div className="stat-value-wrap">
        <div className="stat-value">{prefix}{isNumber ? formattedValue : value}</div>
      </div>
      <div className="stat-label">{label}</div>
    </div>
  );
}
