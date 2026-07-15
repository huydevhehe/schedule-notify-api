import 'package:app/features/meetings/data/meetings_api.dart';
import 'package:app/features/meetings/domain/meeting.dart';

class MeetingsRepository {
  MeetingsRepository(this._api);

  final MeetingsApi _api;

  Future<List<Meeting>> listForUnit(int unitId) async {
    final json = await _api.list(unitId);
    return json.map((e) => Meeting.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Meeting> create(MeetingDraft draft) async {
    final json = await _api.create(draft);
    return Meeting.fromJson(json);
  }

  Future<Meeting> update(int id, MeetingDraft draft) async {
    final json = await _api.update(id, draft);
    return Meeting.fromJson(json);
  }

  Future<void> delete(int id) => _api.delete(id);
}
