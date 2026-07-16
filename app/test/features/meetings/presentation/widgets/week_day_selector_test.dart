import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:app/features/meetings/presentation/widgets/week_day_selector.dart';

void main() {
  testWidgets('shows all 7 day labels and calls onDateSelected when a day is tapped', (tester) async {
    DateTime? selected;
    final monday = DateTime(2026, 7, 6); // a Monday

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: WeekDaySelector(
            selectedDate: monday,
            onDateSelected: (date) => selected = date,
          ),
        ),
      ),
    );

    expect(find.text('T2'), findsOneWidget);
    expect(find.text('CN'), findsOneWidget);

    final wednesday = monday.add(const Duration(days: 2));
    await tester.tap(find.byKey(Key('day_${DateFormat('yyyy-MM-dd').format(wednesday)}')));
    expect(selected, wednesday);
  });

  testWidgets('next/prev week buttons shift the date by 7 days', (tester) async {
    DateTime? selected;
    final monday = DateTime(2026, 7, 6);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: WeekDaySelector(
            selectedDate: monday,
            onDateSelected: (date) => selected = date,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('next_week_button')));
    expect(selected, monday.add(const Duration(days: 7)));
  });
}
