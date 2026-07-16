import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/widgets/gradient_app_bar.dart';

void main() {
  testWidgets('renders title and subtitle', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: GradientAppBar(title: 'Lịch họp', subtitle: 'Thứ sáu, 10/07/2026'),
        ),
      ),
    );

    expect(find.text('Lịch họp'), findsOneWidget);
    expect(find.text('Thứ sáu, 10/07/2026'), findsOneWidget);
  });

  testWidgets('renders without subtitle when none given', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(appBar: GradientAppBar(title: 'Đơn vị')),
      ),
    );

    expect(find.text('Đơn vị'), findsOneWidget);
  });
}
