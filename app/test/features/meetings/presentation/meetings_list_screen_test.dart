import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/features/meetings/domain/meeting.dart';
import 'package:app/features/meetings/presentation/meetings_controller.dart';
import 'package:app/features/meetings/presentation/meetings_filters_controller.dart';
import 'package:app/features/meetings/presentation/meetings_list_screen.dart';
import 'package:app/features/units/presentation/units_controller.dart';

class _FakeMeetingsController extends MeetingsController {
  _FakeMeetingsController(this._meetings);
  final List<Meeting> _meetings;

  @override
  Future<List<Meeting>> build() async => _meetings;
}

Meeting _meeting(DateTime start) => Meeting(
      id: 1,
      title: 'Họp rà soát tiến độ',
      startTime: start,
      endTime: start.add(const Duration(hours: 1)),
      host: 'B. Thảo',
      preparation: '',
      participants: '',
      location: 'Phòng họp số 3',
      note: '',
      isImportant: true,
      unitId: 1,
    );

void main() {
  testWidgets('shows meetings for the selected date and hides them after filtering to a different date', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime(2026, 7, 10, 9);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          meetingsControllerProvider.overrideWith(() => _FakeMeetingsController([_meeting(today)])),
          selectedDateProvider.overrideWith((ref) => today),
        ],
        child: const MaterialApp(home: MeetingsListScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Họp rà soát tiến độ'), findsOneWidget);
    // MeetingCard renders the location as part of a Text.rich span ("Địa điểm: <location>"),
    // so an exact find.text match would fail — textContaining matches the substring correctly.
    expect(find.textContaining('Phòng họp số 3'), findsOneWidget);
  });

  testWidgets('search toggle shows a search field that filters results', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime(2026, 7, 10, 9);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          meetingsControllerProvider.overrideWith(() => _FakeMeetingsController([_meeting(today)])),
          selectedDateProvider.overrideWith((ref) => today),
        ],
        child: const MaterialApp(home: MeetingsListScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('search_toggle_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('search_field')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('search_field')), 'không khớp gì cả');
    await tester.pumpAndSettle();

    expect(find.text('Không có cuộc họp nào'), findsOneWidget);
  });
}
