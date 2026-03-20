import React, { useState } from 'react';
import { BrowserRouter as Router } from 'react-router-dom';
import Sidebar from './components/Sidebar';
import Dashboard from './pages/Dashboard';
import Workers from './pages/Workers';
import Claims from './pages/Claims';
import FraudAlerts from './pages/FraudAlerts';

function App() {
  const [activePage, setActivePage] = useState('dashboard');

  const renderPage = () => {
    switch (activePage) {
      case 'workers': return <Workers />;
      case 'claims': return <Claims />;
      case 'fraud': return <FraudAlerts />;
      default: return <Dashboard />;
    }
  };

  return (
    <Router>
      <div className="app-layout">
        <Sidebar activePage={activePage} setActivePage={setActivePage} />
        <main className="main-content">
          {renderPage()}
        </main>
      </div>
    </Router>
  );
}

export default App;
