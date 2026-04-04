/// Firebase Authentication Service
/// Handles phone number authentication for gig workers.
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  String? _currentUserId;
  String? _currentFirebaseUid;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get currentUserId => _currentUserId;
  String? get currentFirebaseUid => _currentFirebaseUid;

  /// Send OTP to phone number
  Future<String> sendOtp(String phoneNumber) async {
    Completer<String> completer = Completer<String>();
    
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (!completer.isCompleted) completer.completeError(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        if (!completer.isCompleted) completer.complete(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    return completer.future;
  }

  /// Verify OTP and sign in
  Future<String> verifyOtp(String verificationId, String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);
    
    _currentFirebaseUid = result.user?.uid;
    _isAuthenticated = true;
    return _currentFirebaseUid!;
  }

  /// Set user ID after registration/login
  void setUserId(String userId) {
    _currentUserId = userId;
  }

  /// Demo login (skip OTP for testing)
  Future<String> demoLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    _currentFirebaseUid = 'firebase_uid_001';
    _currentUserId = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';
    _isAuthenticated = true;
    return _currentFirebaseUid!;
  }

  /// Sign out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _currentUserId = null;
    _currentFirebaseUid = null;
    _isAuthenticated = false;
  }
}
