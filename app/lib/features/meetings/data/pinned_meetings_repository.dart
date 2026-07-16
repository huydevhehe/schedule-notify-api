import 'package:shared_preferences/shared_preferences.dart';

class PinnedMeetingsRepository {
  PinnedMeetingsRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'pinned_meeting_ids';

  Set<int> readAll() {
    final stored = _prefs.getStringList(_key) ?? const [];
    return stored.map(int.parse).toSet();
  }

  Future<void> saveAll(Set<int> ids) {
    return _prefs.setStringList(_key, ids.map((id) => id.toString()).toList());
  }
}
