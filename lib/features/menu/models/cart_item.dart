import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  const CartItem({
    required this.id,
    required this.name,
    required this.unitPriceInPaisa,
    required this.quantity,
    required this.isDeal,
    this.variantId,
    this.dealItemNames,
  });

  final int id;
  final String name;
  final int unitPriceInPaisa;
  final int quantity;
  final bool isDeal;
  final int? variantId;
  final List<String>? dealItemNames;

  int get lineTotalInPaisa => unitPriceInPaisa * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      name: name,
      unitPriceInPaisa: unitPriceInPaisa,
      quantity: quantity ?? this.quantity,
      isDeal: isDeal,
      variantId: variantId,
      dealItemNames: dealItemNames,
    );
  }

  @override
  List<Object?> get props =>
      [id, isDeal, variantId, name, unitPriceInPaisa, quantity];
}
