import 'package:intl/intl.dart';

/// Formats integer paisa values as PKR currency strings.
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _format = NumberFormat.currency(
    locale: 'en_PK',
    symbol: 'Rs ',
    decimalDigits: 0,
  );

  static String format(int paisa) {
    return _format.format(paisa / 100);
  }
}
