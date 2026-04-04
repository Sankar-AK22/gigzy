import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/policy_model.dart';
import '../models/claim_model.dart';
import 'dart:async';
import '../services/firestore_service.dart';
import '../models/worker_model.dart';
class AppProvider extends ChangeNotifier {
  UserModel? _currentUser;
  List<PolicyModel> _policies = [];
  List<ClaimModel> _claims = [];
  List<TransactionModel> _transactions = [];
  RiskAssessment? _riskAssessment;
  bool _isLoading = false;
  int _currentNavIndex = 0;

  StreamSubscription<WorkerModel?>? _workerSub;
  StreamSubscription<List<Map<String, dynamic>>>? _claimsSub;
  // ── Settings State ──
  ThemeMode _themeMode = ThemeMode.dark;
  bool _notificationsEnabled = true;
  bool _weatherAlerts = true;
  bool _claimUpdates = true;
  bool _policyReminders = true;

  // Getters
  UserModel? get currentUser => _currentUser;
  List<PolicyModel> get policies => _policies;
  List<ClaimModel> get claims => _claims;
  List<TransactionModel> get transactions => _transactions;
  RiskAssessment? get riskAssessment => _riskAssessment;
  bool get isLoading => _isLoading;
  int get currentNavIndex => _currentNavIndex;

  // Settings Getters
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get weatherAlerts => _weatherAlerts;
  bool get claimUpdates => _claimUpdates;
  bool get policyReminders => _policyReminders;

  PolicyModel? get activePolicy {
    try {
      return _policies.firstWhere((p) => p.isActive);
    } catch (_) {
      return null;
    }
  }

  double get totalPayouts {
    return _transactions
        .where((t) => t.isIncoming && t.paymentStatus == 'completed')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // ── Init: Load persisted settings ──
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = (prefs.getString('themeMode') ?? 'dark') == 'light'
        ? ThemeMode.light
        : ThemeMode.dark;
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    _weatherAlerts = prefs.getBool('weatherAlerts') ?? true;
    _claimUpdates = prefs.getBool('claimUpdates') ?? true;
    _policyReminders = prefs.getBool('policyReminders') ?? true;
    notifyListeners();
  }

  // ── Theme ──
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', _themeMode == ThemeMode.dark ? 'dark' : 'light');
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode == ThemeMode.dark ? 'dark' : 'light');
  }

  // ── Notifications ──
  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
  }

  Future<void> setWeatherAlerts(bool value) async {
    _weatherAlerts = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('weatherAlerts', value);
  }

  Future<void> setClaimUpdates(bool value) async {
    _claimUpdates = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('claimUpdates', value);
  }

  Future<void> setPolicyReminders(bool value) async {
    _policyReminders = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('policyReminders', value);
  }

  // ── Data Setters ──
  void setCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
    _startRealTimeStreams(user.id);
  }

  void _startRealTimeStreams(String workerDocumentId) {
    _workerSub?.cancel();
    _claimsSub?.cancel();

    final firestoreService = FirestoreService();

    // 1. Listen to Worker Details
    _workerSub = firestoreService.getWorkerStream(workerDocumentId).listen((workerData) {
      if (workerData != null && _currentUser != null) {
        // Map updated worker data into current UserModel
        _currentUser = UserModel(
          id: _currentUser!.id,
          firebaseUid: _currentUser!.firebaseUid,
          name: workerData.name,
          phone: workerData.phone,
          city: workerData.city,
          platform: workerData.platform,
          avgDailyIncome: workerData.avgDailyIncome,
          workingHours: workerData.workingHours,
          zone: workerData.zone,
          latitude: _currentUser!.latitude,
          longitude: _currentUser!.longitude,
          riskScore: workerData.riskScore,
          isActive: workerData.hasActivePolicy,
          preferredCoverage: workerData.preferredCoverage,
        );
        notifyListeners();
      }
    });

    // 2. Listen to Claims
    _claimsSub = firestoreService.getUserClaimsStream(workerDocumentId).listen((claimsList) {
      _claims = claimsList.map((map) => ClaimModel.fromJson(map)).toList();
      notifyListeners();
    });
  }

  void setPolicies(List<PolicyModel> policies) {
    _policies = policies;
    notifyListeners();
  }

  void setClaims(List<ClaimModel> claims) {
    _claims = claims;
    notifyListeners();
  }

  void setTransactions(List<TransactionModel> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  void setRiskAssessment(RiskAssessment assessment) {
    _riskAssessment = assessment;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  // ── Clear All ──
  Future<void> clearAll() async {
    _currentUser = null;
    _policies = [];
    _claims = [];
    _transactions = [];
    _riskAssessment = null;
    _currentNavIndex = 0;
    
    await _workerSub?.cancel();
    await _claimsSub?.cancel();
    _workerSub = null;
    _claimsSub = null;
    
    notifyListeners();
  }

  // ── Clear App Data (settings + cache) ──
  Future<void> clearAppData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _themeMode = ThemeMode.dark;
    _notificationsEnabled = true;
    _weatherAlerts = true;
    _claimUpdates = true;
    _policyReminders = true;
    await clearAll();
  }
}
