import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import '../models/policy_model.dart';
import '../models/claim_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api'; // Android emulator
  // Use 'http://localhost:8080/api' for iOS simulator
  // Use your actual server URL for production

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ==================== USER APIs ====================

  Future<UserModel> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: _headers,
      body: jsonEncode(userData),
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Registration failed: ${response.body}');
  }

  Future<UserModel?> getUserByFirebaseUid(String uid) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/firebase/$uid'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      // User not found
    }
    return null;
  }

  Future<UserModel> getUserById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$id'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('User not found');
  }

  // ==================== RISK ASSESSMENT APIs ====================

  Future<RiskAssessment> getRiskAssessment(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/risk-assessment'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return RiskAssessment.fromJson(jsonDecode(response.body));
    }
    throw Exception('Risk assessment failed');
  }

  // ==================== POLICY APIs ====================

  Future<PolicyModel> createPolicy(Map<String, dynamic> policyData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/policies'),
      headers: _headers,
      body: jsonEncode(policyData),
    );
    if (response.statusCode == 200) {
      return PolicyModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Policy creation failed: ${response.body}');
  }

  Future<List<PolicyModel>> getUserPolicies(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/policies/user/$userId'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => PolicyModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load policies');
  }

  // ==================== CLAIM APIs ====================

  Future<List<ClaimModel>> getUserClaims(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/claims/user/$userId'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ClaimModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load claims');
  }

  // ==================== TRANSACTION APIs ====================

  Future<List<TransactionModel>> getUserTransactions(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/payments/user/$userId'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => TransactionModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load transactions');
  }

  // ==================== NOTIFICATION APIs ====================

  Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notifications/user/$userId'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }
    throw Exception('Failed to load notifications');
  }

  Future<int> getUnreadNotificationCount(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notifications/user/$userId/unread/count'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['count'] ?? 0;
    }
    return 0;
  }
}
