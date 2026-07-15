import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/features/auth/presentation/auth_controller.dart';

class SelectedUnitStore {
  SelectedUnitStore(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'selected_unit_id';

  int? read() => _prefs.getInt(_key);

  Future<void> save(int unitId) => _prefs.setInt(_key, unitId);
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('overridden in main.dart via ProviderScope.overrides');
});

final selectedUnitIdProvider = NotifierProvider<SelectedUnitController, int?>(
  SelectedUnitController.new,
);

class SelectedUnitController extends Notifier<int?> {
  @override
  int? build() {
    final user = ref.watch(authControllerProvider).value;
    final store = SelectedUnitStore(ref.watch(sharedPreferencesProvider));
    final saved = store.read();
    if (user == null || user.units.isEmpty) return null;
    final isSavedValid = user.units.any((u) => u.id == saved);
    return isSavedValid ? saved : user.units.first.id;
  }

  void select(int unitId) {
    SelectedUnitStore(ref.read(sharedPreferencesProvider)).save(unitId);
    state = unitId;
  }
}
