import 'package:flutter/material.dart';

enum SettingsCategory {
  shopInfo('Shop Info', Icons.store_outlined),
  taxBilling('Tax & Billing', Icons.percent_outlined),
  receipt('Receipt', Icons.receipt_long_outlined),
  printer('Printer', Icons.print_outlined),
  data('Data', Icons.storage_outlined);

  const SettingsCategory(this.label, this.icon);

  final String label;
  final IconData icon;
}
