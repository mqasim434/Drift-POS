enum OrderType {
  dineIn('dine_in', 'Dine In'),
  takeaway('takeaway', 'Take Away'),
  delivery('delivery', 'Delivery');

  const OrderType(this.dbValue, this.label);

  final String dbValue;
  final String label;
}
