# 🛡️ GigShield — AI-Powered Parametric Insurance for Gig Delivery Workers

> Protecting gig workers from income loss caused by weather, pollution, floods, and curfews — automatically.

![Architecture](docs/architecture.png)

## 🎯 Problem Statement

Gig delivery workers (Zomato, Swiggy, Blinkit, Amazon Flex) face **income loss** due to external disruptions like heavy rain, extreme heat, floods, high pollution, or curfews. Traditional insurance doesn't cover this. **GigShield** provides **parametric insurance** that automatically detects disruptions and pays out — no claim forms needed.

## 🏗️ Architecture

```
Flutter Worker App
       ↓
Firebase Authentication
       ↓
Spring Boot Backend API
       ↓
Python FastAPI AI Service
       ↓
External APIs (Weather / Pollution / Traffic)
       ↓
PostgreSQL Database
       ↓
Razorpay Payment Simulation
```

## 📦 Project Structure

```
gigzy/
├── flutter-worker-app/     # Flutter mobile app for gig workers
├── springboot-backend/      # Spring Boot REST API backend
├── ai-risk-service/         # Python FastAPI AI/ML microservice
├── admin-dashboard/         # React.js admin analytics dashboard
├── database/                # PostgreSQL schema & seed data
├── docs/                    # API docs, deployment guide, env setup
├── docker-compose.yml       # Docker orchestration
└── README.md
```

## 🚀 Quick Start

### Prerequisites
- Java 17+, Maven 3.8+
- Python 3.10+, pip
- Flutter 3.16+, Dart
- Node.js 18+, npm
- PostgreSQL 15+
- Firebase project (for auth)

### 1. Database Setup
```bash
# Create PostgreSQL database
createdb gigshield

# Run schema
psql -d gigshield -f database/schema.sql

# Load sample data
psql -d gigshield -f database/seed.sql
```

### 2. Spring Boot Backend
```bash
cd springboot-backend
cp src/main/resources/application-example.yml src/main/resources/application.yml
# Edit application.yml with your DB credentials and API keys
mvn spring-boot:run
# Runs on http://localhost:8080
```

### 3. AI Risk Service
```bash
cd ai-risk-service
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
# Runs on http://localhost:8000
```

### 4. Flutter Worker App
```bash
cd flutter-worker-app
flutter pub get
flutter run
```

### 5. Admin Dashboard
```bash
cd admin-dashboard
npm install
npm start
# Runs on http://localhost:3000
```

## 🌐 Deployment Targets

| Service | Platform | URL |
|---------|----------|-----|
| Flutter App | APK Build | `flutter build apk` |
| Spring Boot API | Render | `https://gigshield-api.onrender.com` |
| AI Service | Render | `https://gigshield-ai.onrender.com` |
| PostgreSQL | Railway | Railway PostgreSQL addon |
| Admin Dashboard | Vercel | `https://gigshield-admin.vercel.app` |

## 🔑 Environment Variables

See [docs/ENV_SETUP.md](docs/ENV_SETUP.md) for complete environment variable reference.

## 📡 API Documentation

See [docs/API.md](docs/API.md) for full REST API documentation.

## 💡 Core Features

- **Worker Registration** — Phone auth via Firebase, profile with city/platform/zone
- **AI Risk Assessment** — ML-based risk scoring + dynamic weekly premium
- **Parametric Triggers** — Auto-detect rain > 60mm, temp > 42°C, AQI > 350
- **Automated Claims** — Zero paperwork, system auto-creates claims
- **Fraud Detection** — GPS spoofing, zone mismatch, duplicate claim detection
- **Instant Payouts** — Razorpay sandbox simulation
- **Admin Analytics** — Risk heatmaps, claim charts, fraud alerts

## 📄 License

MIT License — Built for hackathon demonstration purposes.
