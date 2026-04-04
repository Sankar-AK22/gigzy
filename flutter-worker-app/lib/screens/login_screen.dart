import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../providers/app_provider.dart';
import 'package:local_auth/local_auth.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;
  bool _isLoading = false;
  String? _verificationId;
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    // Optional initially check if biometrics are enrolled, could be used for UI hints
  }

  Future<void> _biometricLogin() async {
    setState(() => _isLoading = true);
    try {
      final bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        throw Exception('Biometric authentication is not available on this device.');
      }

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Scan your face or fingerprint to log in to GigShield',
      );

      if (didAuthenticate) {
        // Log them in natively (Mocking Firebase UUID for demo)
        await _authSuccess('firebase_uid_001'); // In real app, store securely
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Authentication failed: $e')));
      }
    }
  }

  Future<void> _authSuccess(String firebaseUid) async {
    final apiService = context.read<ApiService>();
    final appProvider = context.read<AppProvider>();
    final existingUser = await apiService.getUserByFirebaseUid(firebaseUid);

    if (mounted) {
      if (existingUser != null) {
        appProvider.setCurrentUser(existingUser);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OnboardingScreen(
              firebaseUid: firebaseUid,
              phone: '+91${_phoneController.text}',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0E21), Color(0xFF1A1A2E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Header
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.shield_rounded, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to\nGigShield',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Parametric insurance for gig workers.\nProtect your income from disruptions.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48),

                // Phone Input
                if (!_otpSent) ...[
                  const Text('Phone Number', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      prefixText: '+91 ',
                      prefixStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 18),
                      hintText: '9876543210',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                    ),
                  ),
                ] else ...[
                  const Text('Enter OTP', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 8),
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    decoration: InputDecoration(
                      hintText: '• • • • • •',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => setState(() {
                      _otpSent = false;
                      _otpController.clear();
                    }),
                    child: const Text('Change number', style: TextStyle(color: AppTheme.secondaryColor)),
                  ),
                ],

                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : (_otpSent ? _verifyOtp : _sendOtp),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24, height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            _otpSent ? 'Verify OTP' : 'Send OTP',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Demo Login Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _demoLogin,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.secondaryColor.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'Demo Login (Hackathon)',
                      style: TextStyle(color: AppTheme.secondaryColor, fontSize: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Face / Biometric Scan Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _biometricLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.face_retouching_natural, color: Colors.white, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Face Login / Biometric',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendOtp() async {
    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final authService = context.read<AuthService>();
      _verificationId = await authService.sendOtp('+91${_phoneController.text}');
      setState(() {
        _otpSent = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _verifyOtp() async {
    setState(() => _isLoading = true);
    try {
      final authService = context.read<AuthService>();
      final apiService = context.read<ApiService>();
      final appProvider = context.read<AppProvider>();

      final firebaseUid = await authService.verifyOtp(
        _verificationId ?? '',
        _otpController.text,
      );

      // Check if user exists
      await _authSuccess(firebaseUid);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: $e')),
        );
      }
    }
  }

  Future<void> _demoLogin() async {
    setState(() => _isLoading = true);
    try {
      final authService = context.read<AuthService>();
      await authService.demoLogin();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
