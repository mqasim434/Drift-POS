import 'package:intl/intl.dart';

/// Shared date/time formatting helpers.
class DateFormatter {
  DateFormatter._();

  static final DateFormat _date = DateFormat('dd MMM yyyy');
  static final DateFormat _time = DateFormat('hh:mm a');
  static final DateFormat _dateTime = DateFormat('dd MMM yyyy, hh:mm a');

  static String formatDate(DateTime date) => _date.format(date);

  static String formatTime(DateTime date) => _time.format(date);

  static String formatDateTime(DateTime date) => _dateTime.format(date);
}
