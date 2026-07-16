import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/core/theme/app_theme.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('light and dark themes have distinct, correctly-branded colors', (WidgetTester tester) async {
    final light = AppTheme.light();
    final dark = AppTheme.dark();

    expect(light.brightness, Brightness.light);
    expect(dark.brightness, Brightness.dark);
    expect(light.scaffoldBackgroundColor, isNot(dark.scaffoldBackgroundColor));
    expect(light.colorScheme.primary, isNot(equals(Colors.blue)));
  });
}
