import 'package:equatable/equatable.dart';

import '../../../core/models/order_type.dart';
import 'cart_item.dart';

class CartState extends Equatable {
  const CartState({
    this.items = const [],
    this.orderType = OrderType.dineIn,
    this.selectedTableId,
    this.customerName = '',
    this.customerContact = '',
    this.deliveryAddress = '',
    this.notes = '',
    this.isPlacingOrder = false,
  });

  final List<CartItem> items;
  final OrderType orderType;
  final int? selectedTableId;
  final String customerName;
  final String customerContact;
  final String deliveryAddress;
  final String notes;
  final bool isPlacingOrder;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  int get subtotalInPaisa =>
      items.fold(0, (sum, item) => sum + item.lineTotalInPaisa);

  bool get isEmpty => items.isEmpty;

  CartState copyWith({
    List<CartItem>? items,
    OrderType? orderType,
    int? selectedTableId,
    bool clearTable = false,
    String? customerName,
    String? customerContact,
    String? deliveryAddress,
    String? notes,
    bool? isPlacingOrder,
  }) {
    return CartState(
      items: items ?? this.items,
      orderType: orderType ?? this.orderType,
      selectedTableId:
          clearTable ? null : (selectedTableId ?? this.selectedTableId),
      customerName: customerName ?? this.customerName,
      customerContact: customerContact ?? this.customerContact,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      notes: notes ?? this.notes,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
    );
  }

  @override
  List<Object?> get props => [
        items,
        orderType,
        selectedTableId,
        customerName,
        customerContact,
        deliveryAddress,
        notes,
        isPlacingOrder,
      ];
}
