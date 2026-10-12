import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  const AppConfig._();

  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY']?.trim() ?? '';

  static bool get hasGeminiApiKey => geminiApiKey.isNotEmpty;

  static const geminiModel = 'gemini-flash-lite-latest';
  static const appName = 'LENTERA';
}
