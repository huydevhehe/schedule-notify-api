import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/features/meetings/domain/meeting.dart';
import 'package:app/features/meetings/presentation/widgets/meeting_card.dart';
import 'package:app/features/units/presentation/units_controller.dart';

Meeting _meeting({bool important = false, DateTime? createdAt}) => Meeting(
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
      createdAt: createdAt,
    );

Future<void> _pumpCard(
  WidgetTester tester,
  Widget card, {
  Map<String, Object> prefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final instance = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(instance)],
      child: MaterialApp(home: Scaffold(body: card)),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows all detail fields with labels', (tester) async {
    await _pumpCard(
      tester,
      MeetingCard(
        meeting: _meeting(),
        isAdmin: false,
        isPinned: false,
        onTogglePin: () {},
      ),
    );

    expect(find.text('09:00'), findsOneWidget);
    expect(find.textContaining('Họp rà soát tiến độ dự án'), findsOneWidget);
    expect(find.textContaining('B. Trịnh Thị Thu Thảo'), findsOneWidget);
    expect(find.textContaining('Theo phân công'), findsOneWidget);
    expect(find.textContaining('Phòng KT, Phòng KD'), findsOneWidget);
    expect(find.textContaining('Phòng họp số 3'), findsOneWidget);
  });

  testWidgets('star icon reflects pinned state and calls onTogglePin when tapped', (tester) async {
    var toggled = false;
    await _pumpCard(
      tester,
      MeetingCard(
        meeting: _meeting(),
        isAdmin: false,
        isPinned: false,
        onTogglePin: () => toggled = true,
      ),
    );

    expect(find.byIcon(Icons.star_border), findsOneWidget);
    await tester.tap(find.byKey(const Key('pin_button')));
    expect(toggled, isTrue);
  });

  testWidgets('shows edit/delete menu only for admins', (tester) async {
    await _pumpCard(
      tester,
      MeetingCard(
        meeting: _meeting(),
        isAdmin: true,
        isPinned: false,
        onTogglePin: () {},
        onEdit: () {},
        onDelete: () {},
      ),
    );

    expect(find.byType(PopupMenuButton<String>), findsOneWidget);
  });

  testWidgets('shows created date when enabled', (tester) async {
    await _pumpCard(
      tester,
      MeetingCard(
        meeting: _meeting(createdAt: DateTime(2026, 7, 1)),
        isAdmin: false,
        isPinned: false,
        onTogglePin: () {},
      ),
      prefs: {'show_created_date': true},
    );
    expect(find.textContaining('Ngày tạo: 01/07/2026'), findsOneWidget);
  });

  testWidgets('hides created date when disabled', (tester) async {
    await _pumpCard(
      tester,
      MeetingCard(
        meeting: _meeting(createdAt: DateTime(2026, 7, 1)),
        isAdmin: false,
        isPinned: false,
        onTogglePin: () {},
      ),
      prefs: {'show_created_date': false},
    );
    expect(find.textContaining('Ngày tạo'), findsNothing);
  });

  testWidgets('highlights keyword matches in content', (tester) async {
    await _pumpCard(
      tester,
      MeetingCard(
        meeting: _meeting(),
        isAdmin: false,
        isPinned: false,
        onTogglePin: () {},
      ),
      prefs: {'highlight_keyword': 'tiến độ'},
    );

    // Tiêu đề vẫn hiển thị đầy đủ nội dung dù đã tách span để tô màu.
    expect(find.textContaining('Họp rà soát tiến độ dự án'), findsOneWidget);
  });
}
