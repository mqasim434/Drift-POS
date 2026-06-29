class ShopSettings {
  const ShopSettings({
    required this.shopName,
    required this.address,
    required this.phone,
    required this.currencySymbol,
    required this.taxRatePercent,
    required this.taxLabel,
    required this.autoPrintAfterOrder,
    required this.thankYouMessage,
    required this.showOrderTypeOnReceipt,
    required this.showTableOnReceipt,
  });

  final String shopName;
  final String address;
  final String phone;
  final String currencySymbol;
  final double taxRatePercent;
  final String taxLabel;
  final bool autoPrintAfterOrder;
  final String thankYouMessage;
  final bool showOrderTypeOnReceipt;
  final bool showTableOnReceipt;

  static const defaults = ShopSettings(
    shopName: 'QuickPOS',
    address: '',
    phone: '',
    currencySymbol: 'PKR',
    taxRatePercent: 0,
    taxLabel: 'Tax',
    autoPrintAfterOrder: false,
    thankYouMessage: 'Thank you! Visit again',
    showOrderTypeOnReceipt: true,
    showTableOnReceipt: true,
  );

  ShopSettings copyWith({
    String? shopName,
    String? address,
    String? phone,
    String? currencySymbol,
    double? taxRatePercent,
    String? taxLabel,
    bool? autoPrintAfterOrder,
    String? thankYouMessage,
    bool? showOrderTypeOnReceipt,
    bool? showTableOnReceipt,
  }) {
    return ShopSettings(
      shopName: shopName ?? this.shopName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      taxRatePercent: taxRatePercent ?? this.taxRatePercent,
      taxLabel: taxLabel ?? this.taxLabel,
      autoPrintAfterOrder: autoPrintAfterOrder ?? this.autoPrintAfterOrder,
      thankYouMessage: thankYouMessage ?? this.thankYouMessage,
      showOrderTypeOnReceipt:
          showOrderTypeOnReceipt ?? this.showOrderTypeOnReceipt,
      showTableOnReceipt: showTableOnReceipt ?? this.showTableOnReceipt,
    );
  }

  Map<String, dynamic> toJson() => {
        'shopName': shopName,
        'address': address,
        'phone': phone,
        'currencySymbol': currencySymbol,
        'taxRatePercent': taxRatePercent,
        'taxLabel': taxLabel,
        'autoPrintAfterOrder': autoPrintAfterOrder,
        'thankYouMessage': thankYouMessage,
        'showOrderTypeOnReceipt': showOrderTypeOnReceipt,
        'showTableOnReceipt': showTableOnReceipt,
      };

  factory ShopSettings.fromJson(Map<String, dynamic> json) {
    return ShopSettings(
      shopName: json['shopName'] as String? ?? defaults.shopName,
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      currencySymbol: json['currencySymbol'] as String? ?? 'PKR',
      taxRatePercent: (json['taxRatePercent'] as num?)?.toDouble() ?? 0,
      taxLabel: json['taxLabel'] as String? ?? 'Tax',
      autoPrintAfterOrder: json['autoPrintAfterOrder'] as bool? ?? false,
      thankYouMessage:
          json['thankYouMessage'] as String? ?? defaults.thankYouMessage,
      showOrderTypeOnReceipt: json['showOrderTypeOnReceipt'] as bool? ?? true,
      showTableOnReceipt: json['showTableOnReceipt'] as bool? ?? true,
    );
  }
}
