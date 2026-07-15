import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/meetings/domain/meeting.dart';
import 'package:app/features/meetings/presentation/meetings_controller.dart';
import 'package:app/features/units/presentation/units_controller.dart';

class MeetingFormScreen extends ConsumerStatefulWidget {
  const MeetingFormScreen({super.key, this.meeting});

  final Meeting? meeting;

  @override
  ConsumerState<MeetingFormScreen> createState() => _MeetingFormScreenState();
}

class _MeetingFormScreenState extends ConsumerState<MeetingFormScreen> {
  late final _titleController = TextEditingController(text: widget.meeting?.title ?? '');
  late final _hostController = TextEditingController(text: widget.meeting?.host ?? '');
  late final _locationController = TextEditingController(text: widget.meeting?.location ?? '');
  late final DateTime _startTime = widget.meeting?.startTime ?? DateTime.now();
  late final DateTime _endTime =
      widget.meeting?.endTime ?? DateTime.now().add(const Duration(hours: 1));

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.meeting != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Sửa cuộc họp' : 'Tạo cuộc họp')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              key: const Key('title_field'),
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Tiêu đề'),
            ),
            TextField(
              key: const Key('host_field'),
              controller: _hostController,
              decoration: const InputDecoration(labelText: 'Chủ trì'),
            ),
            TextField(
              key: const Key('location_field'),
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Địa điểm'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('save_button'),
              onPressed: _save,
              child: Text(isEditing ? 'Lưu' : 'Tạo'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final unitId = ref.read(selectedUnitIdProvider);
    if (unitId == null) return;

    final draft = MeetingDraft(
      title: _titleController.text,
      startTime: _startTime,
      endTime: _endTime,
      host: _hostController.text,
      preparation: widget.meeting?.preparation ?? '',
      participants: widget.meeting?.participants ?? '',
      location: _locationController.text,
      note: widget.meeting?.note ?? '',
      isImportant: widget.meeting?.isImportant ?? false,
      unitId: unitId,
    );

    final controller = ref.read(meetingsControllerProvider.notifier);
    if (widget.meeting != null) {
      await controller.updateMeeting(widget.meeting!.id, draft);
    } else {
      await controller.createMeeting(draft);
    }

    if (mounted) Navigator.of(context).pop();
  }
}
