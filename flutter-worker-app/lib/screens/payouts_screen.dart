import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/claim_model.dart';

class PayoutsScreen extends StatefulWidget {
  const PayoutsScreen({super.key});

  @override
  State<PayoutsScreen> createState() => _PayoutsScreenState();
}

class _PayoutsScreenState extends State<PayoutsScreen> {
  bool _isWeekly = true; // 2. Weekly vs Monthly Toggle
  bool _autoTransfer = true; // 9. Auto-Transfer Toggle

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final subtitleColor = isDark ? Colors.white54 : Colors.grey.shade600;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final bgColors = isDark
        ? const [Color(0xFF0A0E21), Color(0xFF1A1A2E)]
        : const [Color(0xFFF5F6FA), Color(0xFFEEEFF5)];

    final paidClaims = provider.claims.where((c) => c.claimStatus.toLowerCase() == 'paid').toList();
    final totalPayout = paidClaims.fold(0.0, (sum, claim) => sum + claim.payoutAmount);

    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(colors: bgColors, begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Wallet & Payouts', style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
                  // 4. Export Statement
                  IconButton(icon: const Icon(Icons.download_rounded, color: AppTheme.primaryColor), onPressed: () {})
                ],
              ),
              const SizedBox(height: 24),

              // Main Balance Card & 10. Currency Formatted Animations
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.secondaryColor.withAlpha(77)),
                ),
                child: Column(
                  children: [
                    Text('Total Earned via GigShield', style: TextStyle(color: subtitleColor)),
                    const SizedBox(height: 8),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: totalPayout),
                      duration: const Duration(seconds: 2),
                      builder: (context, value, child) {
                        return Text('₹${value.toStringAsFixed(0)}', style: TextStyle(color: AppTheme.secondaryColor, fontSize: 48, fontWeight: FontWeight.bold));
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.secondaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            child: const Text('Withdraw Now'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 1. Manage Payment Methods
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(foregroundColor: textColor, side: BorderSide(color: isDark ? Colors.white30 : Colors.black26), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            child: const Text('Manage UPI'),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Toggles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 2. Weekly vs Monthly Toggle
                  Container(
                    decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        _toggleBtn('Weekly', _isWeekly, () => setState(() => _isWeekly = true), isDark),
                        _toggleBtn('Monthly', !_isWeekly, () => setState(() => _isWeekly = false), isDark),
                      ],
                    ),
                  ),
                  // 9. Auto-Transfer Toggle
                  Row(
                    children: [
                      Text('Auto-Transfer', style: TextStyle(color: subtitleColor, fontSize: 12)),
                      Switch(value: _autoTransfer, onChanged: (v) => setState(() => _autoTransfer = v), activeColor: AppTheme.secondaryColor),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),

              // 3. Detailed Breakdown & 5. Tax Estimation
              Text('Earnings Breakdown', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    _breakdownRow('Base Income (Platform)', '₹14,500', textColor, isDark),
                    _breakdownRow('GigShield Payouts', '+ ₹${totalPayout.toStringAsFixed(0)}', AppTheme.secondaryColor, isDark),
                    _breakdownRow('Estimated TDS (1%)', '- ₹145', AppTheme.warningColor, isDark),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Net Earnings', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('₹${(14500 + totalPayout - 145).toStringAsFixed(0)}', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 6. Next Scheduled Payout
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    const Icon(Icons.event_available, color: Colors.white, size: 32),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Next Payout Scheduled', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        Text('Friday, 24th April', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const Spacer(),
                    const Text('₹1,250', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 7. Historical Payout Bar Chart (Mockup)
              Text('Payout History', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                height: 150,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _barCol('W1', 0.4, AppTheme.primaryColor),
                    _barCol('W2', 0.7, AppTheme.primaryColor),
                    _barCol('W3', 0.5, AppTheme.primaryColor),
                    _barCol('W4', 0.9, AppTheme.secondaryColor), // Current
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 8. Dispute Payout Button
              Center(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.help_outline, color: Colors.grey),
                  label: const Text('Missing a payout? Dispute here', style: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleBtn(String text, bool active, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: active ? AppTheme.primaryColor : Colors.transparent, borderRadius: BorderRadius.circular(8)),
        child: Text(text, style: TextStyle(color: active ? Colors.white : (isDark ? Colors.white54 : Colors.black54), fontWeight: active ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }

  Widget _breakdownRow(String label, String value, Color valueColor, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _barCol(String label, double heightRatio, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(width: 30, height: 80 * heightRatio, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
