import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../services/firestore_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final subtitleColor = isDark ? Colors.white54 : Colors.grey.shade600;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final bgColors = isDark
        ? const [Color(0xFF0A0E21), Color(0xFF1A1A2E)]
        : const [Color(0xFFF5F6FA), Color(0xFFEEEFF5)];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bgColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
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
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Settings List ──
              Expanded(
                child: Consumer<AppProvider>(
                  builder: (context, provider, _) {
                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        const SizedBox(height: 8),

                        // ─── Appearance ───
                        _sectionTitle('Appearance', textColor),
                        const SizedBox(height: 8),
                        _settingsCard(
                          cardColor: cardColor,
                          children: [
                            _switchTile(
                              icon: Icons.dark_mode_rounded,
                              iconColor: const Color(0xFF6C63FF),
                              title: 'Dark Mode',
                              subtitle: provider.isDarkMode ? 'Dark theme active' : 'Light theme active',
                              value: provider.isDarkMode,
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                              onChanged: (_) => provider.toggleTheme(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ─── Notifications ───
                        _sectionTitle('Notifications', textColor),
                        const SizedBox(height: 8),
                        _settingsCard(
                          cardColor: cardColor,
                          children: [
                            _switchTile(
                              icon: Icons.notifications_rounded,
                              iconColor: AppTheme.secondaryColor,
                              title: 'Push Notifications',
                              subtitle: 'Enable or disable all notifications',
                              value: provider.notificationsEnabled,
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                              onChanged: (v) => provider.setNotificationsEnabled(v),
                            ),
                            _divider(isDark),
                            _switchTile(
                              icon: Icons.cloud_rounded,
                              iconColor: const Color(0xFF4ECDC4),
                              title: 'Weather Alerts',
                              subtitle: 'Heatwave, rainfall, flood warnings',
                              value: provider.weatherAlerts,
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                              enabled: provider.notificationsEnabled,
                              onChanged: (v) => provider.setWeatherAlerts(v),
                            ),
                            _divider(isDark),
                            _switchTile(
                              icon: Icons.receipt_long_rounded,
                              iconColor: AppTheme.warningColor,
                              title: 'Claim Updates',
                              subtitle: 'Auto-trigger and payout alerts',
                              value: provider.claimUpdates,
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                              enabled: provider.notificationsEnabled,
                              onChanged: (v) => provider.setClaimUpdates(v),
                            ),
                            _divider(isDark),
                            _switchTile(
                              icon: Icons.shield_rounded,
                              iconColor: AppTheme.primaryColor,
                              title: 'Policy Reminders',
                              subtitle: 'Renewal and expiry reminders',
                              value: provider.policyReminders,
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                              enabled: provider.notificationsEnabled,
                              onChanged: (v) => provider.setPolicyReminders(v),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ─── Data & Privacy ───
                        _sectionTitle('Data & Privacy', textColor),
                        const SizedBox(height: 8),
                        _settingsCard(
                          cardColor: cardColor,
                          children: [
                            _actionTile(
                              icon: Icons.add_to_drive,
                              iconColor: AppTheme.secondaryColor,
                              title: 'Seed Test Data',
                              subtitle: 'Generate dummy workers & claims in Firebase',
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Seeding data...')));
                                FirestoreService().seedTestData().then((_) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test data seeded successfully! ✅'), backgroundColor: Colors.green));
                                  }
                                });
                              },
                            ),
                            _divider(isDark),
                            _actionTile(
                              icon: Icons.delete_sweep_rounded,
                              iconColor: AppTheme.accentColor,
                              title: 'Clear App Data',
                              subtitle: 'Reset preferences and cached data',
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                              onTap: () => _showClearDataDialog(context, provider),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ─── Account ───
                        _sectionTitle('Account', textColor),
                        const SizedBox(height: 8),
                        _settingsCard(
                          cardColor: cardColor,
                          children: [
                            _actionTile(
                              icon: Icons.logout_rounded,
                              iconColor: AppTheme.accentColor,
                              title: 'Logout',
                              subtitle: 'Sign out of your account',
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                              onTap: () => _showLogoutDialog(context, provider),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ─── About ───
                        _sectionTitle('About', textColor),
                        const SizedBox(height: 8),
                        _settingsCard(
                          cardColor: cardColor,
                          children: [
                            _infoTile(
                              icon: Icons.info_outline_rounded,
                              iconColor: AppTheme.primaryColor,
                              title: 'App Version',
                              trailing: '1.0.0',
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                            ),
                            _divider(isDark),
                            _infoTile(
                              icon: Icons.code_rounded,
                              iconColor: AppTheme.secondaryColor,
                              title: 'Built with',
                              trailing: 'Flutter + Firebase',
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                            ),
                            _divider(isDark),
                            _infoTile(
                              icon: Icons.shield_outlined,
                              iconColor: AppTheme.warningColor,
                              title: 'Platform',
                              trailing: 'GigShield',
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // ── Footer ──
                        Center(
                          child: Text(
                            'Made with ❤️ for Gig Workers',
                            style: TextStyle(color: subtitleColor, fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Widgets ────────────────────────────────────────

  Widget _sectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: textColor.withAlpha(120),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _settingsCard({
    required Color cardColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required Color textColor,
    required Color subtitleColor,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: subtitleColor, fontSize: 11)),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeColor: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color textColor,
    required Color subtitleColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: subtitleColor, fontSize: 11)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: subtitleColor, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String trailing,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title, style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          Text(trailing, style: TextStyle(color: subtitleColor, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      indent: 56,
      color: isDark ? Colors.white10 : Colors.grey.shade200,
    );
  }

  // ── Dialogs ────────────────────────────────────────

  void _showClearDataDialog(BuildContext context, AppProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Clear App Data?',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'This will reset all preferences and cached data. Your account will not be deleted.',
          style: TextStyle(
            color: isDark ? Colors.white60 : Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: isDark ? Colors.white54 : Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await provider.clearAppData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 20),
                        SizedBox(width: 10),
                        Text('App data cleared'),
                      ],
                    ),
                    backgroundColor: AppTheme.secondaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Logout?',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyle(
            color: isDark ? Colors.white60 : Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: isDark ? Colors.white54 : Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await provider.clearAll();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
