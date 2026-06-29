import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/dashboard_stats.dart';
import '../../../core/providers/database_provider.dart';

final dashboardStatsProvider =
    AsyncNotifierProvider.autoDispose<DashboardStatsNotifier, DashboardStats>(
  DashboardStatsNotifier.new,
);

class DashboardStatsNotifier extends AutoDisposeAsyncNotifier<DashboardStats> {
  @override
  Future<DashboardStats> build() async {
    return ref.read(databaseProvider).ordersDao.getTodayStats(DateTime.now());
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(
      await ref.read(databaseProvider).ordersDao.getTodayStats(DateTime.now()),
    );
  }
}
