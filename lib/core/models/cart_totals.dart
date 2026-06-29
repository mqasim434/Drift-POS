import '../models/shop_settings.dart';

class CartTotals {
  const CartTotals({
    required this.subtotalInPaisa,
    required this.taxInPaisa,
    required this.totalInPaisa,
    required this.taxRatePercent,
    required this.taxLabel,
  });

  final int subtotalInPaisa;
  final int taxInPaisa;
  final int totalInPaisa;
  final double taxRatePercent;
  final String taxLabel;

  factory CartTotals.fromCart({
    required int subtotalInPaisa,
    required ShopSettings settings,
  }) {
    final taxInPaisa =
        (subtotalInPaisa * settings.taxRateFraction).round();
    return CartTotals(
      subtotalInPaisa: subtotalInPaisa,
      taxInPaisa: taxInPaisa,
      totalInPaisa: subtotalInPaisa + taxInPaisa,
      taxRatePercent: settings.taxRatePercent,
      taxLabel: settings.taxLabel,
    );
  }
}

extension ShopSettingsPricing on ShopSettings {
  double get taxRateFraction => taxRatePercent / 100;

  int priceWithOptionalTax(int basePaisa) {
    if (!includeTaxInPriceDisplay || taxRatePercent <= 0) return basePaisa;
    return (basePaisa * (1 + taxRateFraction)).round();
  }
}
