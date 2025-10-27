import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider;
import 'package:state_notifier/state_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModePref { system, light, dark }

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeModePref>((ref) => ThemeController());

class ThemeController extends StateNotifier<ThemeModePref> {
  static const _kThemeKey = 'theme_mode'; // 'system'|'light'|'dark'

  ThemeController() : super(ThemeModePref.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kThemeKey);
    switch (raw) {
      case 'light':
        state = ThemeModePref.light;
        break;
      case 'dark':
        state = ThemeModePref.dark;
        break;
      default:
        state = ThemeModePref.system;
    }
  }

  Future<void> set(ThemeModePref pref) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeKey, switch (pref) {
      ThemeModePref.light => 'light',
      ThemeModePref.dark => 'dark',
      ThemeModePref.system => 'system',
    });
    state = pref;
  }

  ThemeMode toFlutterMode() => switch (state) {
        ThemeModePref.light => ThemeMode.light,
        ThemeModePref.dark => ThemeMode.dark,
        ThemeModePref.system => ThemeMode.system,
      };
}
