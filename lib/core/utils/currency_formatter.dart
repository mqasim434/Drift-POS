import 'package:intl/intl.dart';

/// Formats integer paisa values as PKR currency strings.
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _format = NumberFormat.currency(
    locale: 'en_PK',
    symbol: 'Rs ',
    decimalDigits: 0,
  );

  static final NumberFormat _decimalFormat = NumberFormat.currency(
    locale: 'en_PK',
    symbol: 'PKR ',
    decimalDigits: 2,
  );

  static String format(int paisa) {
    return _format.format(paisa / 100);
  }

  static String formatRupees(double rupees) {
    return _decimalFormat.format(rupees);
  }

  static int rupeesToPaisa(double rupees) => (rupees * 100).round();

  static double paisaToRupees(int paisa) => paisa / 100;
}
