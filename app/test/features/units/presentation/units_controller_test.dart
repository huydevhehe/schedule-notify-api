import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/features/units/presentation/units_controller.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('defaults to null when nothing saved', () async {
    final prefs = await SharedPreferences.getInstance();
    final controller = SelectedUnitStore(prefs);
    expect(controller.read(), isNull);
  });

  test('save persists and read returns the saved unit id', () async {
    final prefs = await SharedPreferences.getInstance();
    final controller = SelectedUnitStore(prefs);

    await controller.save(42);

    expect(controller.read(), 42);
  });
}
