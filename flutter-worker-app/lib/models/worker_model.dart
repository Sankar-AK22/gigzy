import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerModel {
  final String? id;
  final String name;
  final String phone;
  final String? email;
  final String? dateOfBirth;
  final String platform;
  final String city;
  final String zone;
  final double avgDailyIncome;
  final int workingHours;
  final String vehicleType;
  final double preferredCoverage;
  final bool hasActivePolicy;
  final DateTime registeredAt;

  WorkerModel({
    this.id,
    required this.name,
    required this.phone,
    this.email,
    this.dateOfBirth,
    required this.platform,
    required this.city,
    required this.zone,
    required this.avgDailyIncome,
    required this.workingHours,
    required this.vehicleType,
    required this.preferredCoverage,
    this.hasActivePolicy = false,
    DateTime? registeredAt,
  }) : registeredAt = registeredAt ?? DateTime.now();

  factory WorkerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // Safely parse registeredAt which could be Timestamp or String or null
    DateTime parsedDate = DateTime.now();
    if (data['registeredAt'] is Timestamp) {
      parsedDate = (data['registeredAt'] as Timestamp).toDate();
    } else if (data['registeredAt'] is String) {
      parsedDate = DateTime.tryParse(data['registeredAt']) ?? DateTime.now();
    }
    
    return WorkerModel(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'],
      dateOfBirth: data['dateOfBirth'],
      platform: data['platform'] ?? '',
      city: data['city'] ?? '',
      zone: data['zone'] ?? '',
      avgDailyIncome: (data['avgDailyIncome'] ?? 0).toDouble(),
      workingHours: data['workingHours'] ?? 8,
      vehicleType: data['vehicleType'] ?? '',
      preferredCoverage: (data['preferredCoverage'] ?? 0).toDouble(),
      hasActivePolicy: data['hasActivePolicy'] ?? false,
      registeredAt: parsedDate,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'platform': platform,
      'city': city,
      'zone': zone,
      'avgDailyIncome': avgDailyIncome,
      'workingHours': workingHours,
      'vehicleType': vehicleType,
      'preferredCoverage': preferredCoverage,
      'hasActivePolicy': hasActivePolicy,
      'registeredAt': FieldValue.serverTimestamp(),
    };
  }
}
