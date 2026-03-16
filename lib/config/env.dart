import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Simple environment wrapper for API keys and configuration.
///
/// Create a `.env` file at the project root with values like:
///
/// ```env
/// GEMINI_API_KEY=your_api_key_here
/// GEMINI_MODEL=gemini-1.5-mini
/// GEMINI_BASE_URL=https://generativelanguage.googleapis.com
/// ```
///
/// Then ensure `main()` calls `dotenv.load();` before using these values.
class Env {
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get geminiModel => dotenv.env['GEMINI_MODEL'] ?? 'gemini-1.5-mini';
  static String get geminiBaseUrl =>
      dotenv.env['GEMINI_BASE_URL'] ?? 'https://generativelanguage.googleapis.com';
}
