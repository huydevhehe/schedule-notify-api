import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/settings/data/settings_repository.dart';
import 'package:app/features/units/presentation/units_controller.dart';

class SettingsState {
  const SettingsState({
    required this.fontSize,
    required this.highlightKeyword,
    required this.themeMode,
    required this.showCreatedDate,
  });
  final FontSizeOption fontSize;
  final String highlightKeyword;
  final ThemeMode themeMode;
  final bool showCreatedDate;

  SettingsState copyWith({
    FontSizeOption? fontSize,
    String? highlightKeyword,
    ThemeMode? themeMode,
    bool? showCreatedDate,
  }) {
    return SettingsState(
      fontSize: fontSize ?? this.fontSize,
      highlightKeyword: highlightKeyword ?? this.highlightKeyword,
      themeMode: themeMode ?? this.themeMode,
      showCreatedDate: showCreatedDate ?? this.showCreatedDate,
    );
  }
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
      showCreatedDate: _repo.readShowCreatedDate(),
    );
  }

  Future<void> setFontSize(FontSizeOption option) async {
    await _repo.saveFontSize(option);
    state = state.copyWith(fontSize: option);
  }

  Future<void> setHighlightKeyword(String keyword) async {
    await _repo.saveHighlightKeyword(keyword);
    state = state.copyWith(highlightKeyword: keyword);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _repo.saveThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setShowCreatedDate(bool value) async {
    await _repo.saveShowCreatedDate(value);
    state = state.copyWith(showCreatedDate: value);
  }
}
