import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_vision_journal/core/settings/settings_repository.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SettingsRepository settingsRepository;

  ThemeCubit(this.settingsRepository) : super(ThemeMode.light);

  Future<void> loadTheme() async {
    final isDark = await settingsRepository.isDarkMode();
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await settingsRepository.setDarkMode(next == ThemeMode.dark);
    emit(next);
  }
}
