import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilter = 0; // 0: All, 1: Alerts, 2: Payments

  final List<Map<String, dynamic>> _mockNotifications = [
    {
      'id': '1', 'title': 'Heatwave Alert', 'body': 'Temperatures expected to reach 45°C tomorrow. Stay hydrated!', 'type': 'alert', 'time': '10m ago', 'read': false
    },
    {
      'id': '2', 'title': 'Claim Approved', 'body': 'Your recent claim for Rain disruption was approved.', 'type': 'payment', 'time': '2h ago', 'read': false
    },
    {
      'id': '3', 'title': 'Policy Renewed', 'body': 'Your weekly income protection has been successfully renewed.', 'type': 'system', 'time': '1d ago', 'read': true
    },
    {
      'id': '4', 'title': 'Payout Processed', 'body': '₹1,250 has been transferred to your connected bank account.', 'type': 'payment', 'time': '2d ago', 'read': true
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final subtitleColor = isDark ? Colors.white54 : Colors.grey.shade600;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final bgColors = isDark
        ? const [Color(0xFF0A0E21), Color(0xFF1A1A2E)]
        : const [Color(0xFFF5F6FA), Color(0xFFEEEFF5)];

    List<Map<String, dynamic>> filtered = _mockNotifications;
    if (_selectedFilter == 1) filtered = _mockNotifications.where((n) => n['type'] == 'alert').toList();
    if (_selectedFilter == 2) filtered = _mockNotifications.where((n) => n['type'] == 'payment').toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: textColor), onPressed: () => Navigator.pop(context)),
        title: Text('Notifications', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in _mockNotifications) { n['read'] = true; }
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All marked as read')));
            },
            child: const Text('Mark All Read', style: TextStyle(color: AppTheme.secondaryColor)),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: bgColors, begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(
          children: [
            // Category Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  _filterChip('All', 0, isDark),
                  _filterChip('Alerts', 1, isDark),
                  _filterChip('Payments', 2, isDark),
                ],
              ),
            ),

            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_off_outlined, size: 80, color: subtitleColor.withAlpha(100)),
                          const SizedBox(height: 16),
                          Text('No notifications here', style: TextStyle(color: subtitleColor, fontSize: 16)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final notif = filtered[index];
                        final isUnread = !(notif['read'] as bool);
                        Color iconColor = AppTheme.primaryColor;
                        IconData icon = Icons.info;
                        
                        if (notif['type'] == 'alert') { iconColor = AppTheme.warningColor; icon = Icons.warning_amber_rounded; }
                        if (notif['type'] == 'payment') { iconColor = AppTheme.secondaryColor; icon = Icons.account_balance_wallet; }

                        return Dismissible(
                          key: Key(notif['id']),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(16)),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            setState(() => _mockNotifications.removeWhere((n) => n['id'] == notif['id']));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isUnread ? cardColor.withAlpha(200) : cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: isUnread ? AppTheme.primaryColor.withAlpha(100) : Colors.transparent),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(backgroundColor: iconColor.withAlpha(30), child: Icon(icon, color: iconColor, size: 20)),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text(notif['title'], style: TextStyle(color: textColor, fontWeight: isUnread ? FontWeight.bold : FontWeight.w500))),
                                          Text(notif['time'], style: TextStyle(color: subtitleColor, fontSize: 11)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(notif['body'], style: TextStyle(color: subtitleColor, fontSize: 13, height: 1.4)),
                                    ],
                                  ),
                                ),
                                if (isUnread) ...[
                                  const SizedBox(width: 8),
                                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle))
                                ]
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, int index, bool isDark) {
    final isSelected = _selectedFilter == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87))),
        selected: isSelected,
        onSelected: (val) => setState(() => _selectedFilter = index),
        selectedColor: AppTheme.primaryColor,
        backgroundColor: isDark ? AppTheme.darkCard : Colors.grey.shade200,
      ),
    );
  }
}
