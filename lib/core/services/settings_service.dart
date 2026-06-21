import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  SettingsService._();
  static final SettingsService instance = SettingsService._();

  static const String _kSystemInstruction = 'ai_system_instruction';

  /// Saves the system instruction
  Future<void> saveSystemInstruction(String instruction) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSystemInstruction, instruction);
  }

  /// Retrieves the saved system instruction, returns null if none is set
  Future<String?> getSystemInstruction() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kSystemInstruction);
  }
}
