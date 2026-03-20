import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/firestore_service.dart';
import '../models/worker_model.dart';

class ClaimsScreen extends StatefulWidget {
  const ClaimsScreen({super.key});

  @override
  State<ClaimsScreen> createState() => _ClaimsScreenState();
}

class _ClaimsScreenState extends State<ClaimsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String? _selectedUserId; // null means 'All Users'

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final subtitleColor = isDark ? Colors.white54 : Colors.grey.shade600;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final bgColors = isDark
        ? const [Color(0xFF0A0E21), Color(0xFF1A1A2E)]
        : const [Color(0xFFF5F6FA), Color(0xFFEEEFF5)];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: bgColors, begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Text('Claims History', style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              child: Text('Auto-triggered parametric claims', style: TextStyle(color: subtitleColor)),
            ),
            
            // User Filter Bar
            SizedBox(
              height: 48,
              child: StreamBuilder<List<WorkerModel>>(
                stream: _firestoreService.getWorkersStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading users', style: TextStyle(color: AppTheme.accentColor)));
                  }
                  
                  final workers = snapshot.data ?? [];
                  
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildFilterChip('All Users', null, _selectedUserId == null, textColor),
                      ...workers.map((w) => _buildFilterChip(w.name, w.id, _selectedUserId == w.id, textColor)),
                    ],
                  );
                },
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Claims List
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _firestoreService.getClaimsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading claims', style: TextStyle(color: AppTheme.accentColor)));
                  }
                  
                  final allClaims = snapshot.data ?? [];
                  // Filter by user if selected
                  final filteredClaims = _selectedUserId == null 
                      ? allClaims 
                      : allClaims.where((c) => c['userId'] == _selectedUserId).toList();
                      
                  if (filteredClaims.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_rounded, size: 64, color: subtitleColor.withAlpha(50)),
                          const SizedBox(height: 16),
                          Text('No claims found', style: TextStyle(color: subtitleColor, fontSize: 16)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredClaims.length,
                    itemBuilder: (context, index) {
                      final c = filteredClaims[index];
                      return _claimCard(c, cardColor, textColor, subtitleColor);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String? userId, bool isSelected, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() => _selectedUserId = userId);
          }
        },
        selectedColor: AppTheme.primaryColor.withAlpha(50),
        backgroundColor: Colors.transparent,
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryColor : textColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.withAlpha(50),
          ),
        ),
      ),
    );
  }

  Widget _claimCard(Map<String, dynamic> c, Color cardColor, Color textColor, Color subtitleColor) {
    final status = c['claimStatus']?.toString() ?? 'pending';
    final payout = c['payoutAmount']?.toString() ?? '0';
    final type = c['disruptionType']?.toString() ?? 'Unknown';
    // Use dateString if exists (from seed data), else placeholder
    final date = c['dateString']?.toString() ?? 'Recent'; 
    
    final color = status == 'paid' ? AppTheme.secondaryColor : status == 'review' ? AppTheme.warningColor : AppTheme.accentColor;
    
    String emoji = '⚠️';
    if (type.contains('rain')) emoji = '🌧️';
    if (type.contains('heat') || type.contains('temperature')) emoji = '🌡️';
    if (type.contains('pollution') || type.contains('aqi')) emoji = '😷';
    if (type.contains('flood')) emoji = '🌊';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(type.toUpperCase(), style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
          Text(date, style: TextStyle(color: subtitleColor, fontSize: 12)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('₹$payout', style: const TextStyle(color: AppTheme.secondaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
          Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ]),
      ]),
    );
  }
}
