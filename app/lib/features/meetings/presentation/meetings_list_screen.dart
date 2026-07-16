import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:app/core/widgets/gradient_app_bar.dart';
import 'package:app/features/auth/domain/user.dart';
import 'package:app/features/auth/presentation/auth_controller.dart';
import 'package:app/features/meetings/presentation/meetings_controller.dart';
import 'package:app/features/meetings/presentation/meetings_filters_controller.dart';
import 'package:app/features/meetings/presentation/meeting_form_screen.dart';
import 'package:app/features/meetings/presentation/pinned_meetings_controller.dart';
import 'package:app/features/meetings/presentation/widgets/meeting_card.dart';
import 'package:app/features/meetings/presentation/widgets/month_calendar_dialog.dart';
import 'package:app/features/meetings/presentation/widgets/week_day_selector.dart';
import 'package:app/features/units/presentation/units_controller.dart';

class MeetingsListScreen extends ConsumerStatefulWidget {
  const MeetingsListScreen({super.key});

  @override
  ConsumerState<MeetingsListScreen> createState() => _MeetingsListScreenState();
}

class _MeetingsListScreenState extends ConsumerState<MeetingsListScreen> {
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meetingsAsync = ref.watch(meetingsControllerProvider);
    final user = ref.watch(authControllerProvider).value;
    final selectedUnitId = ref.watch(selectedUnitIdProvider);
    final isAdmin =
        user?.role == UserRole.admin && user!.units.any((u) => u.id == selectedUnitId);
    final selectedDate = ref.watch(selectedDateProvider);
    final showPinnedOnly = ref.watch(showPinnedOnlyProvider);
    final pinnedIds = ref.watch(pinnedMeetingIdsProvider);
    final filteredMeetings = ref.watch(filteredMeetingsProvider);

    return Scaffold(
      appBar: GradientAppBar(
        title: 'Lịch họp',
        subtitle: DateFormat('EEEE, dd/MM/yyyy', 'vi_VN').format(selectedDate),
        bottom: _isSearching
            ? PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextField(
                    key: const Key('search_field'),
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Tìm theo tiêu đề, chủ trì, địa điểm...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                    ),
                    onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
                  ),
                ),
              )
            : WeekDaySelector(
                selectedDate: selectedDate,
                onDateSelected: (date) => ref.read(selectedDateProvider.notifier).state = date,
              ),
        actions: [
          IconButton(
            key: const Key('search_toggle_button'),
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() => _isSearching = !_isSearching);
              if (!_isSearching) {
                _searchController.clear();
                ref.read(searchQueryProvider.notifier).state = '';
              }
            },
          ),
          IconButton(
            key: const Key('calendar_icon_button'),
            icon: const Icon(Icons.calendar_month, color: Colors.white),
            onPressed: () async {
              final picked = await MonthCalendarDialog.show(context, selectedDate);
              if (picked != null) {
                ref.read(selectedDateProvider.notifier).state = picked;
              }
            },
          ),
          IconButton(
            key: const Key('pinned_filter_button'),
            icon: Icon(showPinnedOnly ? Icons.star : Icons.star_border, color: Colors.white),
            onPressed: () =>
                ref.read(showPinnedOnlyProvider.notifier).state = !showPinnedOnly,
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              key: const Key('add_meeting_button'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MeetingFormScreen()),
              ),
              child: const Icon(Icons.add),
            )
          : null,
      body: meetingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Lỗi tải lịch: $error')),
        data: (_) {
          if (filteredMeetings.isEmpty) {
            return const Center(child: Text('Không có cuộc họp nào'));
          }
          return ListView.builder(
            itemCount: filteredMeetings.length,
            itemBuilder: (context, index) {
              final meeting = filteredMeetings[index];
              return MeetingCard(
                meeting: meeting,
                isAdmin: isAdmin,
                isPinned: pinnedIds.contains(meeting.id),
                onTogglePin: () =>
                    ref.read(pinnedMeetingIdsProvider.notifier).toggle(meeting.id),
                onEdit: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => MeetingFormScreen(meeting: meeting)),
                ),
                onDelete: () =>
                    ref.read(meetingsControllerProvider.notifier).deleteMeeting(meeting.id),
              );
            },
          );
        },
      ),
    );
  }
}
