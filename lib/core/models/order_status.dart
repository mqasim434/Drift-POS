/// Order lifecycle: in_progress → completed | cancelled
///
/// Separate from [OrderType] (dine-in, takeaway, delivery).
class OrderStatus {
  OrderStatus._();

  static const inProgress = 'in_progress';
  static const completed = 'completed';
  static const cancelled = 'cancelled';

  static const _labels = {
    inProgress: 'In Progress',
    completed: 'Completed',
    cancelled: 'Cancelled',
    'open': 'In Progress',
  };

  static String labelFor(String status) =>
      _labels[status] ?? status.replaceAll('_', ' ');

  static bool isInProgress(String status) =>
      status == inProgress || status == 'open';

  /// Alias for [isInProgress] — active orders awaiting completion.
  static bool isOpen(String status) => isInProgress(status);

  static bool isCompleted(String status) => status == completed;

  static bool isCancelled(String status) => status == cancelled;

  static bool isActive(String status) => !isCancelled(status);
}
