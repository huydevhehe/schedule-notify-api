import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/features/settings/data/settings_repository.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('defaults to medium font size and empty keyword', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = SettingsRepository(prefs);

    expect(repo.readFontSize(), FontSizeOption.medium);
    expect(repo.readHighlightKeyword(), '');
  });

  test('save persists font size and keyword', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = SettingsRepository(prefs);

    await repo.saveFontSize(FontSizeOption.large);
    await repo.saveHighlightKeyword('khẩn');

    expect(repo.readFontSize(), FontSizeOption.large);
    expect(repo.readHighlightKeyword(), 'khẩn');
  });
}
