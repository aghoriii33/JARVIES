import 'package:flutter/foundation.dart';
import '../../core/services/ai_service.dart';
import '../../core/services/settings_service.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [
    ChatMessage(
      role: 'model',
      text: "Hi! I'm your AI assistant. How can I help you today?",
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  bool _isTyping = false;
  String? _systemInstruction;

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;
  String? get systemInstruction => _systemInstruction;

  ChatProvider() {
    _loadSystemInstruction();
  }

  Future<void> _loadSystemInstruction() async {
    _systemInstruction = await SettingsService.instance.getSystemInstruction();
    notifyListeners();
  }

  Future<void> updateSystemInstruction(String instruction) async {
    _systemInstruction = instruction.trim().isEmpty ? null : instruction.trim();
    await SettingsService.instance.saveSystemInstruction(instruction);
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      role: 'user',
      text: text,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    _isTyping = true;
    notifyListeners();

    try {
      // Pass copy of messages history (excluding the newly added userMessage)
      final history = List<ChatMessage>.from(_messages)..removeLast();
      final reply = await AiService.instance.sendMessage(
        history,
        text,
        systemInstruction: _systemInstruction,
      );

      _messages.add(ChatMessage(
        role: 'model',
        text: reply,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      _messages.add(ChatMessage(
        role: 'model',
        text: 'Error occurred: Failed to get response from AI Wave API. $e',
        timestamp: DateTime.now(),
      ));
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    _messages.add(ChatMessage(
      role: 'model',
      text: "Chat cleared. Ask me anything!",
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }
}
