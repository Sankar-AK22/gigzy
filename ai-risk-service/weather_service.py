"""
Weather Service
Fetches weather and pollution data from OpenWeatherMap API.
Falls back to mock data when API key is not configured.
"""

import os
import requests
import random


class WeatherService:
    def __init__(self):
        self.api_key = os.getenv("OPENWEATHERMAP_API_KEY", "demo_key")
        self.base_url = "https://api.openweathermap.org/data/2.5"

    # City coordinates for fallback
    CITY_COORDS = {
        "Mumbai": (19.0760, 72.8777),
        "Delhi": (28.7041, 77.1025),
        "Bangalore": (12.9716, 77.5946),
        "Chennai": (13.0827, 80.2707),
        "Kolkata": (22.5726, 88.3639),
        "Hyderabad": (17.3850, 78.4867),
        "Pune": (18.5204, 73.8567),
        "Ahmedabad": (23.0225, 72.5714),
        "Jaipur": (26.9124, 75.7873),
        "Lucknow": (26.8467, 80.9462),
    }

    # Disruption trigger thresholds
    RAINFALL_THRESHOLD = 60.0       # mm
    TEMPERATURE_THRESHOLD = 42.0    # °C
    AQI_THRESHOLD = 350
    WIND_THRESHOLD = 50.0           # km/h

    def get_weather_data(self, city: str, latitude: float = None, longitude: float = None) -> dict:
        """
        Get current weather data for a city.
        Tries OpenWeatherMap API first, falls back to realistic mock data.
        """
        if self.api_key and self.api_key != "demo_key":
            try:
                return self._fetch_real_weather(city, latitude, longitude)
            except Exception as e:
                print(f"Weather API error: {e}. Using mock data.")

        return self._generate_mock_weather(city)

    def _fetch_real_weather(self, city: str, latitude: float = None, longitude: float = None) -> dict:
        """Fetch real weather data from OpenWeatherMap."""
        if latitude and longitude:
            weather_url = f"{self.base_url}/weather?lat={latitude}&lon={longitude}&appid={self.api_key}&units=metric"
        else:
            weather_url = f"{self.base_url}/weather?q={city},IN&appid={self.api_key}&units=metric"

        response = requests.get(weather_url, timeout=10)
        response.raise_for_status()
        data = response.json()

        # Get AQI
        lat = data["coord"]["lat"]
        lon = data["coord"]["lon"]
        aqi = self._fetch_aqi(lat, lon)

        rainfall = data.get("rain", {}).get("1h", 0) or data.get("rain", {}).get("3h", 0)

        return {
            "temperature": data["main"]["temp"],
            "rainfall": rainfall,
            "humidity": data["main"]["humidity"],
            "wind_speed": data["wind"]["speed"] * 3.6,  # m/s to km/h
            "aqi": aqi,
            "description": data["weather"][0]["description"],
            "historical_disruptions": 3  # Default
        }

    def _fetch_aqi(self, lat: float, lon: float) -> int:
        """Fetch AQI data from OpenWeatherMap Air Pollution API."""
        try:
            url = f"{self.base_url}/air_pollution?lat={lat}&lon={lon}&appid={self.api_key}"
            response = requests.get(url, timeout=10)
            response.raise_for_status()
            data = response.json()
            # Convert 1-5 scale to AQI-like number
            aqi_index = data["list"][0]["main"]["aqi"]
            aqi_map = {1: 50, 2: 100, 3: 200, 4: 300, 5: 450}
            return aqi_map.get(aqi_index, 150)
        except Exception:
            return random.randint(80, 300)

    def _generate_mock_weather(self, city: str) -> dict:
        """Generate realistic mock weather data for Indian cities."""
        # City-specific weather patterns
        city_patterns = {
            "Mumbai": {"temp": (28, 36), "rain": (0, 120), "aqi": (80, 250), "humidity": (65, 95)},
            "Delhi": {"temp": (20, 47), "rain": (0, 60), "aqi": (150, 500), "humidity": (30, 70)},
            "Chennai": {"temp": (28, 42), "rain": (0, 90), "aqi": (60, 200), "humidity": (60, 90)},
            "Bangalore": {"temp": (22, 35), "rain": (0, 50), "aqi": (50, 180), "humidity": (40, 75)},
            "Kolkata": {"temp": (25, 40), "rain": (0, 100), "aqi": (100, 350), "humidity": (55, 90)},
            "Hyderabad": {"temp": (25, 42), "rain": (0, 70), "aqi": (70, 250), "humidity": (40, 80)},
            "Pune": {"temp": (22, 38), "rain": (0, 80), "aqi": (60, 200), "humidity": (35, 75)},
        }

        pattern = city_patterns.get(city, {"temp": (25, 40), "rain": (0, 70), "aqi": (80, 300), "humidity": (40, 80)})

        temperature = round(random.uniform(*pattern["temp"]), 1)
        rainfall = round(random.uniform(*pattern["rain"]), 1)
        aqi = random.randint(*pattern["aqi"])
        humidity = random.randint(*pattern["humidity"])
        wind_speed = round(random.uniform(5, 45), 1)

        # Generate description
        if rainfall > 60:
            desc = "heavy intensity rain"
        elif rainfall > 20:
            desc = "moderate rain"
        elif temperature > 42:
            desc = "extreme heat advisory"
        elif aqi > 350:
            desc = "severe air pollution"
        else:
            desc = "partly cloudy"

        return {
            "temperature": temperature,
            "rainfall": rainfall,
            "humidity": humidity,
            "wind_speed": wind_speed,
            "aqi": aqi,
            "description": desc,
            "historical_disruptions": random.randint(1, 8)
        }

    def check_disruption_trigger(self, weather_data: dict) -> tuple:
        """
        Check if weather data triggers a disruption.
        Returns (is_disruption, disruption_type, severity)
        """
        if weather_data["rainfall"] > self.RAINFALL_THRESHOLD * 1.5:
            return True, "flood", "critical"
        elif weather_data["rainfall"] > self.RAINFALL_THRESHOLD:
            return True, "rainfall", "high"
        elif weather_data["temperature"] > self.TEMPERATURE_THRESHOLD + 3:
            return True, "heatwave", "critical"
        elif weather_data["temperature"] > self.TEMPERATURE_THRESHOLD:
            return True, "heatwave", "high"
        elif weather_data["aqi"] > self.AQI_THRESHOLD + 100:
            return True, "pollution", "critical"
        elif weather_data["aqi"] > self.AQI_THRESHOLD:
            return True, "pollution", "high"
        elif weather_data["wind_speed"] > self.WIND_THRESHOLD:
            return True, "storm", "high"

        return False, None, None
