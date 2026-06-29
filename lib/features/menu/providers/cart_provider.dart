import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/models/deal_with_items.dart';
import '../../../core/models/menu_catalog.dart';
import '../../../core/models/order_type.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/utils/order_number_generator.dart';
import '../models/cart_item.dart';
import '../models/cart_state.dart';

class CartException implements Exception {
  CartException(this.message);

  final String message;

  @override
  String toString() => message;
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(CartNotifier.new);

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() => const CartState();

  void addProduct(MenuProduct product) {
    addItem(
      CartItem(
        id: product.id,
        name: product.name,
        unitPriceInPaisa: product.priceInPaisa,
        quantity: 1,
        isDeal: false,
      ),
    );
  }

  void addDeal(DealWithItems deal) {
    addItem(
      CartItem(
        id: deal.id,
        name: deal.name,
        unitPriceInPaisa: deal.priceInPaisa,
        quantity: 1,
        isDeal: true,
        dealItemNames: [
          for (final item in deal.items)
            item.quantity > 1
                ? '${item.product.name} x${item.quantity}'
                : item.product.name,
        ],
      ),
    );
  }

  void addItem(CartItem item) {
    final items = [...state.items];
    final index = items.indexWhere(
      (existing) => existing.id == item.id && existing.isDeal == item.isDeal,
    );

    if (index >= 0) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + item.quantity,
      );
    } else {
      items.add(item);
    }

    state = state.copyWith(items: items);
  }

  void removeItem(int id, bool isDeal) {
    state = state.copyWith(
      items: state.items
          .where((item) => !(item.id == id && item.isDeal == isDeal))
          .toList(),
    );
  }

  void updateQuantity(int id, bool isDeal, int quantity) {
    if (quantity <= 0) {
      removeItem(id, isDeal);
      return;
    }

    state = state.copyWith(
      items: [
        for (final item in state.items)
          if (item.id == id && item.isDeal == isDeal)
            item.copyWith(quantity: quantity)
          else
            item,
      ],
    );
  }

  void clearCart() => state = const CartState();

  void setOrderType(OrderType type) {
    state = state.copyWith(
      orderType: type,
      clearTable: type != OrderType.dineIn,
      customerName: type == OrderType.delivery ? state.customerName : '',
      customerContact:
          type == OrderType.delivery ? state.customerContact : '',
      deliveryAddress:
          type == OrderType.delivery ? state.deliveryAddress : '',
    );
  }

  void setTable(int? tableId) =>
      state = state.copyWith(selectedTableId: tableId);

  void setCustomerName(String value) =>
      state = state.copyWith(customerName: value);

  void setCustomerContact(String value) =>
      state = state.copyWith(customerContact: value);

  void setDeliveryAddress(String value) =>
      state = state.copyWith(deliveryAddress: value);

  void setNotes(String value) => state = state.copyWith(notes: value);

  Future<String> placeOrder() async {
    if (state.isEmpty) {
      throw CartException('Cart is empty.');
    }

    if (state.orderType == OrderType.delivery) {
      if (state.customerName.trim().isEmpty) {
        throw CartException('Customer name is required for delivery.');
      }
      if (state.customerContact.trim().isEmpty) {
        throw CartException('Contact number is required for delivery.');
      }
      if (state.deliveryAddress.trim().isEmpty) {
        throw CartException('Delivery address is required.');
      }
    }

    state = state.copyWith(isPlacingOrder: true);

    try {
      final db = ref.read(databaseProvider);
      final now = DateTime.now();
      final from = DateTime(now.year, now.month, now.day);
      final to = from.add(const Duration(days: 1));
      final dailyCount = await db.ordersDao.countOrdersInRange(from, to);
      final orderNumber = OrderNumberGenerator.generate(dailyCount);

      await db.transaction(() async {
        final orderId = await db.ordersDao.insertOrder(
          OrdersCompanion.insert(
            orderNumber: orderNumber,
            orderType: state.orderType.dbValue,
            tableId: state.orderType == OrderType.dineIn
                ? Value(state.selectedTableId)
                : const Value.absent(),
            customerName: state.orderType == OrderType.delivery
                ? Value(state.customerName.trim())
                : const Value.absent(),
            customerContact: state.orderType == OrderType.delivery
                ? Value(state.customerContact.trim())
                : const Value.absent(),
            deliveryAddress: state.orderType == OrderType.delivery
                ? Value(state.deliveryAddress.trim())
                : const Value.absent(),
            subtotalInPaisa: state.subtotalInPaisa,
            taxInPaisa: Value(state.taxInPaisa),
            totalInPaisa: state.totalInPaisa,
            notes: state.notes.trim().isEmpty
                ? const Value.absent()
                : Value(state.notes.trim()),
          ),
        );

        for (final item in state.items) {
          await db.ordersDao.insertOrderItem(
            OrderItemsCompanion.insert(
              orderId: orderId,
              productId: item.isDeal ? const Value.absent() : Value(item.id),
              dealId: item.isDeal ? Value(item.id) : const Value.absent(),
              itemName: item.name,
              quantity: item.quantity,
              unitPriceInPaisa: item.unitPriceInPaisa,
              totalPriceInPaisa: item.lineTotalInPaisa,
              isDeal: Value(item.isDeal),
            ),
          );
        }
      });

      clearCart();
      return orderNumber;
    } finally {
      state = state.copyWith(isPlacingOrder: false);
    }
  }
}
