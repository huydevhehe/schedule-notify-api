import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/app_shell.dart';

void main() {
  testWidgets('shows 4 bottom nav destinations and switches tabs', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: AppShell())),
    );

    expect(find.text('Lịch họp'), findsWidgets);
    expect(find.text('Đơn vị'), findsWidgets);
    expect(find.text('Cài đặt'), findsWidgets);
    expect(find.text('Thông tin'), findsWidgets);

    await tester.tap(find.text('Cài đặt').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('settings_screen')), findsOneWidget);
  });
}
