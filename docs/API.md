# 📡 GigShield API Documentation

## Base URL
- Backend: `http://localhost:8080/api`
- AI Service: `http://localhost:8000/api`

---

## 👤 User APIs

### Register User
```
POST /api/users/register
```
**Body:**
```json
{
  "firebaseUid": "firebase_uid_001",
  "name": "Rahul Kumar",
  "phone": "+919876543210",
  "city": "Mumbai",
  "platform": "Swiggy",
  "avgDailyIncome": 800,
  "workingHours": 10,
  "zone": "Andheri West",
  "latitude": 19.1364,
  "longitude": 72.8296
}
```

### Get User by ID
```
GET /api/users/{id}
```

### Get User by Firebase UID
```
GET /api/users/firebase/{firebaseUid}
```

### Get Risk Assessment
```
GET /api/users/{id}/risk-assessment
```
**Response:**
```json
{
  "riskScore": 0.65,
  "weeklyPremium": 35.00,
  "coverageAmount": 1200.00,
  "riskLevel": "medium",
  "riskFactors": ["High-risk city: Mumbai (factor: 0.80)"]
}
```

---

## 🛡️ Policy APIs

### Create Weekly Policy
```
POST /api/policies
```
```json
{
  "userId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "premium": 35.00,
  "coverageLimit": 1200.00,
  "riskScore": 0.65
}
```

### Get User Policies
```
GET /api/policies/user/{userId}
```

### Get Active Policies
```
GET /api/policies/active
```

---

## 📋 Claim APIs

### Get User Claims
```
GET /api/claims/user/{userId}
```

### Approve Claim
```
POST /api/claims/{id}/approve
```

### Process Payout
```
POST /api/claims/{id}/payout
```

### Get Fraud-Flagged Claims
```
GET /api/claims/fraud
```

---

## ⚡ Disruption APIs

### Trigger Disruption (Manual)
```
POST /api/disruptions/trigger
```
```json
{
  "type": "rainfall",
  "location": "Andheri West",
  "city": "Mumbai",
  "severity": "high",
  "description": "Heavy rainfall causing waterlogging",
  "parameterValue": 85.0,
  "parameterUnit": "mm",
  "latitude": 19.1364,
  "longitude": 72.8296,
  "radiusKm": 8.0,
  "startedAt": "2026-03-10T14:00:00+05:30"
}
```

### Get Active Disruptions
```
GET /api/disruptions/active
```

---

## 💰 Payment APIs

### Get User Transactions
```
GET /api/payments/user/{userId}
```

---

## 📊 Admin APIs

### Dashboard Stats
```
GET /api/admin/dashboard/stats
```
**Response:**
```json
{
  "totalWorkers": 8,
  "activeWorkers": 8,
  "activePolicies": 5,
  "totalClaims": 4,
  "pendingClaims": 0,
  "fraudFlagged": 1,
  "totalPremiumCollected": 57.00,
  "totalPayouts": 1056.00,
  "activeDisruptions": 2
}
```

---

## 🤖 AI Service APIs

### Risk Assessment
```
POST http://localhost:8000/api/risk/assess
```
```json
{
  "city": "Mumbai",
  "zone": "Andheri West",
  "avg_daily_income": 800,
  "working_hours": 10
}
```

### Fraud Check
```
POST http://localhost:8000/api/fraud/check
```
```json
{
  "user_id": "user-uuid",
  "disruption_type": "rainfall",
  "user_lat": 19.1364,
  "user_lon": 72.8296,
  "disruption_lat": 19.1400,
  "disruption_lon": 72.8300
}
```

### Weather Check
```
POST http://localhost:8000/api/weather/check
```
```json
{
  "city": "Mumbai"
}
```
