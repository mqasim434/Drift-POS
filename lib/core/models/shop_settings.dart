class ShopSettings {
  const ShopSettings({
    required this.shopName,
    required this.address,
    required this.phone,
    required this.currencySymbol,
    required this.taxRatePercent,
    required this.taxLabel,
    required this.includeTaxInPriceDisplay,
    required this.autoPrintAfterOrder,
    required this.thankYouMessage,
    required this.showOrderTypeOnReceipt,
    required this.showTableOnReceipt,
    this.defaultPrinterUrl,
  });

  final String shopName;
  final String address;
  final String phone;
  final String currencySymbol;
  final double taxRatePercent;
  final String taxLabel;
  final bool includeTaxInPriceDisplay;
  final bool autoPrintAfterOrder;
  final String thankYouMessage;
  final bool showOrderTypeOnReceipt;
  final bool showTableOnReceipt;
  final String? defaultPrinterUrl;

  static const defaults = ShopSettings(
    shopName: 'DriftPOS',
    address: '',
    phone: '',
    currencySymbol: 'PKR',
    taxRatePercent: 0,
    taxLabel: 'Tax',
    includeTaxInPriceDisplay: false,
    autoPrintAfterOrder: false,
    thankYouMessage: 'Thank you! Visit again',
    showOrderTypeOnReceipt: true,
    showTableOnReceipt: true,
    defaultPrinterUrl: null,
  );

  ShopSettings copyWith({
    String? shopName,
    String? address,
    String? phone,
    String? currencySymbol,
    double? taxRatePercent,
    String? taxLabel,
    bool? includeTaxInPriceDisplay,
    bool? autoPrintAfterOrder,
    String? thankYouMessage,
    bool? showOrderTypeOnReceipt,
    bool? showTableOnReceipt,
    String? defaultPrinterUrl,
    bool clearDefaultPrinterUrl = false,
  }) {
    return ShopSettings(
      shopName: shopName ?? this.shopName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      taxRatePercent: taxRatePercent ?? this.taxRatePercent,
      taxLabel: taxLabel ?? this.taxLabel,
      includeTaxInPriceDisplay:
          includeTaxInPriceDisplay ?? this.includeTaxInPriceDisplay,
      autoPrintAfterOrder: autoPrintAfterOrder ?? this.autoPrintAfterOrder,
      thankYouMessage: thankYouMessage ?? this.thankYouMessage,
      showOrderTypeOnReceipt:
          showOrderTypeOnReceipt ?? this.showOrderTypeOnReceipt,
      showTableOnReceipt: showTableOnReceipt ?? this.showTableOnReceipt,
      defaultPrinterUrl: clearDefaultPrinterUrl
          ? null
          : (defaultPrinterUrl ?? this.defaultPrinterUrl),
    );
  }

  Map<String, dynamic> toJson() => {
        'shopName': shopName,
        'address': address,
        'phone': phone,
        'currencySymbol': currencySymbol,
        'taxRatePercent': taxRatePercent,
        'taxLabel': taxLabel,
        'includeTaxInPriceDisplay': includeTaxInPriceDisplay,
        'autoPrintAfterOrder': autoPrintAfterOrder,
        'thankYouMessage': thankYouMessage,
        'showOrderTypeOnReceipt': showOrderTypeOnReceipt,
        'showTableOnReceipt': showTableOnReceipt,
        'defaultPrinterUrl': defaultPrinterUrl,
      };

  factory ShopSettings.fromJson(Map<String, dynamic> json) {
    return ShopSettings(
      shopName: json['shopName'] as String? ?? defaults.shopName,
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      currencySymbol: json['currencySymbol'] as String? ?? 'PKR',
      taxRatePercent: (json['taxRatePercent'] as num?)?.toDouble() ?? 0,
      taxLabel: json['taxLabel'] as String? ?? 'Tax',
      includeTaxInPriceDisplay:
          json['includeTaxInPriceDisplay'] as bool? ?? false,
      autoPrintAfterOrder: json['autoPrintAfterOrder'] as bool? ?? false,
      thankYouMessage:
          json['thankYouMessage'] as String? ?? defaults.thankYouMessage,
      showOrderTypeOnReceipt: json['showOrderTypeOnReceipt'] as bool? ?? true,
      showTableOnReceipt: json['showTableOnReceipt'] as bool? ?? true,
      defaultPrinterUrl: json['defaultPrinterUrl'] as String?,
    );
  }
}
