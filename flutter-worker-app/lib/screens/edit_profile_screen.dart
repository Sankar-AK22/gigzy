import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../services/firestore_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();
  bool _isLoading = false;

  late TextEditingController _nameController;
  late TextEditingController _zoneController;
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppProvider>().currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _zoneController = TextEditingController(text: user?.zone ?? '');
    _cityController = TextEditingController(text: user?.city ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final subtitleColor = isDark ? Colors.white70 : Colors.grey.shade600;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
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
              // ── App Bar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
                        child: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Edit Profile',
                      style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Update your information', style: TextStyle(color: subtitleColor, fontSize: 14)),
                        const SizedBox(height: 24),
                        
                        _buildInputField(
                          controller: _nameController,
                          label: 'Full Name',
                          textColor: textColor,
                          subtitleColor: subtitleColor,
                          cardColor: cardColor,
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: _cityController,
                          label: 'City',
                          textColor: textColor,
                          subtitleColor: subtitleColor,
                          cardColor: cardColor,
                          icon: Icons.location_city,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: _zoneController,
                          label: 'Delivery Zone',
                          textColor: textColor,
                          subtitleColor: subtitleColor,
                          cardColor: cardColor,
                          icon: Icons.map,
                        ),
                        
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required Color textColor,
    required Color subtitleColor,
    required Color cardColor,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: subtitleColor, fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppTheme.primaryColor),
            filled: true,
            fillColor: cardColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          validator: (value) => value!.isEmpty ? 'Required field' : null,
        )
      ],
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final user = context.read<AppProvider>().currentUser;
      if (user != null) {
        await _firestoreService.updateWorker(user.id, {
          'name': _nameController.text.trim(),
          'city': _cityController.text.trim(),
          'zone': _zoneController.text.trim(),
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated! Changes should sync instantly.'), backgroundColor: Colors.green),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.accentColor),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _zoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}
