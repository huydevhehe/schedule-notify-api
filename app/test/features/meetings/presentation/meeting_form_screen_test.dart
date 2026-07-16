import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app/features/meetings/domain/meeting.dart';
import 'package:app/features/meetings/presentation/meeting_form_screen.dart';
import 'package:app/features/meetings/presentation/meetings_controller.dart';
import 'package:app/features/units/presentation/units_controller.dart';

class _CapturingController extends MeetingsController {
  MeetingDraft? created;
  MeetingDraft? updated;

  @override
  Future<List<Meeting>> build() async => [];

  @override
  Future<void> createMeeting(MeetingDraft draft) async => created = draft;

  @override
  Future<void> updateMeeting(int id, MeetingDraft draft) async => updated = draft;
}

class _FixedUnitController extends SelectedUnitController {
  @override
  int? build() => 7;
}

Meeting _existing() => Meeting(
      id: 42,
      title: 'Họp cũ',
      startTime: DateTime(2026, 7, 20, 8, 30),
      endTime: DateTime(2026, 7, 20, 9, 30),
      host: 'Anh A',
      preparation: 'Tài liệu',
      participants: 'Phòng KT',
      location: 'Phòng 1',
      note: 'ghi chú',
      isImportant: false,
      unitId: 7,
    );

Future<void> _pump(WidgetTester tester, Widget screen, _CapturingController controller) async {
  tester.view.physicalSize = const Size(1200, 2600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        selectedUnitIdProvider.overrideWith(_FixedUnitController.new),
        meetingsControllerProvider.overrideWith(() => controller),
      ],
      child: MaterialApp(home: screen),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async => initializeDateFormatting('vi_VN'));

  testWidgets('new meeting form shows all fields including the new ones', (tester) async {
    await _pump(tester, const MeetingFormScreen(), _CapturingController());

    for (final key in const [
      'title_field',
      'host_field',
      'preparation_field',
      'participants_field',
      'location_field',
      'note_field',
      'date_field',
      'start_time_field',
      'end_time_field',
      'important_switch',
      'save_button',
    ]) {
      expect(find.byKey(Key(key)), findsOneWidget, reason: 'thiếu $key');
    }
  });

  testWidgets('editing keeps chosen date/time and fields when saving', (tester) async {
    final controller = _CapturingController();
    await _pump(tester, MeetingFormScreen(meeting: _existing()), controller);

    await tester.tap(find.byKey(const Key('save_button')));
    await tester.pumpAndSettle();

    final draft = controller.updated!;
    expect(draft.title, 'Họp cũ');
    expect(draft.preparation, 'Tài liệu');
    expect(draft.participants, 'Phòng KT');
    expect(draft.note, 'ghi chú');
    expect(draft.unitId, 7);
    expect(draft.startTime, DateTime(2026, 7, 20, 8, 30));
    expect(draft.endTime, DateTime(2026, 7, 20, 9, 30));
  });

  testWidgets('toggling the important switch is reflected in the saved draft', (tester) async {
    final controller = _CapturingController();
    await _pump(tester, const MeetingFormScreen(), controller);

    await tester.enterText(find.byKey(const Key('title_field')), 'Cuộc họp mới');
    await tester.tap(find.byKey(const Key('important_switch')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('save_button')));
    await tester.pumpAndSettle();

    expect(controller.created!.title, 'Cuộc họp mới');
    expect(controller.created!.isImportant, isTrue);
  });
}
