import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/features/meetings/data/pinned_meetings_repository.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('defaults to empty set', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = PinnedMeetingsRepository(prefs);
    expect(repo.readAll(), isEmpty);
  });

  test('saveAll persists and readAll returns the saved ids', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = PinnedMeetingsRepository(prefs);

    await repo.saveAll({1, 5, 9});

    expect(repo.readAll(), {1, 5, 9});
  });
}
