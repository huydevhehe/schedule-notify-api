import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/meetings/data/pinned_meetings_repository.dart';
import 'package:app/features/units/presentation/units_controller.dart';

final pinnedMeetingIdsProvider =
    NotifierProvider<PinnedMeetingsController, Set<int>>(PinnedMeetingsController.new);

class PinnedMeetingsController extends Notifier<Set<int>> {
  late final PinnedMeetingsRepository _repo =
      PinnedMeetingsRepository(ref.read(sharedPreferencesProvider));

  @override
  Set<int> build() => _repo.readAll();

  void toggle(int meetingId) {
    final updated = {...state};
    if (updated.contains(meetingId)) {
      updated.remove(meetingId);
    } else {
      updated.add(meetingId);
    }
    state = updated;
    _repo.saveAll(updated);
  }
}
