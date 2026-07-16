import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:app/core/widgets/gradient_app_bar.dart';
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
  late final _preparationController =
      TextEditingController(text: widget.meeting?.preparation ?? '');
  late final _participantsController =
      TextEditingController(text: widget.meeting?.participants ?? '');
  late final _locationController = TextEditingController(text: widget.meeting?.location ?? '');
  late final _noteController = TextEditingController(text: widget.meeting?.note ?? '');

  late DateTime _date =
      (widget.meeting?.startTime ?? DateTime.now());
  late TimeOfDay _startTime = TimeOfDay.fromDateTime(
    widget.meeting?.startTime ?? DateTime.now(),
  );
  late TimeOfDay _endTime = TimeOfDay.fromDateTime(
    widget.meeting?.endTime ?? DateTime.now().add(const Duration(hours: 1)),
  );
  late bool _isImportant = widget.meeting?.isImportant ?? false;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _hostController.dispose();
    _preparationController.dispose();
    _participantsController.dispose();
    _locationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.meeting != null;

    return Scaffold(
      appBar: GradientAppBar(
        title: isEditing ? 'Sửa cuộc họp' : 'Tạo cuộc họp',
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'Thông tin cuộc họp',
            children: [
              TextField(
                key: const Key('title_field'),
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Nội dung / Tiêu đề'),
                textCapitalization: TextCapitalization.sentences,
              ),
              TextField(
                key: const Key('host_field'),
                controller: _hostController,
                decoration: const InputDecoration(labelText: 'Chủ trì'),
              ),
              TextField(
                key: const Key('preparation_field'),
                controller: _preparationController,
                decoration: const InputDecoration(labelText: 'Chuẩn bị'),
              ),
              TextField(
                key: const Key('participants_field'),
                controller: _participantsController,
                decoration: const InputDecoration(labelText: 'Thành phần'),
                minLines: 1,
                maxLines: 3,
              ),
              TextField(
                key: const Key('location_field'),
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Địa điểm'),
              ),
              TextField(
                key: const Key('note_field'),
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Ghi chú'),
                minLines: 1,
                maxLines: 4,
              ),
            ],
          ),
          _Section(
            title: 'Thời gian',
            children: [
              _PickerTile(
                key: const Key('date_field'),
                icon: Icons.calendar_today,
                label: 'Ngày họp',
                value: DateFormat('EEEE, dd/MM/yyyy', 'vi_VN').format(_date),
                onTap: _pickDate,
              ),
              Row(
                children: [
                  Expanded(
                    child: _PickerTile(
                      key: const Key('start_time_field'),
                      icon: Icons.schedule,
                      label: 'Bắt đầu',
                      value: _startTime.format(context),
                      onTap: () => _pickTime(isStart: true),
                    ),
                  ),
                  Expanded(
                    child: _PickerTile(
                      key: const Key('end_time_field'),
                      icon: Icons.schedule_outlined,
                      label: 'Kết thúc',
                      value: _endTime.format(context),
                      onTap: () => _pickTime(isStart: false),
                    ),
                  ),
                ],
              ),
            ],
          ),
          _Section(
            title: 'Đánh dấu',
            children: [
              SwitchListTile(
                key: const Key('important_switch'),
                contentPadding: EdgeInsets.zero,
                title: const Text('Cuộc họp quan trọng'),
                subtitle: const Text('Sẽ được tô đỏ nổi bật trong danh sách'),
                value: _isImportant,
                onChanged: (value) => setState(() => _isImportant = value),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FilledButton(
            key: const Key('save_button'),
            onPressed: _saving ? null : _save,
            child: Text(isEditing ? 'Lưu' : 'Tạo'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  DateTime _combine(TimeOfDay time) =>
      DateTime(_date.year, _date.month, _date.day, time.hour, time.minute);

  Future<void> _save() async {
    final unitId = ref.read(selectedUnitIdProvider);
    if (unitId == null) return;

    setState(() => _saving = true);

    final draft = MeetingDraft(
      title: _titleController.text,
      startTime: _combine(_startTime),
      endTime: _combine(_endTime),
      host: _hostController.text,
      preparation: _preparationController.text,
      participants: _participantsController.text,
      location: _locationController.text,
      note: _noteController.text,
      isImportant: _isImportant,
      unitId: unitId,
    );

    final controller = ref.read(meetingsControllerProvider.notifier);
    try {
      if (widget.meeting != null) {
        await controller.updateMeeting(widget.meeting!.id, draft);
      } else {
        await controller.createMeeting(draft);
      }
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label, style: const TextStyle(fontSize: 12)),
      subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }
}
