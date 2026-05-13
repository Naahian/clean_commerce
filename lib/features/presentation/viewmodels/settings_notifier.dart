import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/core/injection.dart';
import 'package:clean_commerce/core/services/localstorage_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// State class
class AppSettingsState {
  final bool isDark;
  final String currency;
  final bool isFirstLaunch;

  const AppSettingsState({
    required this.isDark,
    required this.currency,
    required this.isFirstLaunch,
  });

  AppSettingsState copyWith({
    bool? isDark,
    String? currency,
    bool? isFirstLaunch,
  }) {
    return AppSettingsState(
      isDark: isDark ?? this.isDark,
      currency: currency ?? this.currency,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
    );
  }
}

final localStorageProvider = Provider<LocalStorageService>(
  (_) => getIt<LocalStorageService>(),
);

// Notifier class
class AppSettingsNotifier extends Notifier<AppSettingsState> {
  late final LocalStorageService _local;

  @override
  AppSettingsState build() {
    // Access dependencies from ref or getIt
    _local = ref.read(localStorageProvider);

    return AppSettingsState(
      isDark: _local.isDark(),
      currency: _local.getCurrency(),
      isFirstLaunch: _local.isFirstTime(),
    );
  }

  String getCurrencyChar() {
    switch (state.currency) {
      case "BDT":
        return '৳';
      case "USD":
        return '\$';
      default:
        return '\$';
    }
  }

  Future<void> setDark(bool value) async {
    if (state.isDark == value) return;
    await _local.setDark(value);
    state = state.copyWith(isDark: value);
  }

  Future<void> setCurrency(String currency) async {
    if (state.currency == currency) return;

    await _local.setCurrency(currency);
    state = state.copyWith(currency: currency);
  }

  Future<void> setFirstLaunch(bool value) async {
    if (state.isFirstLaunch == value) return;
    await _local.setFirstTime(value);
    state = state.copyWith(isFirstLaunch: value);
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    await setDark(!state.isDark);
  }
}

// Provider
final settingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettingsState>(
      () => AppSettingsNotifier(),
    );
