import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  AppSettings._();

  static final AppSettings instance = AppSettings._();

  static const _soundsEnabledKey = 'sounds_enabled';
  static const _hapticsEnabledKey = 'haptics_enabled';

  final ValueNotifier<bool> soundsEnabled = ValueNotifier(true);
  final ValueNotifier<bool> hapticsEnabled = ValueNotifier(true);

  bool _initialized = false;
  Future<void>? _loading;

  Future<void> ensureLoaded() async {
    if (_initialized) return;
    _loading ??= _load();
    await _loading;
  }

  Future<void> setSoundsEnabled(bool enabled) async {
    await ensureLoaded();
    soundsEnabled.value = enabled;
    await _persist();
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    await ensureLoaded();
    hapticsEnabled.value = enabled;
    await _persist();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    soundsEnabled.value = prefs.getBool(_soundsEnabledKey) ?? true;
    hapticsEnabled.value = prefs.getBool(_hapticsEnabledKey) ?? true;
    _initialized = true;
    _loading = null;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundsEnabledKey, soundsEnabled.value);
    await prefs.setBool(_hapticsEnabledKey, hapticsEnabled.value);
  }
}

