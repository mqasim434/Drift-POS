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
      final settings = ShopSettings.fromJson(json);
      final migrated = _migrateLegacyDefaults(settings);
      if (migrated != settings) {
        await save(migrated);
      }
      return migrated;
    } catch (_) {
      return ShopSettings.defaults;
    }
  }

  /// Applies City Pizza branding when settings were never customized.
  static ShopSettings _migrateLegacyDefaults(ShopSettings settings) {
    final isLegacyShop = settings.shopName == 'DriftPOS' ||
        settings.shopName == 'QuickPOS';
    final hasNoContactInfo =
        settings.address.trim().isEmpty && settings.phone.trim().isEmpty;

    if (!isLegacyShop || !hasNoContactInfo) return settings;

    return settings.copyWith(
      shopName: ShopSettings.defaults.shopName,
      address: ShopSettings.defaults.address,
      phone: ShopSettings.defaults.phone,
      thankYouMessage: ShopSettings.defaults.thankYouMessage,
    );
  }

  static Future<void> save(ShopSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }
}
