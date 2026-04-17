import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
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
            children: [
              const _DashboardTab(),
              const PolicyScreen(),
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
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: isDark ? Colors.white54 : Colors.grey,
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

class _DashboardTab extends StatefulWidget {
  const _DashboardTab();

  @override
  State<_DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<_DashboardTab> with SingleTickerProviderStateMixin {
  bool _isRefreshing = false;
  late AnimationController _animController;
  late Animation<double> _balanceAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _balanceAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutQuart));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      _animController.reset();
      _animController.forward();
      setState(() => _isRefreshing = false);
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning 🌅';
    if (hour < 17) return 'Good Afternoon ☀️';
    return 'Good Evening 🌙';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.currentUser;
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
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.primaryColor,
          backgroundColor: cardColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 8. Dynamic Greeting
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_getGreeting(), style: TextStyle(color: subtitleColor, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(user?.name ?? 'Worker', style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
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

                // 1. Dynamic Weather Widget
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryColor.withAlpha(50)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.cloud_queue, color: AppTheme.primaryColor, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${user?.city ?? 'Mumbai'}, ${user?.zone ?? 'Zone'}', style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                            Text('28°C • Light Rain expected in 2 hours', style: TextStyle(color: subtitleColor, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Active Coverage & 2. Animated Balance Counter
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
                      AnimatedBuilder(
                        animation: _balanceAnim,
                        builder: (context, child) {
                          final val = (user?.preferredCoverage ?? 1200) * _balanceAnim.value;
                          return Text('₹${val.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold));
                        },
                      ),
                      const Text('Coverage Limit', style: TextStyle(color: Colors.white60, fontSize: 12)),
                      const SizedBox(height: 16),
                      Row(children: [
                        _infoChip('Premium', '₹35/week'),
                        const SizedBox(width: 12),
                        _infoChip('Risk Score', '${user?.riskScore ?? 0.65}'),
                        const SizedBox(width: 12),
                        _infoChip('Expires', '5 days'),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Quick Action Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _quickActionItem(Icons.qr_code_scanner, 'Scan QR', cardColor, textColor),
                    _quickActionItem(Icons.support_agent, 'Support', cardColor, textColor),
                    _quickActionItem(Icons.sos, 'SOS Alert', AppTheme.accentColor.withAlpha(25), AppTheme.accentColor),
                    _quickActionItem(Icons.account_balance, 'Bank', cardColor, textColor),
                  ],
                ),
                const SizedBox(height: 24),

                // 9. Smart Action Suggestion
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.warningColor.withAlpha(100)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.tips_and_updates, color: AppTheme.warningColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Smart Action', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                            Text('Monsoon is approaching. Consider upgrading your coverage.', style: TextStyle(color: subtitleColor, fontSize: 12)),
                          ],
                        ),
                      ),
                      TextButton(onPressed: (){}, child: const Text('Upgrade'))
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 6. Streak Counter & 7. Gamification Progress
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 24)),
                          const SizedBox(height: 8),
                          Text('14 Days', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                          Text('Streak', style: TextStyle(color: subtitleColor, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Level 3 Driver', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                                const Text('850 XP', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: 0.85,
                                backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                                valueColor: const AlwaysStoppedAnimation(AppTheme.primaryColor),
                                minHeight: 8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('150 XP to next level', style: TextStyle(color: subtitleColor, fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 5. Live Earnings Sparkline (Mockup)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Weekly Earnings Trend', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 60,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [0.4, 0.6, 0.5, 0.8, 0.7, 0.9, 1.0].map((val) {
                            return Container(
                              width: 12,
                              height: 60 * val,
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryColor.withAlpha((val * 255).toInt()),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 4. Personalized Tips Carousel
                Text('Safety & Tips', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _tipCard('Hydration Alert', 'Drink water every hour during your shift.', Icons.water_drop, Colors.blue, cardColor, textColor),
                      _tipCard('Traffic Warning', 'Heavy traffic reported on MG Road.', Icons.traffic, Colors.orange, cardColor, textColor),
                      _tipCard('New Policy', 'Check out our new comprehensive health covers.', Icons.shield, AppTheme.primaryColor, cardColor, textColor),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Active Alerts
                Text('Active Alerts', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                _alertCard('🌡️', 'Heatwave Advisory', '${user?.city ?? 'Delhi'} — Temperature: 44.5°C', 'critical', textColor),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _quickActionItem(IconData icon, String label, Color bgColor, Color iconColor) {
    return Column(
      children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _tipCard(String title, String desc, IconData icon, Color iconColor, Color cardColor, Color textColor) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: TextStyle(color: textColor.withAlpha(150), fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
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
}
