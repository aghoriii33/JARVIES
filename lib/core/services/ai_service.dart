import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Chat message model
class ChatMessage {
  final String role; // 'user' | 'model'
  final String text;
  final DateTime timestamp;
  final List<String>? imageUrls;

  const ChatMessage({
    required this.role,
    required this.text,
    required this.timestamp,
    this.imageUrls,
  });

  Map<String, dynamic> toJson() => {
    'role': role,
    'parts': [{'text': text}],
  };
}

/// Wraps the Google Gemini REST API
class AiService {
  AiService._();
  static final AiService instance = AiService._();

  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  bool get isConfigured =>
      _apiKey.isNotEmpty && _apiKey != 'your_gemini_api_key_here';

  // ── Text chat via gemini-1.5-flash ───────────────────────
  Future<String> sendMessage(List<ChatMessage> history, String userText) async {
    if (!isConfigured) {
      await Future.delayed(const Duration(milliseconds: 1200));
      return _mockResponse(userText);
    }

    final url = Uri.parse(
        '$_baseUrl/gemini-1.5-flash:generateContent?key=$_apiKey');

    final contents = [
      ...history.map((m) => m.toJson()),
      {
        'role': 'user',
        'parts': [{'text': userText}],
      }
    ];

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'contents': contents}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'] as String;
    } else {
      debugPrint('Gemini error: ${response.statusCode} ${response.body}');
      throw Exception('Gemini API error: ${response.statusCode}');
    }
  }

  // ── Image analysis via gemini-1.5-flash vision ───────────
  Future<String> analyzeImage(Uint8List imageBytes) async {
    if (!isConfigured) {
      await Future.delayed(const Duration(milliseconds: 1500));
      return 'Abstract digital composition — geometric shapes with vibrant gradient overlays. The design features Bauhaus-inspired symmetry with generative art elements. Estimated style: Contemporary digital abstract, circa 2020s.';
    }

    final url = Uri.parse(
        '$_baseUrl/gemini-1.5-flash:generateContent?key=$_apiKey');

    final base64Image = base64Encode(imageBytes);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': 'Analyze this image in detail. Describe the style, content, mood, colors, and any notable elements.'},
              {
                'inlineData': {
                  'mimeType': 'image/jpeg',
                  'data': base64Image,
                }
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'] as String;
    } else {
      throw Exception('Vision API error: ${response.statusCode}');
    }
  }

  // ── Mock responses for development without API key ────────
  String _mockResponse(String input) {
    final lower = input.toLowerCase();
    if (lower.contains('python') || lower.contains('code')) {
      return '''Here\'s a clean Python example:

```python
def fibonacci(n: int) -> list[int]:
    """Generate Fibonacci sequence up to n terms."""
    if n <= 0:
        return []
    seq = [0, 1]
    while len(seq) < n:
        seq.append(seq[-1] + seq[-2])
    return seq[:n]

# Example usage
print(fibonacci(10))
# Output: [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
```

This uses dynamic programming to efficiently compute the sequence in O(n) time.''';
    }
    if (lower.contains('design') || lower.contains('ui')) {
      return 'Great design question! Modern UI design follows these principles:\n\n**1. Visual Hierarchy** — Guide the user\'s eye with size and contrast\n**2. Whitespace** — Let elements breathe for clarity\n**3. Consistency** — Reuse colors, fonts, and spacing tokens\n**4. Feedback** — Every interaction should have a visual response\n\nFor dark UIs specifically, use subtle gradients and glassy surfaces to add depth without complexity.';
    }
    return 'That\'s a fascinating question! Let me break it down for you.\n\nI\'m currently running in demo mode (no API key configured). Once you add your Gemini API key to the `.env` file, I\'ll give you fully AI-powered responses.\n\nFor now, I can tell you that this UI was built with Flutter, using custom painters for the animated orb, and the `google_fonts` package for Inter typography. Is there anything specific about the app architecture you\'d like to know?';
  }
}
