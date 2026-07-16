import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FontSizeOption { small, medium, large }

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _fontSizeKey = 'font_size';
  static const _keywordKey = 'highlight_keyword';
  static const _themeModeKey = 'theme_mode';
  static const _showCreatedDateKey = 'show_created_date';

  FontSizeOption readFontSize() {
    final stored = _prefs.getString(_fontSizeKey);
    return FontSizeOption.values.firstWhere(
      (e) => e.name == stored,
      orElse: () => FontSizeOption.medium,
    );
  }

  Future<void> saveFontSize(FontSizeOption option) => _prefs.setString(_fontSizeKey, option.name);

  String readHighlightKeyword() => _prefs.getString(_keywordKey) ?? '';

  Future<void> saveHighlightKeyword(String keyword) => _prefs.setString(_keywordKey, keyword);

  ThemeMode readThemeMode() {
    final stored = _prefs.getString(_themeModeKey);
    return ThemeMode.values.firstWhere(
      (e) => e.name == stored,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> saveThemeMode(ThemeMode mode) => _prefs.setString(_themeModeKey, mode.name);

  bool readShowCreatedDate() => _prefs.getBool(_showCreatedDateKey) ?? true;

  Future<void> saveShowCreatedDate(bool value) =>
      _prefs.setBool(_showCreatedDateKey, value);
}
