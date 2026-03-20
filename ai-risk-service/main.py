"""
GigShield AI Risk Service
FastAPI microservice for risk scoring, premium calculation, and fraud detection.
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List
import uvicorn

from risk_model import RiskModel
from premium_calculator import PremiumCalculator
from fraud_detector import FraudDetector
from weather_service import WeatherService

app = FastAPI(
    title="GigShield AI Risk Service",
    description="AI-powered risk assessment, premium calculation, and fraud detection for gig worker insurance",
    version="1.0.0"
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize services
risk_model = RiskModel()
premium_calculator = PremiumCalculator()
fraud_detector = FraudDetector()
weather_service = WeatherService()


# =============================================
# Request/Response Models
# =============================================

class RiskAssessmentRequest(BaseModel):
    city: str
    zone: str
    avg_daily_income: float
    working_hours: int
    latitude: Optional[float] = None
    longitude: Optional[float] = None


class RiskAssessmentResponse(BaseModel):
    risk_score: float
    weekly_premium: float
    coverage_amount: float
    risk_level: str
    risk_factors: List[str]


class FraudCheckRequest(BaseModel):
    user_id: str
    disruption_type: str
    user_lat: float
    user_lon: float
    disruption_lat: float
    disruption_lon: float
    claim_amount: Optional[float] = 0
    claim_history_count: Optional[int] = 0


class FraudCheckResponse(BaseModel):
    is_fraudulent: bool
    fraud_score: float
    reason: str
    flags: List[str]


class WeatherDataRequest(BaseModel):
    city: str
    latitude: Optional[float] = None
    longitude: Optional[float] = None


class WeatherDataResponse(BaseModel):
    temperature: float
    rainfall: float
    humidity: float
    wind_speed: float
    aqi: int
    description: str
    is_disruption: bool
    disruption_type: Optional[str] = None
    severity: Optional[str] = None


class PremiumCalcRequest(BaseModel):
    risk_score: float
    avg_daily_income: float
    working_hours: int
    city: str
    coverage_multiplier: Optional[float] = 1.0


class PremiumCalcResponse(BaseModel):
    weekly_premium: float
    coverage_amount: float
    breakdown: dict


# =============================================
# API Endpoints
# =============================================

@app.get("/")
async def root():
    return {
        "service": "GigShield AI Risk Service",
        "version": "1.0.0",
        "status": "running",
        "endpoints": [
            "/api/risk/assess",
            "/api/fraud/check",
            "/api/weather/check",
            "/api/premium/calculate",
            "/health"
        ]
    }


@app.get("/health")
async def health_check():
    return {"status": "healthy", "model_loaded": risk_model.is_loaded}


@app.post("/api/risk/assess", response_model=RiskAssessmentResponse)
async def assess_risk(request: RiskAssessmentRequest):
    """
    Assess risk for a gig worker based on location, income, and environmental data.
    Returns risk score, weekly premium, and coverage amount.
    """
    try:
        # Get weather data for the city
        weather_data = weather_service.get_weather_data(
            request.city,
            request.latitude,
            request.longitude
        )

        # Calculate risk score
        risk_result = risk_model.predict_risk(
            city=request.city,
            zone=request.zone,
            rainfall=weather_data["rainfall"],
            temperature=weather_data["temperature"],
            aqi=weather_data["aqi"],
            historical_disruptions=weather_data.get("historical_disruptions", 3)
        )

        # Calculate premium
        premium_result = premium_calculator.calculate(
            risk_score=risk_result["risk_score"],
            avg_daily_income=request.avg_daily_income,
            working_hours=request.working_hours,
            city=request.city
        )

        return RiskAssessmentResponse(
            risk_score=round(risk_result["risk_score"], 2),
            weekly_premium=round(premium_result["weekly_premium"], 2),
            coverage_amount=round(premium_result["coverage_amount"], 2),
            risk_level=risk_result["risk_level"],
            risk_factors=risk_result["risk_factors"]
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/api/fraud/check", response_model=FraudCheckResponse)
async def check_fraud(request: FraudCheckRequest):
    """
    Check if a claim is potentially fraudulent using anomaly detection.
    """
    try:
        result = fraud_detector.check(
            user_id=request.user_id,
            disruption_type=request.disruption_type,
            user_lat=request.user_lat,
            user_lon=request.user_lon,
            disruption_lat=request.disruption_lat,
            disruption_lon=request.disruption_lon,
            claim_amount=request.claim_amount,
            claim_history_count=request.claim_history_count
        )

        return FraudCheckResponse(
            is_fraudulent=result["is_fraudulent"],
            fraud_score=round(result["fraud_score"], 2),
            reason=result["reason"],
            flags=result["flags"]
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/api/weather/check", response_model=WeatherDataResponse)
async def check_weather(request: WeatherDataRequest):
    """
    Get current weather and pollution data for a location.
    Also determines if conditions qualify as a disruption trigger.
    """
    try:
        data = weather_service.get_weather_data(
            request.city,
            request.latitude,
            request.longitude
        )

        is_disruption, d_type, severity = weather_service.check_disruption_trigger(data)

        return WeatherDataResponse(
            temperature=data["temperature"],
            rainfall=data["rainfall"],
            humidity=data["humidity"],
            wind_speed=data["wind_speed"],
            aqi=data["aqi"],
            description=data["description"],
            is_disruption=is_disruption,
            disruption_type=d_type,
            severity=severity
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/api/premium/calculate", response_model=PremiumCalcResponse)
async def calculate_premium(request: PremiumCalcRequest):
    """
    Calculate weekly premium for a given risk profile.
    """
    try:
        result = premium_calculator.calculate(
            risk_score=request.risk_score,
            avg_daily_income=request.avg_daily_income,
            working_hours=request.working_hours,
            city=request.city,
            coverage_multiplier=request.coverage_multiplier
        )

        return PremiumCalcResponse(
            weekly_premium=round(result["weekly_premium"], 2),
            coverage_amount=round(result["coverage_amount"], 2),
            breakdown=result["breakdown"]
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
