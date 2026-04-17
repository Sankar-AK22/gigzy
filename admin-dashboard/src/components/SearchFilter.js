import React from 'react';

export default function SearchFilter({ 
  searchTerm, 
  onSearchChange, 
  filters, 
  onFilterChange, 
  filterOptions 
}) {
  return (
    <div style={{ display: 'flex', gap: '16px', marginBottom: '24px', flexWrap: 'wrap' }}>
      <div className="search-bar" style={{ width: 'auto', flex: 1, maxWidth: '400px', display: 'flex' }}>
        <span>🔍</span>
        <input 
          type="text" 
          placeholder="Search..." 
          value={searchTerm}
          onChange={(e) => onSearchChange(e.target.value)}
        />
      </div>
      
      {filterOptions && filterOptions.map(option => (
        <select 
          key={option.key}
          className="form-control" 
          style={{ width: 'auto', minWidth: '150px' }}
          value={filters[option.key] || ''}
          onChange={(e) => onFilterChange(option.key, e.target.value)}
        >
          <option value="">{option.label}</option>
          {option.values.map(val => (
            <option key={val.value} value={val.value}>{val.label}</option>
          ))}
        </select>
      ))}
    </div>
  );
}
