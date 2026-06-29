import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_totals.dart';
import '../models/shop_settings.dart';
import '../../features/menu/providers/cart_provider.dart';
import 'shop_settings_provider.dart';

final cartTotalsProvider = Provider<CartTotals>((ref) {
  final cart = ref.watch(cartProvider);
  final settings =
      ref.watch(shopSettingsNotifierProvider).valueOrNull ?? ShopSettings.defaults;
  return CartTotals.fromCart(
    subtotalInPaisa: cart.subtotalInPaisa,
    settings: settings,
  );
});

final currentShopSettingsProvider = Provider<ShopSettings>((ref) {
  return ref.watch(shopSettingsNotifierProvider).valueOrNull ??
      ShopSettings.defaults;
});
