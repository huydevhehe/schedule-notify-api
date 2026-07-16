import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/meetings/presentation/widgets/month_calendar_dialog.dart';

void main() {
  testWidgets('shows a table calendar dialog', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => MonthCalendarDialog.show(context, DateTime(2026, 7, 10)),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('month_calendar')), findsOneWidget);
  });
}
