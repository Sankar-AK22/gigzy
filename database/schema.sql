-- =============================================
-- GigShield - Parametric Insurance Platform
-- PostgreSQL Database Schema
-- =============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- USERS TABLE
-- Gig delivery workers
-- =============================================
CREATE TABLE users (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    firebase_uid    VARCHAR(128) UNIQUE NOT NULL,
    name            VARCHAR(100) NOT NULL,
    phone           VARCHAR(15) UNIQUE NOT NULL,
    city            VARCHAR(50) NOT NULL,
    platform        VARCHAR(30) NOT NULL CHECK (platform IN ('Swiggy', 'Zomato', 'Blinkit', 'Amazon', 'Dunzo', 'Zepto', 'Other')),
    avg_daily_income DECIMAL(10,2) NOT NULL DEFAULT 0,
    working_hours   INTEGER NOT NULL DEFAULT 8,
    zone            VARCHAR(100) NOT NULL,
    latitude        DOUBLE PRECISION,
    longitude       DOUBLE PRECISION,
    risk_score      DECIMAL(3,2) DEFAULT 0.00,
    is_active       BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_users_city ON users(city);
CREATE INDEX idx_users_platform ON users(platform);
CREATE INDEX idx_users_zone ON users(zone);
CREATE INDEX idx_users_firebase_uid ON users(firebase_uid);

-- =============================================
-- POLICIES TABLE
-- Weekly insurance policies
-- =============================================
CREATE TABLE policies (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    premium         DECIMAL(10,2) NOT NULL,
    coverage_limit  DECIMAL(10,2) NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE NOT NULL,
    status          VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'expired', 'cancelled', 'claimed')),
    risk_score      DECIMAL(3,2) NOT NULL,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_policies_user_id ON policies(user_id);
CREATE INDEX idx_policies_status ON policies(status);
CREATE INDEX idx_policies_dates ON policies(start_date, end_date);

-- =============================================
-- DISRUPTIONS TABLE
-- External disruption events
-- =============================================
CREATE TABLE disruptions (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type            VARCHAR(30) NOT NULL CHECK (type IN ('rainfall', 'heatwave', 'pollution', 'flood', 'curfew', 'storm', 'other')),
    location        VARCHAR(100) NOT NULL,
    city            VARCHAR(50) NOT NULL,
    severity        VARCHAR(10) NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    description     TEXT,
    parameter_value DECIMAL(10,2),
    parameter_unit  VARCHAR(20),
    latitude        DOUBLE PRECISION,
    longitude       DOUBLE PRECISION,
    radius_km       DECIMAL(5,2) DEFAULT 10.0,
    started_at      TIMESTAMP WITH TIME ZONE NOT NULL,
    ended_at        TIMESTAMP WITH TIME ZONE,
    is_active       BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_disruptions_city ON disruptions(city);
CREATE INDEX idx_disruptions_type ON disruptions(type);
CREATE INDEX idx_disruptions_active ON disruptions(is_active);

-- =============================================
-- CLAIMS TABLE
-- Auto-generated insurance claims
-- =============================================
CREATE TABLE claims (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    policy_id       UUID NOT NULL REFERENCES policies(id) ON DELETE CASCADE,
    disruption_id   UUID REFERENCES disruptions(id),
    disruption_type VARCHAR(30) NOT NULL,
    lost_hours      DECIMAL(4,1) NOT NULL DEFAULT 0,
    hourly_rate     DECIMAL(10,2) NOT NULL DEFAULT 0,
    payout_amount   DECIMAL(10,2) NOT NULL,
    claim_status    VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (claim_status IN ('pending', 'approved', 'rejected', 'paid', 'fraud_flagged')),
    fraud_score     DECIMAL(3,2) DEFAULT 0.00,
    fraud_reason    TEXT,
    auto_triggered  BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_claims_user_id ON claims(user_id);
CREATE INDEX idx_claims_policy_id ON claims(policy_id);
CREATE INDEX idx_claims_status ON claims(claim_status);
CREATE INDEX idx_claims_disruption ON claims(disruption_id);

-- =============================================
-- TRANSACTIONS TABLE
-- Payment transactions (Razorpay)
-- =============================================
CREATE TABLE transactions (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    claim_id        UUID REFERENCES claims(id) ON DELETE SET NULL,
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type            VARCHAR(20) NOT NULL CHECK (type IN ('premium_payment', 'claim_payout', 'refund')),
    amount          DECIMAL(10,2) NOT NULL,
    payment_status  VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (payment_status IN ('pending', 'processing', 'completed', 'failed', 'refunded')),
    razorpay_order_id    VARCHAR(100),
    razorpay_payment_id  VARCHAR(100),
    razorpay_signature   VARCHAR(256),
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_transactions_claim_id ON transactions(claim_id);
CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_status ON transactions(payment_status);

-- =============================================
-- NOTIFICATIONS TABLE
-- Push notifications for workers
-- =============================================
CREATE TABLE notifications (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title           VARCHAR(200) NOT NULL,
    message         TEXT NOT NULL,
    type            VARCHAR(30) NOT NULL CHECK (type IN ('policy', 'claim', 'payout', 'disruption', 'general')),
    is_read         BOOLEAN DEFAULT FALSE,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_read ON notifications(is_read);

-- =============================================
-- TRIGGER: Auto-update updated_at timestamp
-- =============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_policies_updated_at BEFORE UPDATE ON policies
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_claims_updated_at BEFORE UPDATE ON claims
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_transactions_updated_at BEFORE UPDATE ON transactions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
