import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/shop_settings.dart';

class SettingsStorageService {
  SettingsStorageService._();

  static const _settingsKey = 'shop_settings_json';

  static Future<ShopSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_settingsKey);
    if (raw == null || raw.isEmpty) return ShopSettings.defaults;

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return ShopSettings.fromJson(json);
    } catch (_) {
      return ShopSettings.defaults;
    }
  }

  static Future<void> save(ShopSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }
}
