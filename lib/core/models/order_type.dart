enum OrderType {
  dineIn('dine_in', 'Dine In'),
  takeaway('takeaway', 'Take Away'),
  delivery('delivery', 'Delivery');

  const OrderType(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static OrderType? fromDbValue(String value) {
    for (final type in OrderType.values) {
      if (type.dbValue == value) return type;
    }
    return null;
  }
}
