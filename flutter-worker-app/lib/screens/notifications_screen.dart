import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final subtitleColor = isDark ? Colors.white54 : Colors.grey.shade600;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;

    final items = [
      {'title': 'Heatwave Alert', 'msg': 'Extreme heat detected in your area. Stay safe!', 'type': 'disruption', 'time': '2h ago', 'read': false},
      {'title': 'Payout Received', 'msg': '₹400 credited for rainfall disruption claim.', 'type': 'payout', 'time': '1d ago', 'read': false},
      {'title': 'Claim Auto-Triggered', 'msg': 'Heavy rainfall detected. Claim of ₹400 initiated.', 'type': 'claim', 'time': '1d ago', 'read': true},
      {'title': 'Policy Activated', 'msg': 'Weekly policy active. Coverage: ₹1200', 'type': 'policy', 'time': '5d ago', 'read': true},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      ),
      body: Container(
        color: isDark ? AppTheme.darkBg : AppTheme.lightBg,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (ctx, i) {
            final n = items[i];
            final isUnread = n['read'] == false;
            IconData icon;
            Color color;
            switch (n['type']) {
              case 'disruption': icon = Icons.warning_amber_rounded; color = AppTheme.accentColor; break;
              case 'payout': icon = Icons.account_balance_wallet; color = AppTheme.secondaryColor; break;
              case 'claim': icon = Icons.receipt_long; color = AppTheme.warningColor; break;
              default: icon = Icons.shield; color = AppTheme.primaryColor;
            }
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUnread ? color.withAlpha(20) : cardColor,
                borderRadius: BorderRadius.circular(14),
                border: isUnread ? Border.all(color: color.withAlpha(77)) : null,
              ),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: color.withAlpha(38), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(n['title'] as String, style: TextStyle(color: textColor, fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400)),
                  const SizedBox(height: 2),
                  Text(n['msg'] as String, style: TextStyle(color: subtitleColor, fontSize: 12)),
                ])),
                Text(n['time'] as String, style: TextStyle(color: subtitleColor, fontSize: 11)),
              ]),
            );
          },
        ),
      ),
    );
  }
}
