import 'package:intl/intl.dart';

class OrderNumberGenerator {
  OrderNumberGenerator._();

  static String generate(int dailyCount) {
    final now = DateTime.now();
    final date = DateFormat('yyyyMMdd').format(now);
    final seq = (dailyCount + 1).toString().padLeft(3, '0');
    return 'ORD-$date-$seq';
  }
}
