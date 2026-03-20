"""
Risk Scoring Model using Scikit-learn
Predicts risk score for gig workers based on environmental and location data.
"""

import numpy as np
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.preprocessing import StandardScaler
import pickle
import os


class RiskModel:
    def __init__(self):
        self.model = None
        self.scaler = StandardScaler()
        self.is_loaded = False
        self._train_model()

    def _train_model(self):
        """
        Train a risk scoring model using synthetic data.
        In production, this would use historical disruption and claim data.
        """
        np.random.seed(42)
        n_samples = 1000

        # Synthetic training features:
        # [rainfall_mm, temperature_c, aqi, historical_disruptions, city_risk_factor]
        rainfall = np.random.exponential(20, n_samples)
        temperature = np.random.normal(35, 8, n_samples)
        aqi = np.random.exponential(150, n_samples)
        hist_disruptions = np.random.poisson(3, n_samples)
        city_risk = np.random.uniform(0.2, 0.9, n_samples)

        X = np.column_stack([rainfall, temperature, aqi, hist_disruptions, city_risk])

        # Generate risk scores (0-1) based on features
        # Higher rainfall, temperature, AQI, disruptions → higher risk
        risk_scores = (
            0.25 * np.clip(rainfall / 100, 0, 1) +
            0.20 * np.clip((temperature - 30) / 20, 0, 1) +
            0.20 * np.clip(aqi / 500, 0, 1) +
            0.15 * np.clip(hist_disruptions / 10, 0, 1) +
            0.20 * city_risk
        )
        risk_scores = np.clip(risk_scores + np.random.normal(0, 0.05, n_samples), 0, 1)

        # Scale features and train
        X_scaled = self.scaler.fit_transform(X)
        self.model = GradientBoostingRegressor(
            n_estimators=100,
            max_depth=4,
            learning_rate=0.1,
            random_state=42
        )
        self.model.fit(X_scaled, risk_scores)
        self.is_loaded = True

    def predict_risk(self, city: str, zone: str, rainfall: float,
                     temperature: float, aqi: int, historical_disruptions: int) -> dict:
        """
        Predict risk score for given environmental conditions.
        """
        # City risk factor lookup (based on historical data)
        city_risk_factors = {
            "Mumbai": 0.8,
            "Delhi": 0.75,
            "Chennai": 0.7,
            "Bangalore": 0.45,
            "Kolkata": 0.65,
            "Hyderabad": 0.5,
            "Pune": 0.4,
            "Ahmedabad": 0.55,
            "Jaipur": 0.5,
            "Lucknow": 0.6,
        }
        city_risk = city_risk_factors.get(city, 0.5)

        # Prepare features
        features = np.array([[rainfall, temperature, aqi, historical_disruptions, city_risk]])
        features_scaled = self.scaler.transform(features)

        # Predict
        risk_score = float(self.model.predict(features_scaled)[0])
        risk_score = max(0, min(1, risk_score))  # Clamp to [0, 1]

        # Determine risk level
        if risk_score >= 0.7:
            risk_level = "high"
        elif risk_score >= 0.4:
            risk_level = "medium"
        else:
            risk_level = "low"

        # Identify risk factors
        risk_factors = []
        if rainfall > 60:
            risk_factors.append(f"Heavy rainfall: {rainfall:.0f}mm (threshold: 60mm)")
        if temperature > 42:
            risk_factors.append(f"Extreme heat: {temperature:.1f}°C (threshold: 42°C)")
        if aqi > 350:
            risk_factors.append(f"Severe pollution: AQI {aqi} (threshold: 350)")
        if historical_disruptions > 5:
            risk_factors.append(f"High disruption history: {historical_disruptions} events")
        if city_risk > 0.6:
            risk_factors.append(f"High-risk city: {city} (factor: {city_risk:.2f})")

        if not risk_factors:
            risk_factors.append("No significant risk factors detected")

        return {
            "risk_score": risk_score,
            "risk_level": risk_level,
            "risk_factors": risk_factors
        }
