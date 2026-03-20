import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import 'policy_screen.dart';
import 'claims_screen.dart';
import 'payouts_screen.dart';
import 'notifications_screen.dart';
import 'add_worker_screen.dart';
import 'settings_screen.dart';
import 'chatbot_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: IndexedStack(
            index: provider.currentNavIndex,
            children: const [
              _DashboardTab(),
              PolicyScreen(),
              ClaimsScreen(),
              PayoutsScreen(),
            ],
          ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withAlpha(100),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddWorkerScreen()),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(Icons.person_add, color: Colors.white, size: 26),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: provider.currentNavIndex,
            onTap: (index) => provider.setNavIndex(index),
            backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.lightCard,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.shield_rounded), label: 'Policy'),
              BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Claims'),
              BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Payouts'),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final subtitleColor = isDark ? Colors.white60 : Colors.grey.shade600;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final bgColors = isDark
        ? const [Color(0xFF0A0E21), Color(0xFF1A1A2E)]
        : const [Color(0xFFF5F6FA), Color(0xFFEEEFF5)];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: bgColors, begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good Morning 👋', style: TextStyle(color: subtitleColor, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('Rahul Kumar', style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      _headerIcon(context, Icons.chat_bubble_outline, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatbotScreen())), cardColor, textColor),
                      const SizedBox(width: 8),
                      _headerIcon(context, Icons.settings_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())), cardColor, textColor),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
                          child: Stack(
                            children: [
                              Icon(Icons.notifications_outlined, color: textColor),
                              Positioned(right: 0, top: 0, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Active Coverage Card (gradient — always looks good)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: AppTheme.primaryColor.withAlpha(77), blurRadius: 20, offset: const Offset(0, 10))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Active Coverage', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white.withAlpha(51), borderRadius: BorderRadius.circular(20)),
                          child: const Text('● Active', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('₹1,200', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                    const Text('Coverage Limit', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    const SizedBox(height: 16),
                    Row(children: [
                      _infoChip('Premium', '₹35/week'),
                      const SizedBox(width: 12),
                      _infoChip('Risk Score', '0.65'),
                      const SizedBox(width: 12),
                      _infoChip('Expires', '5 days'),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quick Stats
              Row(children: [
                Expanded(child: _statCard('Total Payouts', '₹1,056', Icons.arrow_downward, AppTheme.secondaryColor, cardColor, textColor, subtitleColor)),
                const SizedBox(width: 12),
                Expanded(child: _statCard('Claims', '3', Icons.receipt_long, AppTheme.warningColor, cardColor, textColor, subtitleColor)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _statCard('Weeks Insured', '8', Icons.calendar_month, AppTheme.primaryColor, cardColor, textColor, subtitleColor)),
                const SizedBox(width: 12),
                Expanded(child: _statCard('Risk Level', 'Medium', Icons.speed, Colors.orange, cardColor, textColor, subtitleColor)),
              ]),
              const SizedBox(height: 24),

              // Active Alerts
              Text('Active Alerts', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _alertCard('🌡️', 'Heatwave Advisory', 'Delhi — Temperature: 44.5°C', 'critical', textColor),
              const SizedBox(height: 8),
              _alertCard('😷', 'Air Quality Warning', 'Hyderabad — AQI: 380', 'high', textColor),
              const SizedBox(height: 24),

              // Recent Claims
              Text('Recent Claims', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _claimCard('🌧️', 'Heavy Rainfall', '₹400', 'Paid', Colors.green, cardColor, textColor, subtitleColor),
              const SizedBox(height: 8),
              _claimCard('🌊', 'Flood Alert', '₹656', 'Paid', Colors.green, cardColor, textColor, subtitleColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerIcon(BuildContext context, IconData icon, VoidCallback onTap, Color cardColor, Color iconColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: iconColor),
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withAlpha(38), borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
      ]),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color, Color cardColor, Color textColor, Color subtitleColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withAlpha(51))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 12),
        Text(value, style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: subtitleColor, fontSize: 12)),
      ]),
    );
  }

  Widget _alertCard(String emoji, String title, String subtitle, String severity, Color textColor) {
    final color = severity == 'critical' ? AppTheme.accentColor : AppTheme.warningColor;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withAlpha(77))),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
          Text(subtitle, style: TextStyle(color: textColor.withAlpha(153), fontSize: 12)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: color.withAlpha(51), borderRadius: BorderRadius.circular(8)),
          child: Text(severity.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }

  Widget _claimCard(String emoji, String title, String amount, String status, Color statusColor, Color cardColor, Color textColor, Color subtitleColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
          Text('Auto-triggered', style: TextStyle(color: subtitleColor, fontSize: 12)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(amount, style: const TextStyle(color: AppTheme.secondaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
          Text(status, style: TextStyle(color: statusColor, fontSize: 12)),
        ]),
      ]),
    );
  }
}
