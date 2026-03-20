"""
Dynamic Weekly Premium Calculator
Calculates insurance premium based on risk score, income, and city factors.
"""


class PremiumCalculator:
    # City-specific base rate multipliers
    CITY_MULTIPLIERS = {
        "Mumbai": 1.3,
        "Delhi": 1.25,
        "Chennai": 1.2,
        "Kolkata": 1.15,
        "Bangalore": 1.0,
        "Hyderabad": 1.05,
        "Pune": 0.95,
        "Ahmedabad": 1.1,
        "Jaipur": 1.0,
        "Lucknow": 1.1,
    }

    # Base premium rate as percentage of weekly income
    BASE_RATE = 0.005  # 0.5% of weekly income

    # Coverage as multiple of weekly income
    BASE_COVERAGE_MULTIPLIER = 0.15  # 15% of weekly income as base coverage

    def calculate(self, risk_score: float, avg_daily_income: float,
                  working_hours: int, city: str,
                  coverage_multiplier: float = 1.0) -> dict:
        """
        Calculate weekly premium and coverage amount.

        Premium formula:
        weekly_premium = weekly_income * base_rate * risk_factor * city_multiplier

        Coverage formula:
        coverage = weekly_income * coverage_base * (1 + risk_score) * coverage_multiplier
        """
        weekly_income = avg_daily_income * 7
        city_mult = self.CITY_MULTIPLIERS.get(city, 1.0)

        # Risk factor: higher risk = higher premium
        # Scale from 1.0 (low risk) to 3.0 (high risk)
        risk_factor = 1.0 + (risk_score * 2.0)

        # Hours factor: more hours = slightly higher premium (more exposure)
        hours_factor = 1.0 + ((working_hours - 8) * 0.02)  # 2% per extra hour
        hours_factor = max(0.8, min(1.4, hours_factor))

        # Calculate weekly premium
        weekly_premium = weekly_income * self.BASE_RATE * risk_factor * city_mult * hours_factor

        # Ensure minimum and maximum bounds
        weekly_premium = max(10, min(100, weekly_premium))

        # Calculate coverage amount
        coverage_amount = weekly_income * self.BASE_COVERAGE_MULTIPLIER * (1 + risk_score) * coverage_multiplier
        coverage_amount = max(500, min(5000, coverage_amount))

        # Build breakdown
        breakdown = {
            "weekly_income": round(weekly_income, 2),
            "base_rate": self.BASE_RATE,
            "risk_factor": round(risk_factor, 2),
            "city_multiplier": city_mult,
            "hours_factor": round(hours_factor, 2),
            "risk_score": round(risk_score, 2),
            "city": city,
            "formula": "weekly_income × base_rate × risk_factor × city_multiplier × hours_factor"
        }

        return {
            "weekly_premium": weekly_premium,
            "coverage_amount": coverage_amount,
            "breakdown": breakdown
        }
