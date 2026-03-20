import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../providers/app_provider.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final String firebaseUid;
  final String phone;

  const OnboardingScreen({
    super.key,
    required this.firebaseUid,
    required this.phone,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();
  final _incomeController = TextEditingController();
  final _hoursController = TextEditingController(text: '8');
  final _zoneController = TextEditingController();

  String _selectedCity = 'Mumbai';
  String _selectedPlatform = 'Swiggy';
  bool _isLoading = false;

  final List<String> _cities = [
    'Mumbai', 'Delhi', 'Bangalore', 'Chennai', 'Kolkata',
    'Hyderabad', 'Pune', 'Ahmedabad', 'Jaipur', 'Lucknow',
  ];

  final List<Map<String, dynamic>> _platforms = [
    {'name': 'Swiggy', 'icon': '🍔', 'color': Color(0xFFFC8019)},
    {'name': 'Zomato', 'icon': '🍕', 'color': Color(0xFFE23744)},
    {'name': 'Blinkit', 'icon': '🛒', 'color': Color(0xFFF7CD1F)},
    {'name': 'Amazon', 'icon': '📦', 'color': Color(0xFFFF9900)},
    {'name': 'Dunzo', 'icon': '🏃', 'color': Color(0xFF00C853)},
    {'name': 'Zepto', 'icon': '⚡', 'color': Color(0xFF7B1FA2)},
  ];

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
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Set Up Your Profile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tell us about your work to get the best coverage',
                  style: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
                const SizedBox(height: 32),

                // Name
                _buildLabel('Full Name'),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Enter your name',
                    prefixIcon: Icon(Icons.person_outline, color: AppTheme.primaryColor),
                  ),
                ),
                const SizedBox(height: 20),

                // Platform Selection
                _buildLabel('Delivery Platform'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _platforms.map((p) {
                    final isSelected = _selectedPlatform == p['name'];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedPlatform = p['name']),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? p['color'].withOpacity(0.2) : AppTheme.darkCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? p['color'] : Colors.white12,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(p['icon'], style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 6),
                            Text(
                              p['name'],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white60,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // City
                _buildLabel('City'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.darkCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCity,
                      isExpanded: true,
                      dropdownColor: AppTheme.darkCard,
                      style: const TextStyle(color: Colors.white),
                      items: _cities.map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      )).toList(),
                      onChanged: (v) => setState(() => _selectedCity = v!),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Zone
                _buildLabel('Delivery Zone'),
                TextField(
                  controller: _zoneController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'e.g., Andheri West, Koramangala',
                    prefixIcon: Icon(Icons.location_on_outlined, color: AppTheme.primaryColor),
                  ),
                ),
                const SizedBox(height: 20),

                // Income & Hours
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Daily Income (₹)'),
                          TextField(
                            controller: _incomeController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: '800',
                              prefixIcon: Icon(Icons.currency_rupee, color: AppTheme.secondaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Working Hours'),
                          TextField(
                            controller: _hoursController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: '8',
                              prefixIcon: Icon(Icons.access_time, color: AppTheme.secondaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Submit
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        : const Text('Complete Setup', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14)),
    );
  }

  Future<void> _register() async {
    if (_nameController.text.isEmpty || _incomeController.text.isEmpty || _zoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final apiService = context.read<ApiService>();
      final authService = context.read<AuthService>();
      final appProvider = context.read<AppProvider>();

      final user = await apiService.registerUser({
        'firebaseUid': widget.firebaseUid,
        'name': _nameController.text,
        'phone': widget.phone,
        'city': _selectedCity,
        'platform': _selectedPlatform,
        'avgDailyIncome': double.parse(_incomeController.text),
        'workingHours': int.parse(_hoursController.text),
        'zone': _zoneController.text,
      });

      appProvider.setCurrentUser(user);
      authService.setUserId(user.id);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _incomeController.dispose();
    _hoursController.dispose();
    _zoneController.dispose();
    super.dispose();
  }
}
