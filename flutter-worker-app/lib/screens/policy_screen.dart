import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'dart:math';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _gaugeAnim;
  bool _autoRenew = true;
  double _coverageAmount = 1200;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _gaugeAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutBack));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

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
    
    final provider = context.watch<AppProvider>();
    final user = provider.currentUser;
    bool hasActivePolicy = user?.isActive ?? false;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Insurance Policy', style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Weekly parametric income protection', style: TextStyle(color: subtitleColor)),
                    ],
                  ),
                  // 2. Share Policy Document
                  IconButton(
                    icon: const Icon(Icons.share, color: AppTheme.primaryColor),
                    onPressed: () => _showSnackbar(context, "Sharing policy document..."),
                  )
                ],
              ),
              const SizedBox(height: 24),

              // 1. Animated Risk Gauge
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primaryColor.withAlpha(77)),
                ),
                child: Column(
                  children: [
                    Text('AI Risk Score', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _gaugeAnim,
                      builder: (context, child) {
                        final risk = (user?.riskScore ?? 0.65) * _gaugeAnim.value;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 150, height: 150,
                              child: CircularProgressIndicator(
                                value: risk,
                                strokeWidth: 12,
                                backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation(
                                  risk > 0.75 ? AppTheme.accentColor : risk > 0.4 ? AppTheme.warningColor : Colors.green
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text('${(risk * 100).toInt()}', style: TextStyle(color: textColor, fontSize: 40, fontWeight: FontWeight.bold)),
                                Text('out of 100', style: TextStyle(color: subtitleColor, fontSize: 12)),
                              ],
                            )
                          ],
                        );
                      }
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _riskMetric('Risk Factor', 'Medium', AppTheme.warningColor),
                        Container(width: 1, height: 40, color: dividerColor),
                        _riskMetric('Premium', '₹35/wk', AppTheme.primaryColor),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Policy Card
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
                      _policyDetail('Policy ID', 'GS-POL-${(user?.id ?? "2026").padRight(4, 'X').substring(0, 4)}'),
                      _policyDetail('Start Date', 'Recent'),
                      _policyDetail('End Date', 'Active'),
                      _policyDetail('Premium Paid', '₹35'),
                      _policyDetail('Coverage Limit', '₹${_coverageAmount.toStringAsFixed(0)}'),
                      _policyDetail('Status', 'Active ✅'),
                      const SizedBox(height: 16),
                      // 10. Download PDF Certificate
                      OutlinedButton.icon(
                        onPressed: () => _showSnackbar(context, "Downloading PDF..."),
                        icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                        label: const Text('Download Certificate', style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white54),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      )
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // 6. Coverage Customizer
              Text("Adjust Coverage Limit", style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w600)),
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('₹500', style: TextStyle(color: subtitleColor)),
                        Text('₹${_coverageAmount.toStringAsFixed(0)}', style: TextStyle(color: AppTheme.secondaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('₹2000', style: TextStyle(color: subtitleColor)),
                      ],
                    ),
                    Slider(
                      value: _coverageAmount,
                      min: 500, max: 2000, divisions: 15,
                      activeColor: AppTheme.secondaryColor,
                      onChanged: (val) => setState(() => _coverageAmount = val),
                    ),
                    Text('Estimated Premium: ₹${(_coverageAmount * 0.03).toStringAsFixed(0)}/wk', style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 4. Auto-Renewal Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                child: SwitchListTile(
                  title: Text('Auto-Renew Policy', style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                  subtitle: Text('Automatically deduct premium every week', style: TextStyle(color: subtitleColor, fontSize: 12)),
                  value: _autoRenew,
                  activeColor: AppTheme.secondaryColor,
                  onChanged: (val) => setState(() => _autoRenew = val),
                ),
              ),
              const SizedBox(height: 24),

              // 5. Beneficiary Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Beneficiaries", style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w600)),
                  TextButton.icon(onPressed: (){}, icon: const Icon(Icons.add), label: const Text('Add'))
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: const CircleAvatar(backgroundColor: AppTheme.primaryColor, child: Icon(Icons.person, color: Colors.white)),
                  title: Text('Priya Devi', style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
                  subtitle: Text('Spouse • 100% Share', style: TextStyle(color: subtitleColor)),
                  trailing: const Icon(Icons.edit, color: AppTheme.primaryColor),
                ),
              ),
              const SizedBox(height: 24),

              // 7. "What's Not Covered" Expandable
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text("What's Not Covered (Exclusions)", style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                  collapsedIconColor: AppTheme.primaryColor,
                  iconColor: AppTheme.primaryColor,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text("• Personal vehicle damage\n• Loss of items during transit\n• Non-weather related app outages\n• Illness not caused by weather extremes", style: TextStyle(color: subtitleColor, height: 1.5)),
                    )
                  ],
                ),
              ),
              
              // 8. Compare Plans & 9. Zone Map Mockup & 3. Policy History Timeline
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.map, color: AppTheme.secondaryColor),
                title: Text('View Active Insurance Zones', style: TextStyle(color: textColor)),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () => _showSnackbar(context, "Opening interactive map..."),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history, color: AppTheme.primaryColor),
                title: Text('Policy History Timeline', style: TextStyle(color: textColor)),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () => _showSnackbar(context, "Loading history..."),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.compare_arrows, color: AppTheme.warningColor),
                title: Text('Compare Premium Plans', style: TextStyle(color: textColor)),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () => _showSnackbar(context, "Opening comparison modal..."),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
  }

  Widget _riskMetric(String label, String value, Color color) {
    return Column(children: [
      Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
    ]);
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
}
