import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/auth/presentation/auth_controller.dart';
import 'package:app/features/meetings/data/meetings_api.dart';
import 'package:app/features/meetings/data/meetings_repository.dart';
import 'package:app/features/meetings/domain/meeting.dart';
import 'package:app/features/units/presentation/units_controller.dart';

final meetingsRepositoryProvider = Provider<MeetingsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MeetingsRepository(MeetingsApi(apiClient.dio));
});

class MeetingsController extends AsyncNotifier<List<Meeting>> {
  @override
  Future<List<Meeting>> build() async {
    final unitId = ref.watch(selectedUnitIdProvider);
    if (unitId == null) return [];
    return ref.read(meetingsRepositoryProvider).listForUnit(unitId);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> createMeeting(MeetingDraft draft) async {
    await ref.read(meetingsRepositoryProvider).create(draft);
    await refresh();
  }

  Future<void> updateMeeting(int id, MeetingDraft draft) async {
    await ref.read(meetingsRepositoryProvider).update(id, draft);
    await refresh();
  }

  Future<void> deleteMeeting(int id) async {
    await ref.read(meetingsRepositoryProvider).delete(id);
    await refresh();
  }
}

final meetingsControllerProvider =
    AsyncNotifierProvider<MeetingsController, List<Meeting>>(MeetingsController.new);
