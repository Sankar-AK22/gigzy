import React, { useState } from 'react';
import { BrowserRouter as Router } from 'react-router-dom';
import Sidebar from './components/Sidebar';
import TopBar from './components/TopBar';
import { ToastProvider } from './components/Toast';
import Dashboard from './pages/Dashboard';
import Workers from './pages/Workers';
import Claims from './pages/Claims';
import FraudAlerts from './pages/FraudAlerts';
import Policies from './pages/Policies';
import Settings from './pages/Settings';

function AppContent() {
  const [activePage, setActivePage] = useState('dashboard');
  const [isSidebarCollapsed, setIsSidebarCollapsed] = useState(false);

  const renderPage = () => {
    switch (activePage) {
      case 'workers': return <Workers />;
      case 'claims': return <Claims />;
      case 'fraud': return <FraudAlerts />;
      case 'policies': return <Policies />;
      case 'settings': return <Settings />;
      default: return <Dashboard />;
    }
  };

  return (
    <div className="app-layout">
      <Sidebar 
        activePage={activePage} 
        setActivePage={setActivePage} 
        isCollapsed={isSidebarCollapsed} 
      />
      <main className="main-content">
        <TopBar onMenuClick={() => setIsSidebarCollapsed(!isSidebarCollapsed)} />
        <div className="page-container" key={activePage}>
          {renderPage()}
        </div>
      </main>
    </div>
  );
}

function App() {
  return (
    <Router>
      <ToastProvider>
        <AppContent />
      </ToastProvider>
    </Router>
  );
}

export default App;
