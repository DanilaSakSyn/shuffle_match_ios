import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RandomizerFavorites {
  RandomizerFavorites._();

  static final RandomizerFavorites instance = RandomizerFavorites._();

  static const _storageKey = 'liked_randomizers';

  final ValueNotifier<Set<String>> favorites = ValueNotifier(<String>{});

  bool _initialized = false;
  Future<void>? _loading;

  Future<void> ensureLoaded() async {
    if (_initialized) return;
    _loading ??= _load();
    await _loading;
  }

  Future<void> toggle(String id) async {
    await ensureLoaded();
    final updated = Set<String>.from(favorites.value);
    if (!updated.remove(id)) {
      updated.add(id);
    }
    favorites.value = updated;
    await _persist();
  }

  bool isFavorite(String id) {
    return favorites.value.contains(id);
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey);
    if (stored != null) {
      favorites.value = stored.toSet();
    }
    _initialized = true;
    _loading = null;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, favorites.value.toList());
  }
}
