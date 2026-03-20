# 🚀 Deployment Guide

## 1. Database — Railway PostgreSQL

1. Go to [railway.app](https://railway.app) and create a new project
2. Add a PostgreSQL plugin
3. Get the connection URL from Variables tab
4. Run schema:
```bash
psql $RAILWAY_DATABASE_URL -f database/schema.sql
psql $RAILWAY_DATABASE_URL -f database/seed.sql
```

## 2. Spring Boot Backend — Render

1. Push code to GitHub repository
2. Go to [render.com](https://render.com) → New → Web Service
3. Connect your GitHub repo, set:
   - **Root Directory**: `springboot-backend`
   - **Build Command**: `mvn clean package -DskipTests`
   - **Start Command**: `java -jar target/*.jar`
   - **Environment**: Java 17
4. Add environment variables from ENV_SETUP.md
5. Update `DATABASE_URL` to Railway PostgreSQL URL

## 3. AI Service — Render

1. New → Web Service on Render
2. Connect GitHub repo, set:
   - **Root Directory**: `ai-risk-service`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`
   - **Environment**: Python 3.11
3. Add `OPENWEATHERMAP_API_KEY` environment variable

## 4. Admin Dashboard — Vercel

1. Go to [vercel.com](https://vercel.com) → Import Project
2. Select your GitHub repo
3. Set:
   - **Root Directory**: `admin-dashboard`
   - **Framework Preset**: Create React App
4. Add `REACT_APP_API_URL` env var pointing to Render backend URL
5. Deploy

## 5. Flutter App — APK Build

```bash
cd flutter-worker-app
flutter build apk --release
```
APK output: `build/app/outputs/flutter-apk/app-release.apk`

## Docker (Local Development)

```bash
# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f backend

# Stop all
docker-compose down
```
