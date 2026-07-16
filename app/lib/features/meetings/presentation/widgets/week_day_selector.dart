import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/core/theme/app_colors.dart';

class WeekDaySelector extends StatelessWidget implements PreferredSizeWidget {
  const WeekDaySelector({super.key, required this.selectedDate, required this.onDateSelected});

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  static const _dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  Widget build(BuildContext context) {
    final weekStart = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    final today = DateTime.now();

    return Container(
      color: AppColors.primaryDark,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          IconButton(
            key: const Key('prev_week_button'),
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () => onDateSelected(selectedDate.subtract(const Duration(days: 7))),
          ),
          Expanded(
            child: Row(
              children: List.generate(7, (i) {
                final day = weekStart.add(Duration(days: i));
                final isSelected = _isSameDay(day, selectedDate);
                final isToday = _isSameDay(day, today);
                return Expanded(
                  child: GestureDetector(
                    key: Key('day_${DateFormat('yyyy-MM-dd').format(day)}'),
                    onTap: () => onDateSelected(day),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white.withValues(alpha: 0.25) : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _dayLabels[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: (isSelected || isToday) ? 1 : 0.85),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          IconButton(
            key: const Key('next_week_button'),
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: () => onDateSelected(selectedDate.add(const Duration(days: 7))),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
