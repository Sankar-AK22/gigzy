import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/claim_model.dart';
import 'chatbot_screen.dart';

class ClaimsScreen extends StatefulWidget {
  const ClaimsScreen({super.key});

  @override
  State<ClaimsScreen> createState() => _ClaimsScreenState();
}

class _ClaimsScreenState extends State<ClaimsScreen> {
  int _selectedTab = 0; // 0: All, 1: Rain, 2: Heatwave, 3: Flood

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

    List<ClaimModel> filteredClaims = provider.claims;
    if (_selectedTab == 1) filteredClaims = filteredClaims.where((c) => c.disruptionType.contains('Rainfall')).toList();
    if (_selectedTab == 2) filteredClaims = filteredClaims.where((c) => c.disruptionType.contains('Heatwave')).toList();
    if (_selectedTab == 3) filteredClaims = filteredClaims.where((c) => c.disruptionType.contains('Flood')).toList();

    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(colors: bgColors, begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Claims Center', style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Auto-triggered disruption claims', style: TextStyle(color: subtitleColor)),
                    ],
                  ),
                  // 4. AI Chat Integration Shortcut
                  IconButton(
                    icon: const Icon(Icons.support_agent, color: AppTheme.primaryColor, size: 28),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatbotScreen())),
                  )
                ],
              ),
            ),

            // 5. Filter by Disruption
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _filterChip('All', 0, isDark),
                  _filterChip('🌧️ Rain', 1, isDark),
                  _filterChip('🌡️ Heat', 2, isDark),
                  _filterChip('🌊 Flood', 3, isDark),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Claim Success Calculator & 9. Historical Claims Graph
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.calculate, color: AppTheme.warningColor),
                          const SizedBox(height: 8),
                          Text('92% Prob', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Success Rate', style: TextStyle(color: subtitleColor, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Claims Trend', style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                              const Icon(Icons.trending_up, color: AppTheme.primaryColor, size: 16)
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 30,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [0.2, 0.4, 0.3, 0.8, 0.5, 0.9].map((v) => Container(width: 10, height: 30*v, decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(4)))).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: filteredClaims.isEmpty
                  ? Center(child: Text('No claims found', style: TextStyle(color: subtitleColor)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: filteredClaims.length,
                      itemBuilder: (context, index) {
                        final claim = filteredClaims[index];
                        // 8. Expandable Detail Cards
                        return _ClaimExpandableCard(claim: claim, isDark: isDark);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, int index, bool isDark) {
    final isSelected = _selectedTab == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        selected: isSelected,
        onSelected: (val) => setState(() => _selectedTab = index),
        selectedColor: AppTheme.primaryColor,
        backgroundColor: isDark ? AppTheme.darkCard : Colors.grey.shade200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class _ClaimExpandableCard extends StatelessWidget {
  final ClaimModel claim;
  final bool isDark;

  const _ClaimExpandableCard({required this.claim, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final subtitleColor = isDark ? Colors.white54 : Colors.grey.shade600;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    
    final isPending = claim.claimStatus.toLowerCase() == 'pending';
    final isPaid = claim.claimStatus.toLowerCase() == 'paid';
    final statusColor = isPaid ? Colors.green : (isPending ? AppTheme.warningColor : AppTheme.primaryColor);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: statusColor.withAlpha(50))),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Row(
            children: [
              Text(claim.disruptionType.contains('Rain') ? '🌧️' : '🌡️', style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(claim.disruptionType, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15)),
                    Text((claim.createdAt ?? DateTime.now().toString()).substring(0, 10), style: TextStyle(color: subtitleColor, fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${claim.payoutAmount}', style: const TextStyle(color: AppTheme.secondaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                  // 6. Animated Status Badges
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: statusColor.withAlpha(30), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        if (isPending) const SizedBox(width: 8, height: 8, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.warningColor)),
                        if (isPending) const SizedBox(width: 4),
                        Text(claim.claimStatus.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  // 1. Step-by-Step Claim Timeline
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _timelineStep('Triggered', true, isDark),
                      _timelineLine(true),
                      _timelineStep('Processing', true, isDark),
                      _timelineLine(isPaid),
                      _timelineStep('Paid', isPaid, isDark),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // 10. Countdown Timer (if pending)
                  if (isPending)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppTheme.warningColor.withAlpha(20), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const Icon(Icons.timer, color: AppTheme.warningColor, size: 20),
                          const SizedBox(width: 8),
                          Text('Est. transfer in 4 hours 12 mins', style: TextStyle(color: textColor, fontSize: 12)),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 2. Report Issue FAB / Button & 7. Upload Proof Mockup
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.camera_alt, size: 16),
                        label: const Text('Add Proof'),
                        style: OutlinedButton.styleFrom(foregroundColor: textColor),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.report_problem, size: 16, color: Colors.redAccent),
                        label: const Text('Report Issue', style: TextStyle(color: Colors.redAccent)),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _timelineStep(String label, bool active, bool isDark) {
    return Column(
      children: [
        Icon(active ? Icons.check_circle : Icons.radio_button_unchecked, color: active ? AppTheme.primaryColor : (isDark ? Colors.white30 : Colors.black26), size: 20),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: active ? (isDark ? Colors.white : Colors.black) : (isDark ? Colors.white54 : Colors.black54), fontSize: 10)),
      ],
    );
  }

  Widget _timelineLine(bool active) {
    return Expanded(child: Container(height: 2, color: active ? AppTheme.primaryColor : Colors.grey.shade300));
  }
}
