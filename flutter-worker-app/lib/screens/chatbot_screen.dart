import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme/app_theme.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  static const String _apiKey = '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';
  static const String _apiUrl = 'https://api.groq.com/openai/v1/chat/completions';

  static const String _systemPrompt = '''You are GigShield AI Assistant — a friendly, knowledgeable helper for gig delivery workers using the GigShield parametric insurance app.

You help workers with:
- Understanding their insurance policy (coverage, premiums, claims)
- Explaining parametric insurance (auto-triggered claims based on weather/disruptions)
- Checking claim status and payout information
- Understanding risk scores and how they affect premiums
- Weather alerts and safety tips during heatwaves, floods, heavy rainfall
- General app navigation and feature guidance
- Financial tips for gig workers

Keep responses concise, friendly, and in simple language. Use emojis occasionally to be approachable. If asked about specific account details you don't have, guide the user to the relevant section of the app.''';

  @override
  void initState() {
    super.initState();
    // Welcome message
    _messages.add({
      'role': 'assistant',
      'content': 'Hey there! 👋 I\'m your GigShield AI assistant. I can help you with:\n\n🛡️ Policy & coverage questions\n📋 Claims & payouts\n🌦️ Weather alerts & safety\n💡 App tips & guidance\n\nHow can I help you today?',
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': text.trim()});
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      // Build conversation history for context
      final apiMessages = [
        {'role': 'system', 'content': _systemPrompt},
        ..._messages.map((m) => {'role': m['role']!, 'content': m['content']!}),
      ];

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'llama-3.3-70b-versatile',
          'messages': apiMessages,
          'temperature': 0.7,
          'max_tokens': 512,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'] as String;
        setState(() {
          _messages.add({'role': 'assistant', 'content': reply});
          _isLoading = false;
        });
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Fallback for Hackathon Demo if the API key expires
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _messages.add({
              'role': 'assistant', 
              'content': 'I am currently in Demo Mode! 🚀\n\n**About GigShield:**\nGigShield is an AI-powered Parametric Insurance Platform built for gig workers. We use real-time weather data and AI risk assessment to automatically trigger and process insurance claims during extreme weather (like severe heatwaves or floods) — before you even have to ask!\n\nOur mission is to provide an instant financial safety net for the gig economy, ensuring you protect your income from out-of-control disruptions.'
            });
            _isLoading = false;
          });
        });
      } else {
        setState(() {
          _messages.add({'role': 'assistant', 'content': '⚠️ Sorry, I couldn\'t process that (Error ${response.statusCode}). Please try again.'});
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'role': 'assistant', 'content': '⚠️ Connection error. Please check your internet and try again.'});
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final subtitleColor = isDark ? Colors.white54 : Colors.grey.shade600;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final bgColor = isDark ? AppTheme.darkBg : AppTheme.lightBg;
    final inputBg = isDark ? AppTheme.darkCard : Colors.white;

    return Scaffold(
      body: Container(
        color: bgColor,
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: cardColor,
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('GigShield AI', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600)),
                          Row(children: [
                            Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppTheme.secondaryColor, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            Text('Online', style: TextStyle(color: AppTheme.secondaryColor, fontSize: 11)),
                          ]),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _messages.clear();
                          _messages.add({
                            'role': 'assistant',
                            'content': 'Chat cleared! 🔄 How can I help you?',
                          });
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.refresh_rounded, color: subtitleColor, size: 20),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Messages ──
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _messages.length + (_isLoading ? 1 : 0),
                  itemBuilder: (ctx, i) {
                    if (i == _messages.length && _isLoading) {
                      return _typingIndicator(cardColor, subtitleColor);
                    }
                    final msg = _messages[i];
                    final isUser = msg['role'] == 'user';
                    return _messageBubble(msg['content']!, isUser, textColor, cardColor, isDark);
                  },
                ),
              ),

              // ── Quick Actions ──
              if (_messages.length <= 2)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _quickAction('📋 My claims', subtitleColor, cardColor),
                        _quickAction('🛡️ Policy info', subtitleColor, cardColor),
                        _quickAction('🌦️ Weather alerts', subtitleColor, cardColor),
                        _quickAction('💰 Payout status', subtitleColor, cardColor),
                      ],
                    ),
                  ),
                ),

              // ── Input ──
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                decoration: BoxDecoration(
                  color: cardColor,
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 8, offset: const Offset(0, -2))],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
                        ),
                        child: TextField(
                          controller: _controller,
                          style: TextStyle(color: textColor, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Ask me anything...',
                            hintStyle: TextStyle(color: subtitleColor),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onSubmitted: _sendMessage,
                          textInputAction: TextInputAction.send,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _sendMessage(_controller.text),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _messageBubble(String text, bool isUser, Color textColor, Color cardColor, bool isDark) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 10,
          left: isUser ? 48 : 0,
          right: isUser ? 0 : 48,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primaryColor : cardColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : textColor,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _typingIndicator(Color cardColor, Color subtitleColor) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, right: 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dot(subtitleColor, 0),
            const SizedBox(width: 4),
            _dot(subtitleColor, 1),
            const SizedBox(width: 4),
            _dot(subtitleColor, 2),
          ],
        ),
      ),
    );
  }

  Widget _dot(Color color, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (_, value, __) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color.withAlpha((77 + (value * 178).toInt()).clamp(0, 255)),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _quickAction(String label, Color subtitleColor, Color cardColor) {
    return GestureDetector(
      onTap: () => _sendMessage(label.substring(2).trim()),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primaryColor.withAlpha(77)),
        ),
        child: Text(label, style: TextStyle(color: subtitleColor, fontSize: 12)),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
