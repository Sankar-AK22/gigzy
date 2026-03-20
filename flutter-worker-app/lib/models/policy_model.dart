class PolicyModel {
  final String id;
  final String userId;
  final double premium;
  final double coverageLimit;
  final String startDate;
  final String endDate;
  final String status;
  final double riskScore;
  final String? createdAt;

  PolicyModel({
    required this.id,
    required this.userId,
    required this.premium,
    required this.coverageLimit,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.riskScore,
    this.createdAt,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      id: json['id'] ?? '',
      userId: json['user']?['id'] ?? json['userId'] ?? '',
      premium: (json['premium'] ?? 0).toDouble(),
      coverageLimit: (json['coverageLimit'] ?? 0).toDouble(),
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      status: json['status'] ?? 'active',
      riskScore: (json['riskScore'] ?? 0).toDouble(),
      createdAt: json['createdAt'],
    );
  }

  bool get isActive => status == 'active';

  int get daysRemaining {
    try {
      final end = DateTime.parse(endDate);
      final now = DateTime.now();
      return end.difference(now).inDays;
    } catch (_) {
      return 0;
    }
  }
}

class RiskAssessment {
  final double riskScore;
  final double weeklyPremium;
  final double coverageAmount;
  final String riskLevel;
  final List<String> riskFactors;

  RiskAssessment({
    required this.riskScore,
    required this.weeklyPremium,
    required this.coverageAmount,
    required this.riskLevel,
    required this.riskFactors,
  });

  factory RiskAssessment.fromJson(Map<String, dynamic> json) {
    return RiskAssessment(
      riskScore: (json['riskScore'] ?? json['risk_score'] ?? 0).toDouble(),
      weeklyPremium: (json['weeklyPremium'] ?? json['weekly_premium'] ?? 0).toDouble(),
      coverageAmount: (json['coverageAmount'] ?? json['coverage_amount'] ?? 0).toDouble(),
      riskLevel: json['riskLevel'] ?? json['risk_level'] ?? 'medium',
      riskFactors: List<String>.from(json['riskFactors'] ?? json['risk_factors'] ?? []),
    );
  }
}
