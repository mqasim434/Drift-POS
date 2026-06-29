import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  const CartItem({
    required this.id,
    required this.name,
    required this.unitPriceInPaisa,
    required this.quantity,
    required this.isDeal,
    this.dealItemNames,
  });

  final int id;
  final String name;
  final int unitPriceInPaisa;
  final int quantity;
  final bool isDeal;
  final List<String>? dealItemNames;

  int get lineTotalInPaisa => unitPriceInPaisa * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      name: name,
      unitPriceInPaisa: unitPriceInPaisa,
      quantity: quantity ?? this.quantity,
      isDeal: isDeal,
      dealItemNames: dealItemNames,
    );
  }

  @override
  List<Object?> get props => [id, isDeal, name, unitPriceInPaisa, quantity];
}
