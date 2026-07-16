import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:app/features/meetings/domain/meeting.dart';
import 'package:app/features/meetings/presentation/meetings_controller.dart';
import 'package:app/features/meetings/presentation/pinned_meetings_controller.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final searchQueryProvider = StateProvider<String>((ref) => '');
final showPinnedOnlyProvider = StateProvider<bool>((ref) => false);

final filteredMeetingsProvider = Provider<List<Meeting>>((ref) {
  final meetings = ref.watch(meetingsControllerProvider).value ?? const [];
  final selectedDate = ref.watch(selectedDateProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final pinnedOnly = ref.watch(showPinnedOnlyProvider);
  final pinnedIds = ref.watch(pinnedMeetingIdsProvider);

  return meetings.where((meeting) {
    final sameDay = meeting.startTime.year == selectedDate.year &&
        meeting.startTime.month == selectedDate.month &&
        meeting.startTime.day == selectedDate.day;
    if (!sameDay) return false;

    if (pinnedOnly && !pinnedIds.contains(meeting.id)) return false;

    if (query.isNotEmpty) {
      final haystack = '${meeting.title} ${meeting.host} ${meeting.location}'.toLowerCase();
      if (!haystack.contains(query)) return false;
    }

    return true;
  }).toList();
});
