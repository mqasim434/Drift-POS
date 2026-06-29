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

  Future<int> completeOrder(int id) {
    return (update(orders)..where((o) => o.id.equals(id))).write(
      const OrdersCompanion(status: Value('completed')),
    );
  }

  Future<List<Order>> getOrdersInRange(DateTime from, DateTime to) {
    return (select(orders)
          ..where(
            (o) =>
                o.createdAt.isBiggerOrEqualValue(from) &
                o.createdAt.isSmallerThanValue(to),
          )
          ..orderBy([(o) => OrderingTerm.asc(o.createdAt)]))
        .get();
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
                o.status.equals('open'),
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
                o.status.equals('open'),
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
        strftime('%Y-%m-%d', created_at) AS day,
        COALESCE(SUM(total_in_paisa), 0) AS revenue,
        COUNT(*) AS order_count
      FROM orders
      WHERE created_at >= ? AND created_at < ? AND status != 'cancelled'
      GROUP BY strftime('%Y-%m-%d', created_at)
      ORDER BY day ASC
      ''',
      variables: [
        Variable.withDateTime(from),
        Variable.withDateTime(to),
      ],
      readsFrom: {orders},
    ).get();

    return rows.map(_mapDailyRevenue).whereType<DailyRevenue>().toList();
  }

  DailyRevenue? _mapDailyRevenue(QueryRow row) {
    final date = _tryReadQueryDate(row, 'day');
    if (date == null) return null;

    return DailyRevenue(
      date: date,
      revenueInPaisa: _readQueryInt(row, 'revenue'),
      orderCount: _readQueryInt(row, 'order_count'),
    );
  }

  Future<List<ProductSalesCount>> getTopProducts(
    DateTime from,
    DateTime to, {
    int limit = 10,
  }) async {
    final rows = await customSelect(
      '''
      SELECT
        COALESCE(oi.item_name, 'Unknown') AS product_name,
        COALESCE(SUM(oi.quantity), 0) AS quantity,
        COALESCE(SUM(oi.total_price_in_paisa), 0) AS revenue
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

    return rows.map(_mapProductSalesCount).toList();
  }

  Future<List<DailyAnalyticsSummary>> getDailyAnalyticsSummary(
    DateTime from,
    DateTime to,
  ) async {
    final rows = await customSelect(
      '''
      SELECT
        strftime('%Y-%m-%d', created_at) AS day,
        COUNT(*) AS order_count,
        COALESCE(SUM(total_in_paisa), 0) AS revenue,
        COALESCE(SUM(CASE WHEN order_type = 'dine_in' THEN 1 ELSE 0 END), 0) AS dine_in,
        COALESCE(SUM(CASE WHEN order_type = 'takeaway' THEN 1 ELSE 0 END), 0) AS takeaway,
        COALESCE(SUM(CASE WHEN order_type = 'delivery' THEN 1 ELSE 0 END), 0) AS delivery
      FROM orders
      WHERE created_at >= ? AND created_at < ? AND status != 'cancelled'
      GROUP BY strftime('%Y-%m-%d', created_at)
      ORDER BY day ASC
      ''',
      variables: [
        Variable.withDateTime(from),
        Variable.withDateTime(to),
      ],
      readsFrom: {orders},
    ).get();

    return rows
        .map(_mapDailyAnalyticsSummary)
        .whereType<DailyAnalyticsSummary>()
        .toList();
  }

  DailyAnalyticsSummary? _mapDailyAnalyticsSummary(QueryRow row) {
    final date = _tryReadQueryDate(row, 'day');
    if (date == null) return null;

    return DailyAnalyticsSummary(
      date: date,
      orderCount: _readQueryInt(row, 'order_count'),
      revenueInPaisa: _readQueryInt(row, 'revenue'),
      dineInCount: _readQueryInt(row, 'dine_in'),
      takeawayCount: _readQueryInt(row, 'takeaway'),
      deliveryCount: _readQueryInt(row, 'delivery'),
    );
  }

  Future<List<WeeklyOrderTypeStats>> getWeeklyOrderTypeTrend(
    DateTime from,
    DateTime to,
  ) async {
    final rows = await customSelect(
      '''
      SELECT
        strftime('%Y-%W', created_at) AS week_key,
        MIN(strftime('%Y-%m-%d', created_at)) AS week_start,
        COALESCE(SUM(CASE WHEN order_type = 'dine_in' THEN 1 ELSE 0 END), 0) AS dine_in,
        COALESCE(SUM(CASE WHEN order_type = 'takeaway' THEN 1 ELSE 0 END), 0) AS takeaway,
        COALESCE(SUM(CASE WHEN order_type = 'delivery' THEN 1 ELSE 0 END), 0) AS delivery
      FROM orders
      WHERE created_at >= ? AND created_at < ? AND status != 'cancelled'
      GROUP BY week_key
      ORDER BY week_key ASC
      ''',
      variables: [
        Variable.withDateTime(from),
        Variable.withDateTime(to),
      ],
      readsFrom: {orders},
    ).get();

    return rows
        .map(_mapWeeklyOrderTypeStats)
        .whereType<WeeklyOrderTypeStats>()
        .toList();
  }

  WeeklyOrderTypeStats? _mapWeeklyOrderTypeStats(QueryRow row) {
    final weekStart = _tryReadQueryDate(row, 'week_start');
    if (weekStart == null) return null;

    return WeeklyOrderTypeStats(
      weekStart: weekStart,
      dineInCount: _readQueryInt(row, 'dine_in'),
      takeawayCount: _readQueryInt(row, 'takeaway'),
      deliveryCount: _readQueryInt(row, 'delivery'),
    );
  }

  Future<List<ProductSalesCount>> getTopProductsByRevenue(
    DateTime from,
    DateTime to, {
    int limit = 10,
  }) async {
    final rows = await customSelect(
      '''
      SELECT
        COALESCE(oi.item_name, 'Unknown') AS product_name,
        COALESCE(SUM(oi.quantity), 0) AS quantity,
        COALESCE(SUM(oi.total_price_in_paisa), 0) AS revenue
      FROM order_items oi
      INNER JOIN orders o ON o.id = oi.order_id
      WHERE o.created_at >= ? AND o.created_at < ? AND o.status != 'cancelled'
      GROUP BY oi.item_name
      ORDER BY revenue DESC
      LIMIT ?
      ''',
      variables: [
        Variable.withDateTime(from),
        Variable.withDateTime(to),
        Variable.withInt(limit),
      ],
      readsFrom: {orderItems, orders},
    ).get();

    return rows.map(_mapProductSalesCount).toList();
  }

  ProductSalesCount _mapProductSalesCount(QueryRow row) {
    return ProductSalesCount(
      productName: _readQueryString(row, 'product_name', fallback: 'Unknown'),
      quantity: _readQueryInt(row, 'quantity'),
      revenueInPaisa: _readQueryInt(row, 'revenue'),
    );
  }

  int _readQueryInt(QueryRow row, String column) {
    final direct = row.readNullable<int>(column);
    if (direct != null) return direct;

    final asBigInt = row.readNullable<BigInt>(column);
    if (asBigInt != null) return asBigInt.toInt();

    final asString = row.readNullable<String>(column);
    if (asString != null) return int.tryParse(asString) ?? 0;

    return 0;
  }

  String _readQueryString(
    QueryRow row,
    String column, {
    required String fallback,
  }) {
    final value = row.readNullable<String>(column);
    if (value == null) return fallback;
    final text = value.trim();
    return text.isEmpty ? fallback : text;
  }

  DateTime? _tryReadQueryDate(QueryRow row, String column) {
    final asString = row.readNullable<String>(column);
    if (asString != null && asString.isNotEmpty) {
      return DateTime.parse(asString);
    }

    final asDateTime = row.readNullable<DateTime>(column);
    if (asDateTime != null) {
      return DateTime(asDateTime.year, asDateTime.month, asDateTime.day);
    }

    return null;
  }
}
