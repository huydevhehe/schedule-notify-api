import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/features/meetings/presentation/pinned_meetings_controller.dart';
import 'package:app/features/units/presentation/units_controller.dart';

void main() {
  test('toggle adds then removes a meeting id, persisting each change', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);

    expect(container.read(pinnedMeetingIdsProvider), isEmpty);

    container.read(pinnedMeetingIdsProvider.notifier).toggle(7);
    expect(container.read(pinnedMeetingIdsProvider), {7});

    container.read(pinnedMeetingIdsProvider.notifier).toggle(7);
    expect(container.read(pinnedMeetingIdsProvider), isEmpty);
  });
}
