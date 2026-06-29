class DailyRevenue {
  const DailyRevenue({
    required this.date,
    required this.revenueInPaisa,
    required this.orderCount,
  });

  final DateTime date;
  final int revenueInPaisa;
  final int orderCount;
}

class DailyAnalyticsSummary {
  const DailyAnalyticsSummary({
    required this.date,
    required this.orderCount,
    required this.revenueInPaisa,
    required this.dineInCount,
    required this.takeawayCount,
    required this.deliveryCount,
  });

  DailyAnalyticsSummary.empty(this.date)
      : orderCount = 0,
        revenueInPaisa = 0,
        dineInCount = 0,
        takeawayCount = 0,
        deliveryCount = 0;

  final DateTime date;
  final int orderCount;
  final int revenueInPaisa;
  final int dineInCount;
  final int takeawayCount;
  final int deliveryCount;

  int get avgOrderInPaisa =>
      orderCount == 0 ? 0 : (revenueInPaisa / orderCount).round();
}

class WeeklyOrderTypeStats {
  const WeeklyOrderTypeStats({
    required this.weekStart,
    required this.dineInCount,
    required this.takeawayCount,
    required this.deliveryCount,
  });

  final DateTime weekStart;
  final int dineInCount;
  final int takeawayCount;
  final int deliveryCount;

  int get total => dineInCount + takeawayCount + deliveryCount;
}

class ProductSalesCount {
  const ProductSalesCount({
    required this.productName,
    required this.quantity,
    required this.revenueInPaisa,
  });

  final String productName;
  final int quantity;
  final int revenueInPaisa;
}
