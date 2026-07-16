import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/settings/data/settings_repository.dart';
import 'package:app/features/units/presentation/units_controller.dart';

class SettingsState {
  const SettingsState({
    required this.fontSize,
    required this.highlightKeyword,
    required this.themeMode,
  });
  final FontSizeOption fontSize;
  final String highlightKeyword;
  final ThemeMode themeMode;
}

final settingsControllerProvider =
    NotifierProvider<SettingsController, SettingsState>(SettingsController.new);

class SettingsController extends Notifier<SettingsState> {
  late final SettingsRepository _repo = SettingsRepository(ref.read(sharedPreferencesProvider));

  @override
  SettingsState build() {
    return SettingsState(
      fontSize: _repo.readFontSize(),
      highlightKeyword: _repo.readHighlightKeyword(),
      themeMode: _repo.readThemeMode(),
    );
  }

  Future<void> setFontSize(FontSizeOption option) async {
    await _repo.saveFontSize(option);
    state = SettingsState(
      fontSize: option,
      highlightKeyword: state.highlightKeyword,
      themeMode: state.themeMode,
    );
  }

  Future<void> setHighlightKeyword(String keyword) async {
    await _repo.saveHighlightKeyword(keyword);
    state = SettingsState(
      fontSize: state.fontSize,
      highlightKeyword: keyword,
      themeMode: state.themeMode,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _repo.saveThemeMode(mode);
    state = SettingsState(
      fontSize: state.fontSize,
      highlightKeyword: state.highlightKeyword,
      themeMode: mode,
    );
  }
}
