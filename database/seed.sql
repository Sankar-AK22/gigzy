-- =============================================
-- GigShield - Sample Seed Data
-- =============================================

-- Sample Users (Gig Workers)
INSERT INTO users (id, firebase_uid, name, phone, city, platform, avg_daily_income, working_hours, zone, latitude, longitude, risk_score) VALUES
('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'firebase_uid_001', 'Rahul Kumar', '+919876543210', 'Mumbai', 'Swiggy', 800.00, 10, 'Andheri West', 19.1364, 72.8296, 0.65),
('b2c3d4e5-f6a7-8901-bcde-f12345678901', 'firebase_uid_002', 'Priya Sharma', '+919876543211', 'Delhi', 'Zomato', 750.00, 8, 'Connaught Place', 28.6315, 77.2167, 0.45),
('c3d4e5f6-a7b8-9012-cdef-123456789012', 'firebase_uid_003', 'Amit Patel', '+919876543212', 'Bangalore', 'Blinkit', 900.00, 9, 'Koramangala', 12.9352, 77.6245, 0.55),
('d4e5f6a7-b8c9-0123-defa-234567890123', 'firebase_uid_004', 'Sunita Devi', '+919876543213', 'Chennai', 'Amazon', 700.00, 8, 'T Nagar', 13.0418, 80.2341, 0.70),
('e5f6a7b8-c9d0-1234-efab-345678901234', 'firebase_uid_005', 'Vikram Singh', '+919876543214', 'Pune', 'Dunzo', 850.00, 10, 'Kothrud', 18.5074, 73.8077, 0.40),
('f6a7b8c9-d0e1-2345-fabc-456789012345', 'firebase_uid_006', 'Anjali Rao', '+919876543215', 'Hyderabad', 'Swiggy', 780.00, 9, 'Madhapur', 17.4486, 78.3908, 0.50),
('a7b8c9d0-e1f2-3456-abcd-567890123456', 'firebase_uid_007', 'Deepak Verma', '+919876543216', 'Mumbai', 'Zomato', 820.00, 10, 'Bandra', 19.0596, 72.8295, 0.72),
('b8c9d0e1-f2a3-4567-bcde-678901234567', 'firebase_uid_008', 'Kavitha Nair', '+919876543217', 'Bangalore', 'Zepto', 680.00, 7, 'Indiranagar', 12.9784, 77.6408, 0.35);

-- Sample Policies
INSERT INTO policies (id, user_id, premium, coverage_limit, start_date, end_date, status, risk_score) VALUES
('11111111-1111-1111-1111-111111111111', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', 35.00, 1200.00, '2026-03-03', '2026-03-10', 'active', 0.65),
('22222222-2222-2222-2222-222222222222', 'b2c3d4e5-f6a7-8901-bcde-f12345678901', 22.00, 900.00, '2026-03-03', '2026-03-10', 'active', 0.45),
('33333333-3333-3333-3333-333333333333', 'c3d4e5f6-a7b8-9012-cdef-123456789012', 28.00, 1050.00, '2026-03-03', '2026-03-10', 'active', 0.55),
('44444444-4444-4444-4444-444444444444', 'd4e5f6a7-b8c9-0123-defa-234567890123', 38.00, 1300.00, '2026-03-03', '2026-03-10', 'active', 0.70),
('55555555-5555-5555-5555-555555555555', 'e5f6a7b8-c9d0-1234-efab-345678901234', 18.00, 800.00, '2026-02-24', '2026-03-03', 'expired', 0.40),
('66666666-6666-6666-6666-666666666666', 'a7b8c9d0-e1f2-3456-abcd-567890123456', 40.00, 1400.00, '2026-03-03', '2026-03-10', 'active', 0.72);

-- Sample Disruptions
INSERT INTO disruptions (id, type, location, city, severity, description, parameter_value, parameter_unit, latitude, longitude, radius_km, started_at, ended_at, is_active) VALUES
('aaaa1111-aaaa-1111-aaaa-111111111111', 'rainfall', 'Andheri West', 'Mumbai', 'high', 'Heavy rainfall causing waterlogging', 85.00, 'mm', 19.1364, 72.8296, 8.0, '2026-03-07 14:00:00+05:30', '2026-03-07 22:00:00+05:30', FALSE),
('bbbb2222-bbbb-2222-bbbb-222222222222', 'heatwave', 'Connaught Place', 'Delhi', 'critical', 'Extreme heat wave advisory', 44.50, '°C', 28.6315, 77.2167, 15.0, '2026-03-08 10:00:00+05:30', NULL, TRUE),
('cccc3333-cccc-3333-cccc-333333333333', 'pollution', 'Madhapur', 'Hyderabad', 'medium', 'AQI exceeding safe limits', 380.00, 'AQI', 17.4486, 78.3908, 10.0, '2026-03-09 06:00:00+05:30', NULL, TRUE),
('dddd4444-dddd-4444-dddd-444444444444', 'flood', 'Bandra', 'Mumbai', 'critical', 'Severe flooding due to high tides and rain', 120.00, 'mm', 19.0596, 72.8295, 5.0, '2026-03-07 16:00:00+05:30', '2026-03-08 06:00:00+05:30', FALSE);

-- Sample Claims
INSERT INTO claims (id, user_id, policy_id, disruption_id, disruption_type, lost_hours, hourly_rate, payout_amount, claim_status, fraud_score, auto_triggered) VALUES
('claim001-0001-0001-0001-000000000001', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', '11111111-1111-1111-1111-111111111111', 'aaaa1111-aaaa-1111-aaaa-111111111111', 'rainfall', 5.0, 80.00, 400.00, 'paid', 0.05, TRUE),
('claim002-0002-0002-0002-000000000002', 'b2c3d4e5-f6a7-8901-bcde-f12345678901', '22222222-2222-2222-2222-222222222222', 'bbbb2222-bbbb-2222-bbbb-222222222222', 'heatwave', 4.0, 93.75, 375.00, 'approved', 0.08, TRUE),
('claim003-0003-0003-0003-000000000003', 'a7b8c9d0-e1f2-3456-abcd-567890123456', '66666666-6666-6666-6666-666666666666', 'dddd4444-dddd-4444-dddd-444444444444', 'flood', 8.0, 82.00, 656.00, 'paid', 0.03, TRUE),
('claim004-0004-0004-0004-000000000004', 'f6a7b8c9-d0e1-2345-fabc-456789012345', '11111111-1111-1111-1111-111111111111', 'cccc3333-cccc-3333-cccc-333333333333', 'pollution', 3.0, 86.67, 260.00, 'fraud_flagged', 0.85, TRUE);

-- Sample Transactions
INSERT INTO transactions (id, claim_id, user_id, type, amount, payment_status, razorpay_order_id, razorpay_payment_id) VALUES
('txn00001-0001-0001-0001-000000000001', 'claim001-0001-0001-0001-000000000001', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'claim_payout', 400.00, 'completed', 'order_MockRzp001', 'pay_MockRzp001'),
('txn00002-0002-0002-0002-000000000002', NULL, 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'premium_payment', 35.00, 'completed', 'order_MockRzp002', 'pay_MockRzp002'),
('txn00003-0003-0003-0003-000000000003', 'claim003-0003-0003-0003-000000000003', 'a7b8c9d0-e1f2-3456-abcd-567890123456', 'claim_payout', 656.00, 'completed', 'order_MockRzp003', 'pay_MockRzp003'),
('txn00004-0004-0004-0004-000000000004', NULL, 'b2c3d4e5-f6a7-8901-bcde-f12345678901', 'premium_payment', 22.00, 'completed', 'order_MockRzp004', 'pay_MockRzp004');

-- Sample Notifications
INSERT INTO notifications (user_id, title, message, type, is_read) VALUES
('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'Policy Activated', 'Your weekly insurance policy is now active. Coverage: ₹1200', 'policy', TRUE),
('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'Claim Auto-Triggered', 'Heavy rainfall detected in your zone. Claim of ₹400 has been initiated.', 'claim', TRUE),
('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'Payout Received', '₹400 has been credited to your wallet.', 'payout', FALSE),
('b2c3d4e5-f6a7-8901-bcde-f12345678901', 'Heatwave Alert', 'Extreme heat detected in your area. Stay safe, claim is being processed.', 'disruption', FALSE),
('a7b8c9d0-e1f2-3456-abcd-567890123456', 'Payout Received', '₹656 has been credited for flood disruption claim.', 'payout', TRUE);
