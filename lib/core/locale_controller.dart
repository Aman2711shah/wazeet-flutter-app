import 'dart:ui' show Locale;
import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider;
import 'package:state_notifier/state_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Riverpod provider that exposes the current [Locale] (or null to follow system)
/// and the [LocaleController] to update it.
final localeControllerProvider =
  StateNotifierProvider<LocaleController, Locale?>((ref) => LocaleController());

class LocaleController extends StateNotifier<Locale?> {
  static const _kLocaleKey = 'app_locale'; // 'en' | 'ar' | ''

  // pass an initial value to StateNotifier
  LocaleController() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kLocaleKey);
    if (code == null || code.isEmpty) {
      state = null; // follow system
    } else {
      state = Locale(code);
    }
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_kLocaleKey);
    } else {
      await prefs.setString(_kLocaleKey, locale.languageCode);
    }
    state = locale;
  }
}
// End of file