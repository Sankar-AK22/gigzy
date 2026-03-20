import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/firestore_service.dart';
import '../models/worker_model.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final subtitleColor = isDark ? Colors.white54 : Colors.grey.shade600;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final dividerColor = isDark ? Colors.white12 : Colors.grey.shade200;
    final bgColors = isDark
        ? const [Color(0xFF0A0E21), Color(0xFF1A1A2E)]
        : const [Color(0xFFF5F6FA), Color(0xFFEEEFF5)];
    
    // Simulating waiting period status for demo purposes based on new Terms & Conditions
    final bool isWaitingPeriod = true;
    final FirestoreService _firestoreService = FirestoreService();

    return StreamBuilder<List<WorkerModel>>(
      stream: _firestoreService.getWorkersStream(),
      builder: (context, snapshot) {
        bool hasActivePolicy = false;
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          hasActivePolicy = snapshot.data!.first.hasActivePolicy;
        }

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
              Text('Insurance Policy', style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Weekly parametric income protection', style: TextStyle(color: subtitleColor)),
              const SizedBox(height: 16),
              
              if (isWaitingPeriod)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.warningColor.withAlpha(77)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: AppTheme.warningColor, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Waiting Period Active', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('You must complete 30 days of continuous work before claims can be approved.', style: TextStyle(color: subtitleColor, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
              const SizedBox(height: 24),

              // Risk Assessment Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primaryColor.withAlpha(77)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.analytics_rounded, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Text('AI Risk Assessment', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.warningColor.withAlpha(51), borderRadius: BorderRadius.circular(8)),
                        child: const Text('MEDIUM', style: TextStyle(color: AppTheme.warningColor, fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _riskMetric('Risk Score', '0.65', AppTheme.warningColor),
                        Container(width: 1, height: 40, color: dividerColor),
                        _riskMetric('Premium', '₹35/wk', AppTheme.primaryColor),
                        Container(width: 1, height: 40, color: dividerColor),
                        _riskMetric('Coverage', '₹1,200', AppTheme.secondaryColor),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(color: dividerColor),
                    const SizedBox(height: 12),
                    Text('Risk Factors', style: TextStyle(color: subtitleColor, fontSize: 13)),
                    const SizedBox(height: 8),
                    _riskFactor('🌧️', 'Monsoon season — high rainfall risk in Mumbai', subtitleColor),
                    _riskFactor('🌡️', 'Historical heatwave frequency: 4 events', subtitleColor),
                    _riskFactor('📍', 'High-risk city factor: 0.80', subtitleColor),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Policy Card (Conditional on hasActivePolicy)
              if (hasActivePolicy)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Active Policy', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        Icon(Icons.verified_rounded, color: Colors.white, size: 24),
                      ]),
                      const SizedBox(height: 16),
                      const Text('Weekly Income Protection', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      _policyDetail('Policy ID', 'GS-POL-2026-0311'),
                      _policyDetail('Start Date', '03 Mar 2026'),
                      _policyDetail('End Date', '10 Mar 2026'),
                      _policyDetail('Premium Paid', '₹35'),
                      _policyDetail('Coverage Limit', '₹1,200'),
                      _policyDetail('Status', 'Active ✅'),
                    ],
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.warningColor.withAlpha(77)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.pending_actions_rounded, color: AppTheme.warningColor, size: 48),
                      const SizedBox(height: 16),
                      Text('No Active Policy', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Your policy is currently pending assignment from the admin dashboard.', 
                        textAlign: TextAlign.center,
                        style: TextStyle(color: subtitleColor, fontSize: 14)
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // What's Covered
              Text("What's Covered", style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _coverageItem('🌧️', 'Heavy Rainfall', 'Rainfall > 60mm in your zone', cardColor, textColor, subtitleColor),
              _coverageItem('🌡️', 'Extreme Heat', 'Temperature > 42°C', cardColor, textColor, subtitleColor),
              _coverageItem('😷', 'Severe Pollution', 'AQI > 350', cardColor, textColor, subtitleColor),
              _coverageItem('🌊', 'Flood Alert', 'Government flood warning', cardColor, textColor, subtitleColor),
              _coverageItem('🚫', 'Curfew/Lockdown', 'Official curfew in your area', cardColor, textColor, subtitleColor),
              const SizedBox(height: 24),

              // Renew
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Processing Policy Renewal...'),
                        duration: Duration(seconds: 1),
                      )
                    );
                    Future.delayed(const Duration(seconds: 1), () {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Policy successfully renewed! ✅'),
                            backgroundColor: Colors.green,
                          )
                        );
                      }
                    });
                  },
                  icon: const Icon(Icons.autorenew_rounded),
                  label: const Text('Renew Policy Now', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor, 
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  });
}

  Widget _riskMetric(String label, String value, Color color) {
    return Column(children: [
      Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
    ]);
  }

  Widget _riskFactor(String emoji, String text, Color subtitleColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(color: subtitleColor, fontSize: 13))),
      ]),
    );
  }

  Widget _policyDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 13)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _coverageItem(String emoji, String title, String desc, Color cardColor, Color textColor, Color subtitleColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
          Text(desc, style: TextStyle(color: subtitleColor, fontSize: 12)),
        ])),
        const Icon(Icons.check_circle, color: AppTheme.secondaryColor, size: 20),
      ]),
    );
  }
}
