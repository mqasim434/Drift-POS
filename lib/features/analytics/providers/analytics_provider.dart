import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/analytics_date_range.dart';
import '../../../core/models/analytics_models.dart';
import '../../../core/providers/database_provider.dart';

class AnalyticsSnapshot {
  const AnalyticsSnapshot({
    required this.dailySummaries,
    required this.topByQuantity,
    required this.topByRevenue,
    required this.weeklyTrend,
  });

  final List<DailyAnalyticsSummary> dailySummaries;
  final List<ProductSalesCount> topByQuantity;
  final List<ProductSalesCount> topByRevenue;
  final List<WeeklyOrderTypeStats> weeklyTrend;
}

final analyticsRangeProvider =
    StateProvider<AnalyticsDateRange>((ref) => AnalyticsDateRange.last30Days());

final analyticsDataProvider =
    FutureProvider.autoDispose<AnalyticsSnapshot>((ref) async {
  final range = ref.watch(analyticsRangeProvider);
  final db = ref.read(databaseProvider);

  final summaries = await db.ordersDao.getDailyAnalyticsSummary(
    range.from,
    range.to,
  );
  final topByQuantity = await db.ordersDao.getTopProducts(
    range.from,
    range.to,
    limit: 10,
  );
  final topByRevenue = await db.ordersDao.getTopProductsByRevenue(
    range.from,
    range.to,
    limit: 10,
  );
  final weeklyTrend = await db.ordersDao.getWeeklyOrderTypeTrend(
    range.from,
    range.to,
  );

  return AnalyticsSnapshot(
    dailySummaries: _fillMissingDays(summaries, range.from, range.to),
    topByQuantity: topByQuantity,
    topByRevenue: topByRevenue,
    weeklyTrend: weeklyTrend,
  );
});

List<DailyAnalyticsSummary> _fillMissingDays(
  List<DailyAnalyticsSummary> summaries,
  DateTime from,
  DateTime to,
) {
  final byDay = {
    for (final summary in summaries)
      _dayKey(summary.date): summary,
  };

  final filled = <DailyAnalyticsSummary>[];
  for (var day = from; day.isBefore(to); day = day.add(const Duration(days: 1))) {
    filled.add(byDay[_dayKey(day)] ?? DailyAnalyticsSummary.empty(day));
  }
  return filled;
}

String _dayKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

void setAnalyticsPreset(WidgetRef ref, AnalyticsRangePreset preset) {
  ref.read(analyticsRangeProvider.notifier).state = switch (preset) {
    AnalyticsRangePreset.last7Days => AnalyticsDateRange.last7Days(),
    AnalyticsRangePreset.last30Days => AnalyticsDateRange.last30Days(),
    AnalyticsRangePreset.last90Days => AnalyticsDateRange.last90Days(),
    AnalyticsRangePreset.thisMonth => AnalyticsDateRange.thisMonth(),
    AnalyticsRangePreset.lastMonth => AnalyticsDateRange.lastMonth(),
    AnalyticsRangePreset.custom => ref.read(analyticsRangeProvider),
  };
}

void setAnalyticsCustomRange(WidgetRef ref, DateTime from, DateTime to) {
  ref.read(analyticsRangeProvider.notifier).state =
      AnalyticsDateRange.custom(from, to);
}
