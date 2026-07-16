import 'dart:async';

import 'package:intl/date_symbol_data_local.dart';

/// Runs once before the whole test suite. Widget tests that build screens
/// depending on `DateFormat(..., 'vi_VN')` (e.g. MeetingsListScreen) need
/// the Vietnamese locale data initialized, which normally happens in
/// `main()` but is never invoked by widget tests.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await initializeDateFormatting('vi_VN');
  await testMain();
}
