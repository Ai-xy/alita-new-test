library local_storge;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_storage_key.dart';

abstract class AppLocalStorage {
  static late SharedPreferences _prefs;

  static Future<void> init() {
    return SharedPreferences.getInstance().then((value) {
      _prefs = value;
    }).catchError((err, s) {});
  }

  static Future<void> remove(AppStorageKey key) => _prefs.remove(key.name);

  static String? getString(AppStorageKey key) => _prefs.getString(key.name);

  static Future<bool> setString(AppStorageKey key, String data) =>
      _prefs.setString(key.name, data);

  static Map? getJson(AppStorageKey key) {
    final String? jsonString = _prefs.getString(key.name);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }

  static Future<bool> setJson(AppStorageKey key, Map data) =>
      _prefs.setString(key.name, jsonEncode(data));

  static Future<bool> setBool(AppStorageKey key, bool value) =>
      _prefs.setBool(key.name, value);
  static Future<bool> setInt(AppStorageKey key, int value) =>
      _prefs.setInt(key.name, value);

  static bool getBool(AppStorageKey key) {
    return _prefs.getBool(key.name) ?? false;
  }

  static int getInt(AppStorageKey key) {
    return _prefs.getInt(key.name) ?? -1;
  }

  static bool get hasLogin =>
      AppLocalStorage.getString(AppStorageKey.token)?.isNotEmpty ?? false;
}
