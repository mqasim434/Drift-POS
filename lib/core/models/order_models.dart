import '../database/app_database.dart';
import 'order_status.dart';

class OrderSummary {
  const OrderSummary({
    required this.order,
    required this.itemCount,
  });

  final Order order;
  final int itemCount;

  bool get isCancelled => OrderStatus.isCancelled(order.orderStatus);
  bool get isCompleted => OrderStatus.isCompleted(order.orderStatus);
  bool get isInProgress => OrderStatus.isInProgress(order.orderStatus);
  bool get isOpen => isInProgress;
}

class OrderWithItems {
  const OrderWithItems({
    required this.order,
    required this.items,
    this.tableName,
  });

  final Order order;
  final List<OrderItem> items;
  final String? tableName;

  int get itemCount =>
      items.fold<int>(0, (sum, item) => sum + item.quantity);

  bool get isCancelled => OrderStatus.isCancelled(order.orderStatus);
  bool get isCompleted => OrderStatus.isCompleted(order.orderStatus);
  bool get isInProgress => OrderStatus.isInProgress(order.orderStatus);
  bool get isOpen => isInProgress;
}

class OrdersStats {
  const OrdersStats({
    required this.totalOrders,
    required this.revenueInPaisa,
    required this.dineInCount,
    required this.takeawayCount,
    required this.deliveryCount,
  });

  const OrdersStats.empty()
      : totalOrders = 0,
        revenueInPaisa = 0,
        dineInCount = 0,
        takeawayCount = 0,
        deliveryCount = 0;

  final int totalOrders;
  final int revenueInPaisa;
  final int dineInCount;
  final int takeawayCount;
  final int deliveryCount;

  factory OrdersStats.fromOrders(List<Order> orders) {
    final active =
        orders.where((order) => OrderStatus.isActive(order.orderStatus));
    return OrdersStats(
      totalOrders: active.length,
      revenueInPaisa: active.fold(0, (sum, order) => sum + order.totalInPaisa),
      dineInCount: active.where((o) => o.orderType == 'dine_in').length,
      takeawayCount: active.where((o) => o.orderType == 'takeaway').length,
      deliveryCount: active.where((o) => o.orderType == 'delivery').length,
    );
  }
}
