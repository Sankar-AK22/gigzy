class ClaimModel {
  final String id;
  final String userId;
  final String policyId;
  final String disruptionType;
  final double lostHours;
  final double hourlyRate;
  final double payoutAmount;
  final String claimStatus;
  final double fraudScore;
  final String? fraudReason;
  final bool autoTriggered;
  final String? createdAt;

  ClaimModel({
    required this.id,
    required this.userId,
    required this.policyId,
    required this.disruptionType,
    required this.lostHours,
    required this.hourlyRate,
    required this.payoutAmount,
    required this.claimStatus,
    this.fraudScore = 0.0,
    this.fraudReason,
    this.autoTriggered = true,
    this.createdAt,
  });

  factory ClaimModel.fromJson(Map<String, dynamic> json) {
    return ClaimModel(
      id: json['id'] ?? '',
      userId: json['user']?['id'] ?? json['userId'] ?? '',
      policyId: json['policy']?['id'] ?? json['policyId'] ?? '',
      disruptionType: json['disruptionType'] ?? '',
      lostHours: (json['lostHours'] ?? 0).toDouble(),
      hourlyRate: (json['hourlyRate'] ?? 0).toDouble(),
      payoutAmount: (json['payoutAmount'] ?? 0).toDouble(),
      claimStatus: json['claimStatus'] ?? 'pending',
      fraudScore: (json['fraudScore'] ?? 0).toDouble(),
      fraudReason: json['fraudReason'],
      autoTriggered: json['autoTriggered'] ?? true,
      createdAt: json['createdAt'],
    );
  }

  String get statusDisplay {
    switch (claimStatus) {
      case 'pending': return 'Pending';
      case 'approved': return 'Approved';
      case 'paid': return 'Paid';
      case 'rejected': return 'Rejected';
      case 'fraud_flagged': return 'Under Review';
      default: return claimStatus;
    }
  }

  String get disruptionIcon {
    switch (disruptionType) {
      case 'rainfall': return '🌧️';
      case 'heatwave': return '🌡️';
      case 'pollution': return '😷';
      case 'flood': return '🌊';
      case 'curfew': return '🚫';
      case 'storm': return '⛈️';
      default: return '⚠️';
    }
  }
}

class TransactionModel {
  final String id;
  final String? claimId;
  final String userId;
  final String type;
  final double amount;
  final String paymentStatus;
  final String? razorpayOrderId;
  final String? createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.paymentStatus,
    this.claimId,
    this.razorpayOrderId,
    this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      claimId: json['claim']?['id'] ?? json['claimId'],
      userId: json['user']?['id'] ?? json['userId'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? 'pending',
      razorpayOrderId: json['razorpayOrderId'],
      createdAt: json['createdAt'],
    );
  }

  String get typeDisplay {
    switch (type) {
      case 'premium_payment': return 'Premium Paid';
      case 'claim_payout': return 'Claim Payout';
      case 'refund': return 'Refund';
      default: return type;
    }
  }

  bool get isIncoming => type == 'claim_payout' || type == 'refund';
}
