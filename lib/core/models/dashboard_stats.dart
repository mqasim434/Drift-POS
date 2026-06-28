import '../database/app_database.dart';

class HourlyRevenue {
  const HourlyRevenue({
    required this.hour,
    required this.revenueInPaisa,
  });

  final int hour;
  final int revenueInPaisa;
}

class TopProductStat {
  const TopProductStat({
    required this.productName,
    required this.quantity,
    required this.revenueInPaisa,
  });

  final String productName;
  final int quantity;
  final int revenueInPaisa;
}

class DashboardStats {
  const DashboardStats({
    required this.revenueInPaisa,
    required this.totalOrders,
    required this.itemsSold,
    required this.dineInCount,
    required this.takeawayCount,
    required this.deliveryCount,
    required this.hourlyRevenue,
    required this.topProducts,
    required this.recentOrders,
  });

  final int revenueInPaisa;
  final int totalOrders;
  final int itemsSold;
  final int dineInCount;
  final int takeawayCount;
  final int deliveryCount;
  final List<HourlyRevenue> hourlyRevenue;
  final List<TopProductStat> topProducts;
  final List<Order> recentOrders;

  static DashboardStats empty() => const DashboardStats(
        revenueInPaisa: 0,
        totalOrders: 0,
        itemsSold: 0,
        dineInCount: 0,
        takeawayCount: 0,
        deliveryCount: 0,
        hourlyRevenue: [],
        topProducts: [],
        recentOrders: [],
      );
}
