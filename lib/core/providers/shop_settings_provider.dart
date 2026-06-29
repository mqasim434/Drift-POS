import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/shop_settings.dart';
import '../services/settings_storage_service.dart';

final shopSettingsProvider = FutureProvider<ShopSettings>((ref) {
  return SettingsStorageService.load();
});

final shopSettingsNotifierProvider =
    AsyncNotifierProvider<ShopSettingsNotifier, ShopSettings>(
  ShopSettingsNotifier.new,
);

class ShopSettingsNotifier extends AsyncNotifier<ShopSettings> {
  @override
  Future<ShopSettings> build() => SettingsStorageService.load();

  ShopSettings get current => state.valueOrNull ?? ShopSettings.defaults;

  Future<void> saveSettings(ShopSettings settings) async {
    await SettingsStorageService.save(settings);
    state = AsyncData(settings);
    ref.invalidate(shopSettingsProvider);
  }

  Future<void> patch(ShopSettings Function(ShopSettings current) update) async {
    await saveSettings(update(current));
  }
}
