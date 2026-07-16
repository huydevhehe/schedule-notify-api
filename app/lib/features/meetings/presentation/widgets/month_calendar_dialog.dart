import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthCalendarDialog extends StatefulWidget {
  const MonthCalendarDialog({super.key, required this.initialDate});

  final DateTime initialDate;

  static Future<DateTime?> show(BuildContext context, DateTime initialDate) {
    return showDialog<DateTime>(
      context: context,
      builder: (_) => MonthCalendarDialog(initialDate: initialDate),
    );
  }

  @override
  State<MonthCalendarDialog> createState() => _MonthCalendarDialogState();
}

class _MonthCalendarDialogState extends State<MonthCalendarDialog> {
  late DateTime _focusedDay = widget.initialDate;
  late DateTime _selectedDay = widget.initialDate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TableCalendar(
          key: const Key('month_calendar'),
          locale: 'vi_VN',
          firstDay: DateTime(2020, 1, 1),
          lastDay: DateTime(2035, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => _isSameDay(day, _selectedDay),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            Navigator.of(context).pop(selectedDay);
          },
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
