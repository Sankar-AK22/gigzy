class UserModel {
  final String id;
  final String firebaseUid;
  final String name;
  final String phone;
  final String city;
  final String platform;
  final double avgDailyIncome;
  final int workingHours;
  final String zone;
  final double? latitude;
  final double? longitude;
  final double riskScore;
  final bool isActive;

  UserModel({
    required this.id,
    required this.firebaseUid,
    required this.name,
    required this.phone,
    required this.city,
    required this.platform,
    required this.avgDailyIncome,
    required this.workingHours,
    required this.zone,
    this.latitude,
    this.longitude,
    this.riskScore = 0.0,
    this.isActive = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      firebaseUid: json['firebaseUid'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
      platform: json['platform'] ?? '',
      avgDailyIncome: (json['avgDailyIncome'] ?? 0).toDouble(),
      workingHours: json['workingHours'] ?? 8,
      zone: json['zone'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      riskScore: (json['riskScore'] ?? 0).toDouble(),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firebaseUid': firebaseUid,
      'name': name,
      'phone': phone,
      'city': city,
      'platform': platform,
      'avgDailyIncome': avgDailyIncome,
      'workingHours': workingHours,
      'zone': zone,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
