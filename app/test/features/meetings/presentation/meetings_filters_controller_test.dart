import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/features/meetings/domain/meeting.dart';
import 'package:app/features/meetings/presentation/meetings_controller.dart';
import 'package:app/features/meetings/presentation/meetings_filters_controller.dart';
import 'package:app/features/units/presentation/units_controller.dart';

Meeting _meeting({required int id, required String title, required DateTime start, String host = ''}) =>
    Meeting(
      id: id,
      title: title,
      startTime: start,
      endTime: start.add(const Duration(hours: 1)),
      host: host,
      preparation: '',
      participants: '',
      location: 'Online',
      note: '',
      isImportant: false,
      unitId: 1,
    );

class _FakeMeetingsController extends MeetingsController {
  _FakeMeetingsController(this._meetings);
  final List<Meeting> _meetings;

  @override
  Future<List<Meeting>> build() async => _meetings;
}

void main() {
  test('filters by selected date and search query', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final day1 = DateTime(2026, 7, 10, 9);
    final day2 = DateTime(2026, 7, 11, 9);
    final meetings = [
      _meeting(id: 1, title: 'Họp rà soát tiến độ', start: day1, host: 'Thảo'),
      _meeting(id: 2, title: 'Họp giao ban', start: day1, host: 'Huy'),
      _meeting(id: 3, title: 'Họp khác ngày', start: day2, host: 'Thảo'),
    ];

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        meetingsControllerProvider.overrideWith(() => _FakeMeetingsController(meetings)),
      ],
    );
    addTearDown(container.dispose);
    await container.read(meetingsControllerProvider.future);

    container.read(selectedDateProvider.notifier).state = day1;
    expect(container.read(filteredMeetingsProvider).map((m) => m.id), [1, 2]);

    container.read(searchQueryProvider.notifier).state = 'rà soát';
    expect(container.read(filteredMeetingsProvider).map((m) => m.id), [1]);
  });
}
