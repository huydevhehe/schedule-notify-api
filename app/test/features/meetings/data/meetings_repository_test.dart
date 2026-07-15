import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/features/meetings/data/meetings_api.dart';
import 'package:app/features/meetings/data/meetings_repository.dart';
import 'package:app/features/meetings/domain/meeting.dart';

class _MockMeetingsApi extends Mock implements MeetingsApi {}

MeetingDraft _draft() => MeetingDraft(
      title: 'Họp VTTP',
      startTime: DateTime(2026, 7, 20, 9),
      endTime: DateTime(2026, 7, 20, 10),
      host: 'B. Thảo',
      preparation: 'TTKD',
      participants: 'Team A',
      location: 'Online',
      note: '',
      isImportant: false,
      unitId: 1,
    );

Map<String, dynamic> _json({int id = 1}) => {
      'id': id,
      'title': 'Họp VTTP',
      'start_time': '2026-07-20T09:00:00.000',
      'end_time': '2026-07-20T10:00:00.000',
      'host': 'B. Thảo',
      'preparation': 'TTKD',
      'participants': 'Team A',
      'location': 'Online',
      'note': '',
      'is_important': false,
      'unit': 1,
    };

void main() {
  late _MockMeetingsApi api;
  late MeetingsRepository repository;

  setUpAll(() {
    registerFallbackValue(_draft());
  });

  setUp(() {
    api = _MockMeetingsApi();
    repository = MeetingsRepository(api);
  });

  test('listForUnit maps JSON list into Meeting entities', () async {
    when(() => api.list(1)).thenAnswer((_) async => [_json()]);

    final meetings = await repository.listForUnit(1);

    expect(meetings, hasLength(1));
    expect(meetings.first.title, 'Họp VTTP');
  });

  test('create posts the draft and returns the created Meeting', () async {
    when(() => api.create(any())).thenAnswer((_) async => _json());

    final meeting = await repository.create(_draft());

    expect(meeting.id, 1);
    verify(() => api.create(any())).called(1);
  });

  test('delete calls the API with the given id', () async {
    when(() => api.delete(1)).thenAnswer((_) async {});

    await repository.delete(1);

    verify(() => api.delete(1)).called(1);
  });
}
