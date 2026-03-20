import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/firestore_service.dart';
import '../models/worker_model.dart';

class AddWorkerScreen extends StatefulWidget {
  const AddWorkerScreen({super.key});

  @override
  State<AddWorkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends State<AddWorkerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _zoneController = TextEditingController();
  final _incomeController = TextEditingController();
  final _hoursController = TextEditingController(text: '8');
  final _coverageController = TextEditingController(text: '1200');

  String _selectedCity = 'Mumbai';
  String _selectedPlatform = 'Swiggy';
  String _selectedVehicle = 'Bike';

  final List<String> _cities = [
    'Mumbai', 'Delhi', 'Bangalore', 'Chennai', 'Kolkata',
    'Hyderabad', 'Pune', 'Ahmedabad', 'Jaipur', 'Lucknow',
  ];

  final List<Map<String, dynamic>> _platforms = [
    {'name': 'Swiggy', 'icon': '🍔', 'color': const Color(0xFFFC8019)},
    {'name': 'Zomato', 'icon': '🍕', 'color': const Color(0xFFE23744)},
    {'name': 'Blinkit', 'icon': '🛒', 'color': const Color(0xFFF7CD1F)},
    {'name': 'Amazon', 'icon': '📦', 'color': const Color(0xFFFF9900)},
    {'name': 'Dunzo', 'icon': '🏃', 'color': const Color(0xFF00C853)},
    {'name': 'Zepto', 'icon': '⚡', 'color': const Color(0xFF7B1FA2)},
  ];

  final List<Map<String, dynamic>> _vehicles = [
    {'name': 'Bike', 'icon': Icons.two_wheeler, 'label': 'Motorbike'},
    {'name': 'Bicycle', 'icon': Icons.pedal_bike, 'label': 'Bicycle'},
    {'name': 'Scooter', 'icon': Icons.electric_scooter, 'label': 'Scooter'},
    {'name': 'Car', 'icon': Icons.directions_car, 'label': 'Car'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final subtitleColor = isDark ? Colors.white70 : Colors.grey.shade600;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade300;
    final bgColors = isDark
        ? const [Color(0xFF0A0E21), Color(0xFF1A1A2E)]
        : const [Color(0xFFF5F6FA), Color(0xFFEEEFF5)];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: bgColors, begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
                      child: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Text('Register Worker', style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold))),
                ]),
              ),
              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader('Personal Information', Icons.person_outline, textColor),
                        const SizedBox(height: 16),
                        _buildTextInput(controller: _nameController, label: 'Full Name', hint: 'Enter full name', icon: Icons.person, textColor: textColor, subtitleColor: subtitleColor, cardColor: cardColor, borderColor: borderColor, validator: (v) => v == null || v.isEmpty ? 'Name is required' : null),
                        const SizedBox(height: 14),
                        _buildTextInput(controller: _phoneController, label: 'Phone Number', hint: '9876543210', icon: Icons.phone, prefix: '+91 ', keyboardType: TextInputType.phone, textColor: textColor, subtitleColor: subtitleColor, cardColor: cardColor, borderColor: borderColor, validator: (v) => v == null || v.length < 10 ? 'Valid phone required' : null),
                        const SizedBox(height: 14),
                        _buildTextInput(controller: _emailController, label: 'Email (Optional)', hint: 'worker@email.com', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, textColor: textColor, subtitleColor: subtitleColor, cardColor: cardColor, borderColor: borderColor),
                        const SizedBox(height: 14),
                        _buildTextInput(controller: _dobController, label: 'Date of Birth (Optional)', hint: 'DD/MM/YYYY', icon: Icons.cake_outlined, keyboardType: TextInputType.datetime, textColor: textColor, subtitleColor: subtitleColor, cardColor: cardColor, borderColor: borderColor),
                        const SizedBox(height: 28),

                        _sectionHeader('Work Profile', Icons.work_outline, textColor),
                        const SizedBox(height: 16),
                        _buildLabel('Delivery Platform', subtitleColor),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: _platforms.map((p) {
                            final isSelected = _selectedPlatform == p['name'];
                            final Color chipColor = p['color'] as Color;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedPlatform = p['name']),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? chipColor.withAlpha(51) : cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: isSelected ? chipColor : borderColor, width: isSelected ? 2 : 1),
                                ),
                                child: Row(mainAxisSize: MainAxisSize.min, children: [
                                  Text(p['icon'] as String, style: const TextStyle(fontSize: 16)),
                                  const SizedBox(width: 6),
                                  Text(p['name'] as String, style: TextStyle(color: isSelected ? textColor : subtitleColor, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, fontSize: 13)),
                                ]),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 18),
                        _buildLabel('City', subtitleColor),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCity, isExpanded: true,
                              dropdownColor: cardColor,
                              style: TextStyle(color: textColor),
                              icon: Icon(Icons.keyboard_arrow_down, color: subtitleColor),
                              items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                              onChanged: (v) => setState(() => _selectedCity = v!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildTextInput(controller: _zoneController, label: 'Delivery Zone', hint: 'e.g., Andheri West, Koramangala', icon: Icons.location_on_outlined, textColor: textColor, subtitleColor: subtitleColor, cardColor: cardColor, borderColor: borderColor, validator: (v) => v == null || v.isEmpty ? 'Zone is required' : null),
                        const SizedBox(height: 18),
                        _buildLabel('Vehicle Type', subtitleColor),
                        const SizedBox(height: 8),
                        Row(
                          children: _vehicles.map((v) {
                            final isSelected = _selectedVehicle == v['name'];
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedVehicle = v['name']),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppTheme.primaryColor.withAlpha(40) : cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: isSelected ? AppTheme.primaryColor : borderColor, width: isSelected ? 2 : 1),
                                  ),
                                  child: Column(children: [
                                    Icon(v['icon'] as IconData, color: isSelected ? AppTheme.primaryColor : subtitleColor, size: 24),
                                    const SizedBox(height: 4),
                                    Text(v['label'] as String, style: TextStyle(color: isSelected ? textColor : subtitleColor, fontSize: 11, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
                                  ]),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 18),
                        Row(children: [
                          Expanded(child: _buildTextInput(controller: _incomeController, label: 'Daily Income (₹)', hint: '800', icon: Icons.currency_rupee, iconColor: AppTheme.secondaryColor, keyboardType: TextInputType.number, textColor: textColor, subtitleColor: subtitleColor, cardColor: cardColor, borderColor: borderColor, validator: (v) => v == null || v.isEmpty ? 'Required' : null)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildTextInput(controller: _hoursController, label: 'Hours/Day', hint: '8', icon: Icons.access_time, iconColor: AppTheme.secondaryColor, keyboardType: TextInputType.number, textColor: textColor, subtitleColor: subtitleColor, cardColor: cardColor, borderColor: borderColor, validator: (v) => v == null || v.isEmpty ? 'Required' : null)),
                        ]),
                        const SizedBox(height: 28),

                        _sectionHeader('Insurance Preferences', Icons.shield_outlined, textColor),
                        const SizedBox(height: 16),
                        _buildTextInput(controller: _coverageController, label: 'Preferred Coverage (₹)', hint: '1200', icon: Icons.account_balance_wallet_outlined, iconColor: AppTheme.warningColor, keyboardType: TextInputType.number, textColor: textColor, subtitleColor: subtitleColor, cardColor: cardColor, borderColor: borderColor),
                        const SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity, height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 8, shadowColor: AppTheme.primaryColor.withAlpha(100)),
                            child: _isLoading
                                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.person_add, size: 20), SizedBox(width: 10), Text('Register Worker', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5))]),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon, Color textColor) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppTheme.primaryColor.withAlpha(30), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppTheme.primaryColor, size: 20),
      ),
      const SizedBox(width: 12),
      Text(title, style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
    ]);
  }

  Widget _buildLabel(String text, Color color) {
    return Text(text, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500));
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color textColor,
    required Color subtitleColor,
    required Color cardColor,
    required Color borderColor,
    Color? iconColor,
    String? prefix,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, subtitleColor),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: textColor, fontSize: 15),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: subtitleColor.withAlpha(120)),
            prefixText: prefix,
            prefixStyle: TextStyle(color: subtitleColor, fontSize: 15),
            prefixIcon: Icon(icon, color: iconColor ?? AppTheme.primaryColor, size: 20),
            filled: true,
            fillColor: cardColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.accentColor)),
          ),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final worker = WorkerModel(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        dateOfBirth: _dobController.text.trim().isEmpty ? null : _dobController.text.trim(),
        platform: _selectedPlatform,
        city: _selectedCity,
        zone: _zoneController.text.trim(),
        avgDailyIncome: double.tryParse(_incomeController.text) ?? 0,
        workingHours: int.tryParse(_hoursController.text) ?? 8,
        vehicleType: _selectedVehicle,
        preferredCoverage: double.tryParse(_coverageController.text) ?? 1200,
      );
      await _firestoreService.addWorker(worker.toFirestore());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Row(children: [Icon(Icons.check_circle, color: Colors.white, size: 20), SizedBox(width: 10), Text('Worker registered successfully!')]),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ));
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppTheme.accentColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _zoneController.dispose();
    _incomeController.dispose();
    _hoursController.dispose();
    _coverageController.dispose();
    super.dispose();
  }
}
