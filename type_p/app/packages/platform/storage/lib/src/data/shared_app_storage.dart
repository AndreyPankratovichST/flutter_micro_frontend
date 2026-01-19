import 'dart:convert';

import 'package:core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SharedAppStorage implements AppStorage {
  final SharedPreferences _preferences;

  SharedAppStorage(this._preferences);

  @override
  Future<void> clear() async {
    await _preferences.clear();
  }

  @override
  Future<void> delete(String key) async {
    await _preferences.remove(key);
  }

  @override
  Future<T?> get<T>(String key) async {
    final value = _preferences.getString(key);
    if (value == null) {
      return null;
    }
    return jsonDecode(value);
  }

  @override
  Future<void> set<T>(String key, T value) async {
    final encode = jsonEncode(value);
    _preferences.setString(key, encode);
  }
}
