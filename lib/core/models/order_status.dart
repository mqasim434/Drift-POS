/// Order lifecycle: open → completed | cancelled
class OrderStatus {
  OrderStatus._();

  static const open = 'open';
  static const completed = 'completed';
  static const cancelled = 'cancelled';

  static bool isOpen(String status) => status == open;

  static bool isCompleted(String status) => status == completed;

  static bool isCancelled(String status) => status == cancelled;

  static bool isActive(String status) => !isCancelled(status);
}
