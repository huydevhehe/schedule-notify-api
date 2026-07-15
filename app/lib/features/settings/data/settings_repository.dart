import 'package:shared_preferences/shared_preferences.dart';

enum FontSizeOption { small, medium, large }

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _fontSizeKey = 'font_size';
  static const _keywordKey = 'highlight_keyword';

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
}
