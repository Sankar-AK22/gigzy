"""
Fraud Detection Module
Uses anomaly detection to identify potentially fraudulent claims.
"""

import math
from typing import List


class FraudDetector:
    # Maximum distance (km) between worker and disruption zone to be valid
    MAX_VALID_DISTANCE_KM = 25.0

    # Suspicious claim thresholds
    MAX_CLAIMS_PER_WEEK = 3
    HIGH_CLAIM_AMOUNT_THRESHOLD = 2000  # INR

    def check(self, user_id: str, disruption_type: str,
              user_lat: float, user_lon: float,
              disruption_lat: float, disruption_lon: float,
              claim_amount: float = 0,
              claim_history_count: int = 0) -> dict:
        """
        Check if a claim is potentially fraudulent.
        Returns fraud score (0-1) and detection flags.
        """
        flags = []
        fraud_score = 0.0

        # Check 1: GPS Distance Verification
        # Verify that the worker is within the disruption zone
        distance = self._haversine_distance(user_lat, user_lon, disruption_lat, disruption_lon)

        if distance > self.MAX_VALID_DISTANCE_KM:
            flags.append(f"GPS_DISTANCE_MISMATCH: Worker is {distance:.1f}km from disruption zone (max: {self.MAX_VALID_DISTANCE_KM}km)")
            fraud_score += 0.4

        # Check 2: GPS Spoofing Detection
        # Check for impossible coordinates (0,0) or exact round numbers
        if self._is_suspicious_coordinates(user_lat, user_lon):
            flags.append("GPS_SPOOFING_SUSPECTED: Coordinates appear to be spoofed or default values")
            fraud_score += 0.3

        # Check 3: Claim Frequency Analysis
        if claim_history_count > self.MAX_CLAIMS_PER_WEEK:
            flags.append(f"HIGH_CLAIM_FREQUENCY: {claim_history_count} claims (threshold: {self.MAX_CLAIMS_PER_WEEK}/week)")
            fraud_score += 0.2

        # Check 4: Unusual Claim Amount
        if claim_amount > self.HIGH_CLAIM_AMOUNT_THRESHOLD:
            flags.append(f"HIGH_CLAIM_AMOUNT: ₹{claim_amount:.0f} (threshold: ₹{self.HIGH_CLAIM_AMOUNT_THRESHOLD})")
            fraud_score += 0.1

        # Check 5: Disruption Type Consistency
        # Some disruption types don't make sense for certain patterns
        if disruption_type == "curfew" and distance > 5:
            flags.append("CURFEW_ZONE_MISMATCH: Worker not in curfew-affected zone")
            fraud_score += 0.15

        # Normalize fraud score to [0, 1]
        fraud_score = min(1.0, fraud_score)

        # Determine if fraudulent
        is_fraudulent = fraud_score >= 0.5

        # Build reason
        if is_fraudulent:
            reason = f"High fraud probability ({fraud_score:.0%}) — " + "; ".join(flags[:2])
        elif fraud_score > 0.2:
            reason = f"Minor anomalies detected ({fraud_score:.0%}) — monitoring"
        else:
            reason = "No fraud indicators detected"

        return {
            "is_fraudulent": is_fraudulent,
            "fraud_score": fraud_score,
            "reason": reason,
            "flags": flags
        }

    @staticmethod
    def _haversine_distance(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
        """
        Calculate the great-circle distance between two points using Haversine formula.
        Returns distance in kilometers.
        """
        R = 6371  # Earth's radius in km

        lat1_r, lon1_r = math.radians(lat1), math.radians(lon1)
        lat2_r, lon2_r = math.radians(lat2), math.radians(lon2)

        dlat = lat2_r - lat1_r
        dlon = lon2_r - lon1_r

        a = math.sin(dlat / 2) ** 2 + math.cos(lat1_r) * math.cos(lat2_r) * math.sin(dlon / 2) ** 2
        c = 2 * math.asin(math.sqrt(a))

        return R * c

    @staticmethod
    def _is_suspicious_coordinates(lat: float, lon: float) -> bool:
        """
        Check if coordinates appear to be spoofed.
        """
        # Check for default/null island coordinates
        if lat == 0 and lon == 0:
            return True

        # Check if coordinates are exact round numbers (suspicious)
        if lat == round(lat) and lon == round(lon):
            return True

        # Check if coordinates are outside India
        if not (6.0 <= lat <= 37.0 and 68.0 <= lon <= 97.5):
            return True

        return False
