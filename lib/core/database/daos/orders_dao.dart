import 'package:drift/drift.dart';

import '../../models/analytics_models.dart';
import '../../models/dashboard_stats.dart';
import '../app_database.dart';
import '../tables/order_items.dart';
import '../tables/orders.dart';

part 'orders_dao.g.dart';

@DriftAccessor(tables: [Orders, OrderItems])
class OrdersDao extends DatabaseAccessor<AppDatabase> with _$OrdersDaoMixin {
  OrdersDao(super.db);

  Stream<List<Order>> watchOrdersByDateRange(DateTime from, DateTime to) {
    return (select(orders)
          ..where(
            (o) =>
                o.createdAt.isBiggerOrEqualValue(from) &
                o.createdAt.isSmallerThanValue(to),
          )
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .watch();
  }

  Future<int> insertOrder(OrdersCompanion order) {
    return into(orders).insert(order);
  }

  Future<int> insertOrderItem(OrderItemsCompanion item) {
    return into(orderItems).insert(item);
  }

  Future<List<OrderItem>> getItemsForOrder(int orderId) {
    return (select(orderItems)..where((i) => i.orderId.equals(orderId))).get();
  }

  Future<Order?> getOrderById(int id) {
    return (select(orders)..where((o) => o.id.equals(id))).getSingleOrNull();
  }

  Future<Map<int, int>> getItemCountsForOrders(List<int> orderIds) async {
    if (orderIds.isEmpty) return {};

    final quantityExp = orderItems.quantity.sum();
    final rows = await (selectOnly(orderItems)
          ..addColumns([orderItems.orderId, quantityExp])
          ..where(orderItems.orderId.isIn(orderIds))
          ..groupBy([orderItems.orderId]))
        .get();

    return {
      for (final row in rows)
        row.read(orderItems.orderId)!: row.read(quantityExp) ?? 0,
    };
  }

  Future<int> cancelOrder(int id) {
    return (update(orders)..where((o) => o.id.equals(id))).write(
      const OrdersCompanion(status: Value('cancelled')),
    );
  }

  Future<int> countOrdersInRange(DateTime from, DateTime to) async {
    final countExp = orders.id.count();
    final query = selectOnly(orders)
      ..addColumns([countExp])
      ..where(
        orders.createdAt.isBiggerOrEqualValue(from) &
            orders.createdAt.isSmallerThanValue(to),
      );
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<List<Order>> getActiveOrdersForTable({
    required int tableId,
    required DateTime from,
    required DateTime to,
  }) {
    return (select(orders)
          ..where(
            (o) =>
                o.tableId.equals(tableId) &
                o.createdAt.isBiggerOrEqualValue(from) &
                o.createdAt.isSmallerThanValue(to) &
                o.status.equals('cancelled').not(),
          ))
        .get();
  }

  Future<Set<int>> getOccupiedTableIdsForToday() async {
    final today = DateTime.now();
    final from = DateTime(today.year, today.month, today.day);
    final to = from.add(const Duration(days: 1));

    final rows = await (select(orders)
          ..where(
            (o) =>
                o.tableId.isNotNull() &
                o.createdAt.isBiggerOrEqualValue(from) &
                o.createdAt.isSmallerThanValue(to) &
                o.status.equals('cancelled').not(),
          ))
        .get();

    return rows.map((order) => order.tableId!).toSet();
  }

  Future<DashboardStats> getTodayStats(DateTime today) async {
    final from = DateTime(today.year, today.month, today.day);
    final to = from.add(const Duration(days: 1));

    final todayOrders = await (select(orders)
          ..where(
            (o) =>
                o.createdAt.isBiggerOrEqualValue(from) &
                o.createdAt.isSmallerThanValue(to) &
                o.status.equals('cancelled').not(),
          )
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .get();

    final revenueInPaisa = todayOrders.fold<int>(
      0,
      (sum, order) => sum + order.totalInPaisa,
    );

    final dineInCount =
        todayOrders.where((o) => o.orderType == 'dine_in').length;
    final takeawayCount =
        todayOrders.where((o) => o.orderType == 'takeaway').length;
    final deliveryCount =
        todayOrders.where((o) => o.orderType == 'delivery').length;

    final orderIds = todayOrders.map((o) => o.id).toList();
    var itemsSold = 0;
    if (orderIds.isNotEmpty) {
      final quantityExp = orderItems.quantity.sum();
      final itemsQuery = selectOnly(orderItems)
        ..addColumns([quantityExp])
        ..where(orderItems.orderId.isIn(orderIds));
      final row = await itemsQuery.getSingle();
      itemsSold = row.read(quantityExp) ?? 0;
    }

    final hourlyRevenue = await _getHourlyRevenue(from, to);
    final topProducts = await getTopProducts(from, to, limit: 5);
    final recentOrders = todayOrders.take(5).toList();

    return DashboardStats(
      revenueInPaisa: revenueInPaisa,
      totalOrders: todayOrders.length,
      itemsSold: itemsSold,
      dineInCount: dineInCount,
      takeawayCount: takeawayCount,
      deliveryCount: deliveryCount,
      hourlyRevenue: hourlyRevenue,
      topProducts: topProducts
          .map(
            (p) => TopProductStat(
              productName: p.productName,
              quantity: p.quantity,
              revenueInPaisa: p.revenueInPaisa,
            ),
          )
          .toList(),
      recentOrders: recentOrders,
    );
  }

  Future<List<HourlyRevenue>> _getHourlyRevenue(
    DateTime from,
    DateTime to,
  ) async {
    final results = <HourlyRevenue>[];
    for (var hour = 8; hour < 20; hour++) {
      final hourStart = DateTime(from.year, from.month, from.day, hour);
      final hourEnd = hourStart.add(const Duration(hours: 1));

      final sumExp = orders.totalInPaisa.sum();
      final query = selectOnly(orders)
        ..addColumns([sumExp])
        ..where(
          orders.createdAt.isBiggerOrEqualValue(hourStart) &
              orders.createdAt.isSmallerThanValue(hourEnd) &
              orders.status.equals('cancelled').not(),
        );

      final row = await query.getSingle();
      results.add(
        HourlyRevenue(
          hour: hour,
          revenueInPaisa: row.read(sumExp) ?? 0,
        ),
      );
    }
    return results;
  }

  Future<List<DailyRevenue>> getRevenueByDateRange(
    DateTime from,
    DateTime to,
  ) async {
    final rows = await customSelect(
      '''
      SELECT
        date(created_at) AS day,
        SUM(total_in_paisa) AS revenue,
        COUNT(*) AS order_count
      FROM orders
      WHERE created_at >= ? AND created_at < ? AND status != 'cancelled'
      GROUP BY date(created_at)
      ORDER BY day ASC
      ''',
      variables: [
        Variable.withDateTime(from),
        Variable.withDateTime(to),
      ],
      readsFrom: {orders},
    ).get();

    return rows
        .map(
          (row) => DailyRevenue(
            date: DateTime.parse(row.read<String>('day')),
            revenueInPaisa: row.read<int>('revenue'),
            orderCount: row.read<int>('order_count'),
          ),
        )
        .toList();
  }

  Future<List<ProductSalesCount>> getTopProducts(
    DateTime from,
    DateTime to, {
    int limit = 10,
  }) async {
    final rows = await customSelect(
      '''
      SELECT
        oi.item_name AS product_name,
        SUM(oi.quantity) AS quantity,
        SUM(oi.total_price_in_paisa) AS revenue
      FROM order_items oi
      INNER JOIN orders o ON o.id = oi.order_id
      WHERE o.created_at >= ? AND o.created_at < ? AND o.status != 'cancelled'
      GROUP BY oi.item_name
      ORDER BY quantity DESC
      LIMIT ?
      ''',
      variables: [
        Variable.withDateTime(from),
        Variable.withDateTime(to),
        Variable.withInt(limit),
      ],
      readsFrom: {orderItems, orders},
    ).get();

    return rows
        .map(
          (row) => ProductSalesCount(
            productName: row.read<String>('product_name'),
            quantity: row.read<int>('quantity'),
            revenueInPaisa: row.read<int>('revenue'),
          ),
        )
        .toList();
  }
}
