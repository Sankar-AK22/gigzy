/// Firebase Authentication Service
/// Handles phone number authentication for gig workers.

class AuthService {
  String? _currentUserId;
  String? _currentFirebaseUid;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get currentUserId => _currentUserId;
  String? get currentFirebaseUid => _currentFirebaseUid;

  /// Send OTP to phone number
  /// In production, use Firebase Auth verifyPhoneNumber
  Future<String> sendOtp(String phoneNumber) async {
    // Firebase Phone Auth would go here:
    // await FirebaseAuth.instance.verifyPhoneNumber(
    //   phoneNumber: phoneNumber,
    //   verificationCompleted: (credential) {},
    //   verificationFailed: (e) {},
    //   codeSent: (verificationId, resendToken) {},
    //   codeAutoRetrievalTimeout: (verificationId) {},
    // );

    // For hackathon demo, simulate OTP
    await Future.delayed(const Duration(seconds: 2));
    return 'demo_verification_id';
  }

  /// Verify OTP and sign in
  Future<String> verifyOtp(String verificationId, String otp) async {
    // Firebase Phone Auth would verify here:
    // PhoneAuthCredential credential = PhoneAuthProvider.credential(
    //   verificationId: verificationId,
    //   smsCode: otp,
    // );
    // UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);
    // return result.user!.uid;

    // For hackathon demo
    await Future.delayed(const Duration(seconds: 1));
    _currentFirebaseUid = 'firebase_uid_demo_${DateTime.now().millisecondsSinceEpoch}';
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
    // await FirebaseAuth.instance.signOut();
    _currentUserId = null;
    _currentFirebaseUid = null;
    _isAuthenticated = false;
  }
}
