import '../models/cart_totals.dart';
import '../../core/database/app_database.dart';
import '../../core/models/order_models.dart';
import '../../core/models/shop_settings.dart';

OrderWithItems buildTestReceiptOrder(ShopSettings settings) {
  final now = DateTime.now();
  const subtotalInPaisa = 87000;
  final taxInPaisa = (subtotalInPaisa * settings.taxRateFraction).round();

  return OrderWithItems(
    order: Order(
      id: 0,
      orderNumber: 'TEST-001',
      orderType: 'dine_in',
      tableId: 5,
      subtotalInPaisa: subtotalInPaisa,
      taxInPaisa: taxInPaisa,
      discountInPaisa: 0,
      totalInPaisa: subtotalInPaisa + taxInPaisa,
      status: 'completed',
      createdAt: now,
    ),
    items: const [
      OrderItem(
        id: 1,
        orderId: 0,
        productId: 1,
        itemName: 'Burger',
        quantity: 2,
        unitPriceInPaisa: 20000,
        totalPriceInPaisa: 40000,
        isDeal: false,
      ),
      OrderItem(
        id: 2,
        orderId: 0,
        productId: 2,
        itemName: 'Fries (L)',
        quantity: 1,
        unitPriceInPaisa: 12000,
        totalPriceInPaisa: 12000,
        isDeal: false,
      ),
      OrderItem(
        id: 3,
        orderId: 0,
        dealId: 1,
        itemName: 'Meal Deal',
        quantity: 1,
        unitPriceInPaisa: 35000,
        totalPriceInPaisa: 35000,
        isDeal: true,
        lineDetails: 'Burger\nDrink',
      ),
    ],
    tableName: '5',
  );
}
