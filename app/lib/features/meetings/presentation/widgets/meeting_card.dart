import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/features/meetings/domain/meeting.dart';

class MeetingCard extends StatelessWidget {
  const MeetingCard({
    super.key,
    required this.meeting,
    required this.isAdmin,
    required this.isPinned,
    required this.onTogglePin,
    this.onEdit,
    this.onDelete,
  });

  final Meeting meeting;
  final bool isAdmin;
  final bool isPinned;
  final VoidCallback onTogglePin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent =
        meeting.isImportant ? AppColors.important : Theme.of(context).colorScheme.primary;
    final badgeBg = meeting.isImportant
        ? (isDark ? AppColors.importantBgDark : AppColors.importantBgLight)
        : (isDark ? AppColors.iconBadgeDark : AppColors.iconBadgeLight);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('HH:mm').format(meeting.startTime),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: accent),
                ),
                Row(
                  children: [
                    _IconBadge(icon: Icons.access_time, color: accent, background: badgeBg),
                    const SizedBox(width: 6),
                    _IconBadge(icon: Icons.chat_bubble_outline, color: accent, background: badgeBg),
                    IconButton(
                      key: const Key('pin_button'),
                      icon: Icon(isPinned ? Icons.star : Icons.star_border, color: accent),
                      onPressed: onTogglePin,
                    ),
                    if (isAdmin)
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') onEdit?.call();
                          if (value == 'delete') onDelete?.call();
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Sửa')),
                          PopupMenuItem(value: 'delete', child: Text('Xóa')),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              meeting.title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: accent),
            ),
            const SizedBox(height: 8),
            _Field(label: 'Chủ trì', value: meeting.host),
            _Field(label: 'Chuẩn bị', value: meeting.preparation),
            _Field(label: 'Thành phần', value: meeting.participants),
            _Field(label: 'Địa điểm', value: meeting.location),
            if (meeting.note.isNotEmpty) _Field(label: 'Ghi chú', value: meeting.note),
          ],
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.color, required this.background});

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 13,
      backgroundColor: background,
      child: Icon(icon, size: 14, color: color),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text.rich(
        TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(fontSize: 12.5),
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
