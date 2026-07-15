import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/auth/domain/user.dart';
import 'package:app/features/auth/presentation/auth_controller.dart';
import 'package:app/features/meetings/domain/meeting.dart';
import 'package:app/features/meetings/presentation/meetings_controller.dart';
import 'package:app/features/meetings/presentation/meeting_form_screen.dart';
import 'package:app/features/units/presentation/units_controller.dart';

class MeetingsListScreen extends ConsumerWidget {
  const MeetingsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetingsAsync = ref.watch(meetingsControllerProvider);
    final user = ref.watch(authControllerProvider).value;
    final selectedUnitId = ref.watch(selectedUnitIdProvider);
    final isAdmin = user?.role == UserRole.admin &&
        user!.units.any((u) => u.id == selectedUnitId);

    return Scaffold(
      appBar: AppBar(title: const Text('Lịch họp')),
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
        data: (meetings) {
          if (meetings.isEmpty) {
            return const Center(child: Text('Không có cuộc họp nào'));
          }
          return ListView.builder(
            itemCount: meetings.length,
            itemBuilder: (context, index) => _MeetingCard(meeting: meetings[index], isAdmin: isAdmin),
          );
        },
      ),
    );
  }
}

class _MeetingCard extends ConsumerWidget {
  const _MeetingCard({required this.meeting, required this.isAdmin});

  final Meeting meeting;
  final bool isAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: meeting.isImportant ? Colors.red.shade50 : null,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(meeting.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(meeting.location),
            Text('Chủ trì: ${meeting.host}'),
          ],
        ),
        isThreeLine: true,
        trailing: isAdmin
            ? PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => MeetingFormScreen(meeting: meeting)),
                    );
                  } else if (value == 'delete') {
                    ref.read(meetingsControllerProvider.notifier).deleteMeeting(meeting.id);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Sửa')),
                  PopupMenuItem(value: 'delete', child: Text('Xóa')),
                ],
              )
            : null,
      ),
    );
  }
}
