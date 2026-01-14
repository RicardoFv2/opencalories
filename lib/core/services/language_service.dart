import 'dart:ui';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_service.g.dart';

@Riverpod(keepAlive: true)
class LanguageService extends _$LanguageService {
  static const _kLanguageKey = 'selected_language_code';

  @override
  FutureOr<Locale?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kLanguageKey);
    return code != null ? Locale(code) : null;
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_kLanguageKey);
    } else {
      await prefs.setString(_kLanguageKey, locale.languageCode);
    }
    state = AsyncData(locale);
  }
}
