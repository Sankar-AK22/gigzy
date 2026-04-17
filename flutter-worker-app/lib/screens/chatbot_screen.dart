import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dart:async';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'Hello! I am the GigShield AI Assistant. How can I help you today?',
      'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}'
    }
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'isUser': true,
        'text': text.trim(),
        'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}'
      });
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();

    // Mock AI Response
    Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add({
          'isUser': false,
          'text': "I have received your request regarding: **$text**. Our system is analyzing this. For faster resolution, please check the claims tab.",
          'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}'
        });
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
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
    final bgColors = isDark
        ? const [Color(0xFF0A0E21), Color(0xFF1A1A2E)]
        : const [Color(0xFFF5F6FA), Color(0xFFEEEFF5)];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: textColor), onPressed: () => Navigator.pop(context)),
        title: Row(
          children: [
            const CircleAvatar(backgroundColor: AppTheme.primaryColor, radius: 16, child: Icon(Icons.smart_toy, color: Colors.white, size: 18)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('GigShield AI', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                const Text('Online', style: TextStyle(color: Colors.green, fontSize: 12)),
              ],
            )
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: bgColors, begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg['isUser'];
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isUser ? AppTheme.primaryColor : (isDark ? AppTheme.darkCard : Colors.white),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                          bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                        ),
                        boxShadow: [if (!isDark && !isUser) BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10)],
                      ),
                      child: Column(
                        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(msg['text'].toString().replaceAll('**', ''), style: TextStyle(color: isUser ? Colors.white : textColor, height: 1.4)),
                          const SizedBox(height: 4),
                          Text(msg['time'], style: TextStyle(color: isUser ? Colors.white70 : subtitleColor, fontSize: 10)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            if (_isTyping)
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Text('AI is typing', style: TextStyle(color: AppTheme.primaryColor, fontSize: 12)),
                      const SizedBox(width: 8),
                      SizedBox(width: 12, height: 12, child: const CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryColor)),
                    ],
                  ),
                ),
              ),

            // Quick Reply Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  _quickReply('Check claim status', isDark),
                  _quickReply('How does coverage work?', isDark),
                  _quickReply('Update my bank', isDark),
                ],
              ),
            ),

            // Input Field
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: isDark ? AppTheme.darkSurface : Colors.white),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: subtitleColor),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                          filled: true,
                          fillColor: isDark ? AppTheme.darkCard : Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                        onSubmitted: _sendMessage,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _sendMessage(_messageController.text),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
                        child: const Icon(Icons.send, color: Colors.white, size: 20),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _quickReply(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(text, style: TextStyle(color: AppTheme.primaryColor, fontSize: 12)),
        backgroundColor: AppTheme.primaryColor.withAlpha(25),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => _sendMessage(text),
      ),
    );
  }
}
