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
