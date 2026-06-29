import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/models/order_models.dart';
import '../../../core/models/orders_date_range.dart';
import '../../../core/providers/database_provider.dart';

Future<OrderWithItems?> loadOrderWithItems(AppDatabase db, int orderId) async {
  final order = await db.ordersDao.getOrderById(orderId);
  if (order == null) return null;

  final items = await db.ordersDao.getItemsForOrder(orderId);
  String? tableName;
  if (order.tableId != null) {
    final tables = await db.tablesDao.watchAllTables().first;
    tableName = tables
        .where((table) => table.id == order.tableId)
        .map((table) => table.name)
        .firstOrNull;
  }

  return OrderWithItems(order: order, items: items, tableName: tableName);
}

final ordersFilterProvider =
    StateProvider<OrdersDateRange>((ref) => OrdersDateRange.today());

final selectedOrderIdProvider = StateProvider<int?>((ref) => null);

final filteredOrdersProvider = StreamProvider<List<OrderSummary>>((ref) async* {
  final range = ref.watch(ordersFilterProvider);
  final db = ref.watch(databaseProvider);

  await for (final orders
      in db.ordersDao.watchOrdersByDateRange(range.from, range.to)) {
    final counts = await db.ordersDao.getItemCountsForOrders(
      orders.map((order) => order.id).toList(),
    );
    yield orders
        .map(
          (order) => OrderSummary(
            order: order,
            itemCount: counts[order.id] ?? 0,
          ),
        )
        .toList();
  }
});

final ordersStatsProvider = Provider<OrdersStats>((ref) {
  final ordersAsync = ref.watch(filteredOrdersProvider);
  return ordersAsync.maybeWhen(
    data: (orders) => OrdersStats.fromOrders(orders.map((o) => o.order).toList()),
    orElse: () => const OrdersStats.empty(),
  );
});

final selectedOrderProvider = FutureProvider<OrderWithItems?>((ref) async {
  final orderId = ref.watch(selectedOrderIdProvider);
  if (orderId == null) return null;

  final db = ref.watch(databaseProvider);
  return loadOrderWithItems(db, orderId);
});

final ordersNotifierProvider =
    AsyncNotifierProvider<OrdersNotifier, void>(OrdersNotifier.new);

class OrdersNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> cancelOrder(int id) async {
    await ref.read(databaseProvider).ordersDao.cancelOrder(id);
  }
}

void setOrdersQuickFilter(WidgetRef ref, QuickFilter filter) {
  ref.read(selectedOrderIdProvider.notifier).state = null;
  ref.read(ordersFilterProvider.notifier).state = switch (filter) {
    QuickFilter.today => OrdersDateRange.today(),
    QuickFilter.yesterday => OrdersDateRange.yesterday(),
    QuickFilter.thisWeek => OrdersDateRange.thisWeek(),
    QuickFilter.thisMonth => OrdersDateRange.thisMonth(),
    QuickFilter.custom => ref.read(ordersFilterProvider),
  };
}

void setOrdersCustomRange(WidgetRef ref, DateTime from, DateTime to) {
  ref.read(selectedOrderIdProvider.notifier).state = null;
  ref.read(ordersFilterProvider.notifier).state =
      OrdersDateRange.custom(from, to);
}
