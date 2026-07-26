import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesStore extends ChangeNotifier {
  static final FavoritesStore instance = FavoritesStore._internal();
  FavoritesStore._internal();

  static const _key = 'favorites';

  SharedPreferences? _prefs;
  Set<String> _ids = {};

  bool contains(String id) => _ids.contains(id);

  Future<void> load() async {
    _prefs ??= await SharedPreferences.getInstance();
    _ids = (_prefs!.getStringList(_key) ?? []).toSet();
    notifyListeners();
  }

  Future<void> toggle(String id) async {
    if (_ids.contains(id)) {
      _ids.remove(id);
    } else {
      _ids.add(id);
    }
    notifyListeners();
    await _prefs?.setStringList(_key, _ids.toList());
  }
}