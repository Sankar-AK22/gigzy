# 🔑 Environment Variables Setup

## Spring Boot Backend

| Variable | Description | Example |
|----------|-------------|---------|
| `SPRING_DATASOURCE_URL` | PostgreSQL connection URL | `jdbc:postgresql://localhost:5432/gigshield` |
| `SPRING_DATASOURCE_USERNAME` | Database username | `gigshield_user` |
| `SPRING_DATASOURCE_PASSWORD` | Database password | `gigshield_pass_2026` |
| `AI_SERVICE_URL` | Python AI service URL | `http://localhost:8000` |
| `OPENWEATHERMAP_API_KEY` | OpenWeatherMap API key | `your_api_key` |
| `RAZORPAY_KEY_ID` | Razorpay sandbox key ID | `rzp_test_xxx` |
| `RAZORPAY_KEY_SECRET` | Razorpay sandbox secret | `your_secret` |
| `FIREBASE_PROJECT_ID` | Firebase project ID | `gigshield-demo` |

## Python AI Service

| Variable | Description | Example |
|----------|-------------|---------|
| `OPENWEATHERMAP_API_KEY` | OpenWeatherMap API key | `your_api_key` |
| `DATABASE_URL` | PostgreSQL URL (optional) | `postgresql://user:pass@host:5432/db` |

## React Admin Dashboard

| Variable | Description | Example |
|----------|-------------|---------|
| `REACT_APP_API_URL` | Backend API base URL | `http://localhost:8080/api` |

## Flutter Worker App

Configure in `lib/services/api_service.dart`:
- **Android emulator**: `http://10.0.2.2:8080/api`
- **iOS simulator**: `http://localhost:8080/api`
- **Production**: Your deployed backend URL

## Getting API Keys

### OpenWeatherMap
1. Sign up at [openweathermap.org](https://openweathermap.org)
2. Go to API Keys section
3. Generate a free API key (supports Current Weather + Air Pollution)

### Razorpay Sandbox
1. Sign up at [razorpay.com](https://razorpay.com)
2. Switch to Test Mode
3. Copy Test Key ID and Test Key Secret from Settings → API Keys

### Firebase
1. Create project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable Phone Authentication
3. Add Android app with package name
4. Download `google-services.json` to Flutter app
