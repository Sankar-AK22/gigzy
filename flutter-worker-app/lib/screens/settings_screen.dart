import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Local states for toggles
  bool _bioLock = false; // 2. Biometric Lock
  bool _pushNotifications = true; // 3. Notifications
  bool _smsNotifications = false; // 3. Notifications
  bool _locationTracking = true; // 6. Privacy
  bool _platformZomato = true; // 7. Connected Platforms
  String _selectedLanguage = 'English'; // 4. Language Selector
  bool _isDarkThemeOverride = true; // 1. Theme Override

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final subtitleColor = isDark ? Colors.white54 : Colors.grey.shade600;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final bgColors = isDark
        ? const [Color(0xFF0A0E21), Color(0xFF1A1A2E)]
        : const [Color(0xFFF5F6FA), Color(0xFFEEEFF5)];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: textColor), onPressed: () => Navigator.pop(context)),
        title: Text('Settings & Profile', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: bgColors, begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.primaryColor.withAlpha(50))),
              child: Row(
                children: [
                  CircleAvatar(radius: 30, backgroundColor: AppTheme.primaryColor, child: Text(user?.name.substring(0, 1) ?? 'U', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.name ?? 'Worker Name', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(user?.phone ?? '+91 XXXXXXXXXX', style: TextStyle(color: subtitleColor, fontSize: 14)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            _sectionTitle('Preferences', textColor),
            // 1. Theme Override
            _switchTile('Dark Mode Override', 'Force dark theme on', _isDarkThemeOverride, (v) => setState(() => _isDarkThemeOverride = v), textColor, subtitleColor, cardColor),
            // 4. Language Selector
            _actionTile('App Language', _selectedLanguage, Icons.language, () => _showLanguagePicker(context), textColor, subtitleColor, cardColor),
            const SizedBox(height: 24),

            _sectionTitle('Security & Privacy', textColor),
            // 2. Biometric Lock
            _switchTile('Face ID / Fingerprint', 'Require biometric to open app', _bioLock, (v) => setState(() => _bioLock = v), textColor, subtitleColor, cardColor),
            // 6. Privacy Settings
            _switchTile('Background Location', 'Allow AI to track disruption zones', _locationTracking, (v) => setState(() => _locationTracking = v), textColor, subtitleColor, cardColor),
            const SizedBox(height: 24),

            _sectionTitle('Notifications', textColor),
            // 3. Notification Preferences
            _switchTile('Push Notifications', 'Alerts on phone', _pushNotifications, (v) => setState(() => _pushNotifications = v), textColor, subtitleColor, cardColor),
            _switchTile('SMS Alerts', 'Critical alerts via SMS', _smsNotifications, (v) => setState(() => _smsNotifications = v), textColor, subtitleColor, cardColor),
            const SizedBox(height: 24),

            _sectionTitle('Integrations', textColor),
            // 7. Connected Platforms
            _switchTile('Zomato Partner Sync', 'Sync daily income automatically', _platformZomato, (v) => setState(() => _platformZomato = v), textColor, subtitleColor, cardColor),
            const SizedBox(height: 24),

            _sectionTitle('Support', textColor),
            // 8. Emergency Contacts
            _actionTile('Emergency Contacts', 'Manage SOS numbers', Icons.contact_emergency, () => _showSnackbar(context, "Opening contacts list"), textColor, subtitleColor, cardColor),
            // 9. Map Pin Updater
            _actionTile('Home Location', '${user?.city ?? "Set Address"}', Icons.location_on, () => _showSnackbar(context, "Opening map pin setter"), textColor, subtitleColor, cardColor),
            const SizedBox(height: 24),

            // 5. Delete Account & Log Out
            ElevatedButton(
              onPressed: () async {
                await AuthService().signOut();
                if (context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.darkCard, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white24))),
              child: const Text('Log Out', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => _showSnackbar(context, "Starting account deletion flow..."),
              child: const Text('Delete Account', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
            ),
            const SizedBox(height: 40),

            // 10. App Version
            Center(
              child: Column(
                children: [
                  Text('GigShield Worker v2.1.0', style: TextStyle(color: subtitleColor, fontSize: 12)),
                  TextButton(onPressed: () => _showSnackbar(context, "App is up to date"), child: Text('Check for updates', style: TextStyle(color: AppTheme.primaryColor, fontSize: 12))),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(title, style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  Widget _switchTile(String title, String subtitle, bool value, Function(bool) onChanged, Color textColor, Color subtitleColor, Color cardColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        title: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: TextStyle(color: subtitleColor, fontSize: 12)),
        value: value,
        activeColor: AppTheme.secondaryColor,
        onChanged: onChanged,
      ),
    );
  }

  Widget _actionTile(String title, String trailing, IconData icon, VoidCallback onTap, Color textColor, Color subtitleColor, Color cardColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(trailing, style: TextStyle(color: subtitleColor, fontSize: 13)),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Hindi', 'Tamil', 'Telugu'].map((lang) => ListTile(
            title: Text(lang, style: const TextStyle(color: Colors.white)),
            trailing: _selectedLanguage == lang ? const Icon(Icons.check, color: AppTheme.secondaryColor) : null,
            onTap: () {
              setState(() => _selectedLanguage = lang);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }
}
