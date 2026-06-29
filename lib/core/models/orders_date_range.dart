enum QuickFilter {
  today,
  yesterday,
  thisWeek,
  thisMonth,
  custom,
}

class OrdersDateRange {
  const OrdersDateRange({
    required this.from,
    required this.to,
    this.quickFilter = QuickFilter.today,
  });

  final DateTime from;
  final DateTime to;
  final QuickFilter quickFilter;

  static DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static OrdersDateRange today() {
    final start = _startOfDay(DateTime.now());
    return OrdersDateRange(
      from: start,
      to: start.add(const Duration(days: 1)),
      quickFilter: QuickFilter.today,
    );
  }

  static OrdersDateRange yesterday() {
    final start = _startOfDay(DateTime.now().subtract(const Duration(days: 1)));
    return OrdersDateRange(
      from: start,
      to: start.add(const Duration(days: 1)),
      quickFilter: QuickFilter.yesterday,
    );
  }

  static OrdersDateRange thisWeek() {
    final now = DateTime.now();
    final start = _startOfDay(now.subtract(Duration(days: now.weekday - 1)));
    return OrdersDateRange(
      from: start,
      to: _startOfDay(now).add(const Duration(days: 1)),
      quickFilter: QuickFilter.thisWeek,
    );
  }

  static OrdersDateRange thisMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month);
    return OrdersDateRange(
      from: start,
      to: _startOfDay(now).add(const Duration(days: 1)),
      quickFilter: QuickFilter.thisMonth,
    );
  }

  static OrdersDateRange custom(DateTime from, DateTime to) {
    final start = _startOfDay(from);
    final end = _startOfDay(to).add(const Duration(days: 1));
    return OrdersDateRange(
      from: start,
      to: end,
      quickFilter: QuickFilter.custom,
    );
  }

  String get label => switch (quickFilter) {
        QuickFilter.today => 'Today',
        QuickFilter.yesterday => 'Yesterday',
        QuickFilter.thisWeek => 'This Week',
        QuickFilter.thisMonth => 'This Month',
        QuickFilter.custom => 'Custom',
      };
}
