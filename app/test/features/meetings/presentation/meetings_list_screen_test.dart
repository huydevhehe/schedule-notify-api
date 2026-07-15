import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/features/meetings/domain/meeting.dart';
import 'package:app/features/meetings/presentation/meetings_controller.dart';
import 'package:app/features/meetings/presentation/meetings_list_screen.dart';
import 'package:app/features/units/presentation/units_controller.dart';

void main() {
  testWidgets('shows meeting titles from the controller state', (tester) async {
    // MeetingsListScreen watches selectedUnitIdProvider (Task 5), whose Notifier.build()
    // reads sharedPreferencesProvider unconditionally. That provider has no default
    // implementation (see units_controller.dart) and must be overridden here the same
    // way main.dart overrides it at the app root, or the widget tree throws
    // UnimplementedError before the meetings list ever renders.
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final meeting = Meeting(
      id: 1,
      title: 'Họp rà soát tiến độ',
      startTime: DateTime(2026, 7, 20, 9),
      endTime: DateTime(2026, 7, 20, 10),
      host: 'B. Thảo',
      preparation: '',
      participants: '',
      location: 'Phòng họp số 3',
      note: '',
      isImportant: true,
      unitId: 1,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          meetingsControllerProvider.overrideWith(() => _FakeMeetingsController([meeting])),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(home: MeetingsListScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Họp rà soát tiến độ'), findsOneWidget);
    expect(find.text('Phòng họp số 3'), findsOneWidget);
  });
}

class _FakeMeetingsController extends MeetingsController {
  _FakeMeetingsController(this._meetings);
  final List<Meeting> _meetings;

  @override
  Future<List<Meeting>> build() async => _meetings;
}
