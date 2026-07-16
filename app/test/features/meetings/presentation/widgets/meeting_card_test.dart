import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/meetings/domain/meeting.dart';
import 'package:app/features/meetings/presentation/widgets/meeting_card.dart';

Meeting _meeting({bool important = false}) => Meeting(
      id: 1,
      title: 'Họp rà soát tiến độ dự án',
      startTime: DateTime(2026, 7, 10, 9, 0),
      endTime: DateTime(2026, 7, 10, 10, 0),
      host: 'B. Trịnh Thị Thu Thảo',
      preparation: 'Theo phân công',
      participants: 'Phòng KT, Phòng KD',
      location: 'Phòng họp số 3',
      note: '',
      isImportant: important,
      unitId: 1,
    );

void main() {
  testWidgets('shows all detail fields with labels', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MeetingCard(
            meeting: _meeting(),
            isAdmin: false,
            isPinned: false,
            onTogglePin: () {},
          ),
        ),
      ),
    );

    expect(find.text('09:00'), findsOneWidget);
    expect(find.text('Họp rà soát tiến độ dự án'), findsOneWidget);
    expect(find.textContaining('B. Trịnh Thị Thu Thảo'), findsOneWidget);
    expect(find.textContaining('Theo phân công'), findsOneWidget);
    expect(find.textContaining('Phòng KT, Phòng KD'), findsOneWidget);
    expect(find.textContaining('Phòng họp số 3'), findsOneWidget);
  });

  testWidgets('star icon reflects pinned state and calls onTogglePin when tapped', (tester) async {
    var toggled = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MeetingCard(
            meeting: _meeting(),
            isAdmin: false,
            isPinned: false,
            onTogglePin: () => toggled = true,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.star_border), findsOneWidget);
    await tester.tap(find.byKey(const Key('pin_button')));
    expect(toggled, isTrue);
  });

  testWidgets('shows edit/delete menu only for admins', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MeetingCard(
            meeting: _meeting(),
            isAdmin: true,
            isPinned: false,
            onTogglePin: () {},
            onEdit: () {},
            onDelete: () {},
          ),
        ),
      ),
    );

    expect(find.byType(PopupMenuButton<String>), findsOneWidget);
  });
}
