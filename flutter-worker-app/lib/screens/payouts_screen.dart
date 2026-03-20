import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PayoutsScreen extends StatelessWidget {
  const PayoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final subtitleColor = isDark ? Colors.white54 : Colors.grey.shade600;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final bgColors = isDark
        ? const [Color(0xFF0A0E21), Color(0xFF1A1A2E)]
        : const [Color(0xFFF5F6FA), Color(0xFFEEEFF5)];

    final txns = [
      {'type': 'claim_payout', 'desc': 'Rainfall Claim', 'amount': '+₹400', 'date': '07 Mar', 'status': 'completed'},
      {'type': 'premium_payment', 'desc': 'Weekly Premium', 'amount': '-₹35', 'date': '03 Mar', 'status': 'completed'},
      {'type': 'claim_payout', 'desc': 'Flood Claim', 'amount': '+₹656', 'date': '07 Mar', 'status': 'completed'},
      {'type': 'premium_payment', 'desc': 'Weekly Premium', 'amount': '-₹22', 'date': '24 Feb', 'status': 'completed'},
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: bgColors, begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Payouts & Transactions', style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            // Balance card (gradient — always looks great)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(20)),
              child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Total Received', style: TextStyle(color: Colors.white70, fontSize: 14)),
                SizedBox(height: 8),
                Text('₹1,056', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Via Razorpay Wallet', style: TextStyle(color: Colors.white60, fontSize: 12)),
              ]),
            ),
            const SizedBox(height: 24),
            Text('Transaction History', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...txns.map((t) => _txnCard(t, cardColor, textColor, subtitleColor)),
          ],
        ),
      ),
    );
  }

  Widget _txnCard(Map<String, String> t, Color cardColor, Color textColor, Color subtitleColor) {
    final isIncoming = t['type'] == 'claim_payout';
    final accentColor = isIncoming ? AppTheme.secondaryColor : AppTheme.warningColor;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: accentColor.withAlpha(38), borderRadius: BorderRadius.circular(10)),
          child: Icon(isIncoming ? Icons.arrow_downward : Icons.arrow_upward, color: accentColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t['desc']!, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
          Text(t['date']!, style: TextStyle(color: subtitleColor, fontSize: 12)),
        ])),
        Text(t['amount']!, style: TextStyle(color: isIncoming ? AppTheme.secondaryColor : subtitleColor, fontWeight: FontWeight.bold, fontSize: 16)),
      ]),
    );
  }
}
