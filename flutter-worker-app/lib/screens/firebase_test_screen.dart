import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  String _status = 'Not tested yet';
  bool _isLoading = false;

  void addTestData() async {
    setState(() {
      _isLoading = true;
      _status = 'Sending data...';
    });

    try {
      await FirebaseFirestore.instance.collection("test").add({
        "name": "Eren",
        "message": "Firebase Connected",
        "time": DateTime.now(),
      });

      setState(() {
        _status = '✅ Data sent successfully! Check Firebase Console.';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0E21), Color(0xFF1A1A2E), Color(0xFF16213E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.cloud_done_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Firebase Connection Test',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Press the button to send test data to Firestore',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Status card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white54,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_isLoading)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        else
                          Text(
                            _status,
                            style: TextStyle(
                              fontSize: 16,
                              color: _status.contains('✅')
                                  ? Colors.greenAccent
                                  : _status.contains('❌')
                                      ? Colors.redAccent
                                      : Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Test Firebase button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => addTestData(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                      ),
                      child: const Text(
                        'Test Firebase',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Continue to app button
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      'Skip → Continue to App',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
