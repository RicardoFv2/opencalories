/// Centralized definition of supported languages for food translations
class SupportedLanguages {
  static const List<String> all = ['en', 'es'];

  /// Check if a language code is supported
  static bool isSupported(String languageCode) {
    return all.contains(languageCode);
  }

  /// Get comma-separated list for AI prompts
  static String toPromptString() {
    return all.join(', ');
  }
}
