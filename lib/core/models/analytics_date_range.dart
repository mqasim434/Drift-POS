enum AnalyticsRangePreset {
  last7Days,
  last30Days,
  last90Days,
  thisMonth,
  lastMonth,
  custom,
}

class AnalyticsDateRange {
  const AnalyticsDateRange({
    required this.from,
    required this.to,
    required this.preset,
  });

  final DateTime from;
  final DateTime to;
  final AnalyticsRangePreset preset;

  static DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static AnalyticsDateRange last7Days() {
    final end = _startOfDay(DateTime.now()).add(const Duration(days: 1));
    return AnalyticsDateRange(
      from: end.subtract(const Duration(days: 7)),
      to: end,
      preset: AnalyticsRangePreset.last7Days,
    );
  }

  static AnalyticsDateRange last30Days() {
    final end = _startOfDay(DateTime.now()).add(const Duration(days: 1));
    return AnalyticsDateRange(
      from: end.subtract(const Duration(days: 30)),
      to: end,
      preset: AnalyticsRangePreset.last30Days,
    );
  }

  static AnalyticsDateRange last90Days() {
    final end = _startOfDay(DateTime.now()).add(const Duration(days: 1));
    return AnalyticsDateRange(
      from: end.subtract(const Duration(days: 90)),
      to: end,
      preset: AnalyticsRangePreset.last90Days,
    );
  }

  static AnalyticsDateRange thisMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month);
    final end = _startOfDay(now).add(const Duration(days: 1));
    return AnalyticsDateRange(
      from: start,
      to: end,
      preset: AnalyticsRangePreset.thisMonth,
    );
  }

  static AnalyticsDateRange lastMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 1);
    final end = DateTime(now.year, now.month);
    return AnalyticsDateRange(
      from: start,
      to: end,
      preset: AnalyticsRangePreset.lastMonth,
    );
  }

  static AnalyticsDateRange custom(DateTime from, DateTime to) {
    final start = _startOfDay(from);
    final end = _startOfDay(to).add(const Duration(days: 1));
    return AnalyticsDateRange(
      from: start,
      to: end,
      preset: AnalyticsRangePreset.custom,
    );
  }

  int get dayCount => to.difference(from).inDays;

  String get label => switch (preset) {
        AnalyticsRangePreset.last7Days => 'Last 7 days',
        AnalyticsRangePreset.last30Days => 'Last 30 days',
        AnalyticsRangePreset.last90Days => 'Last 90 days',
        AnalyticsRangePreset.thisMonth => 'This month',
        AnalyticsRangePreset.lastMonth => 'Last month',
        AnalyticsRangePreset.custom => 'Custom range',
      };
}
