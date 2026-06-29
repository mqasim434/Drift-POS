import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/database/app_database.dart';
import '../../../core/models/order_models.dart';
import '../../../core/models/order_type.dart';
import '../../../core/models/order_status.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/providers/shop_settings_provider.dart';
import '../../../core/services/receipt_service.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../providers/orders_provider.dart';
import 'order_type_badge.dart';

final orderDetailByIdProvider =
    FutureProvider.autoDispose.family<OrderWithItems?, int>((ref, orderId) async {
  final db = ref.watch(databaseProvider);
  return loadOrderWithItems(db, orderId);
});

Future<void> showOrderDetailDialog(
  BuildContext context,
  WidgetRef ref,
  int orderId,
) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => _OrderDetailDialog(orderId: orderId),
  );
}

class _OrderDetailDialog extends ConsumerWidget {
  const _OrderDetailDialog({required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(orderDetailByIdProvider(orderId));

    return Dialog(
      insetPadding: const EdgeInsets.all(AppSizes.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 680),
        child: detailAsync.when(
          data: (detail) {
            if (detail == null) {
              return Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Text('Order not found', style: AppTextStyles.body),
              );
            }

            return OrderDetailContent(
              detail: detail,
              onClose: () => Navigator.of(context).pop(),
              onComplete: () => _completeOrder(context, ref, detail),
              onCancel: () => _cancelOrder(context, ref, detail),
              onPrint: () => _printReceipt(context, ref, detail),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSizes.xxl),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Text(
              error.toString(),
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _printReceipt(
    BuildContext context,
    WidgetRef ref,
    OrderWithItems detail,
  ) async {
    final settings = await ref.read(shopSettingsProvider.future);
    if (!context.mounted) return;
    await ref.read(receiptServiceProvider).showPreview(context, detail, settings);
  }

  Future<void> _completeOrder(
    BuildContext context,
    WidgetRef ref,
    OrderWithItems detail,
  ) async {
    final completed = await confirmAndCompleteOrder(context, ref, detail.order);
    if (!completed || !context.mounted) return;

    ref.invalidate(orderDetailByIdProvider(orderId));
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order completed')),
    );
  }

  Future<void> _cancelOrder(
    BuildContext context,
    WidgetRef ref,
    OrderWithItems detail,
  ) async {
    final cancelled = await confirmAndCancelOrder(context, ref, detail.order);
    if (!cancelled || !context.mounted) return;

    ref.invalidate(orderDetailByIdProvider(orderId));
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order cancelled')),
    );
  }
}

class OrderDetailContent extends StatelessWidget {
  const OrderDetailContent({
    super.key,
    required this.detail,
    required this.onClose,
    required this.onComplete,
    required this.onCancel,
    required this.onPrint,
  });

  final OrderWithItems detail;
  final VoidCallback onClose;
  final VoidCallback onComplete;
  final VoidCallback onCancel;
  final VoidCallback onPrint;

  bool get _canCancel => canCancelOrder(detail.order);
  bool get _canComplete => canCompleteOrder(detail.order);

  @override
  Widget build(BuildContext context) {
    final order = detail.order;
    final orderType = OrderType.fromDbValue(order.orderType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.md, AppSizes.sm, AppSizes.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.orderNumber, style: AppTextStyles.title),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      DateFormatter.formatDateTime(order.createdAt),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OrderTypeBadge(
                  orderType: order.orderType,
                  isCancelled: detail.isCancelled,
                  isCompleted: detail.isCompleted,
                ),
                const SizedBox(height: AppSizes.md),
                if (orderType == OrderType.dineIn && detail.tableName != null)
                  _infoRow('Table', detail.tableName!),
                if (orderType == OrderType.delivery) ...[
                  if (order.customerName != null)
                    _infoRow('Customer', order.customerName!),
                  if (order.customerContact != null)
                    _infoRow('Contact', order.customerContact!),
                  if (order.deliveryAddress != null)
                    _infoRow('Address', order.deliveryAddress!),
                ],
                const SizedBox(height: AppSizes.md),
                Text('Items', style: AppTextStyles.subtitle),
                const SizedBox(height: AppSizes.sm),
                for (final item in detail.items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.sm),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item.quantity}x ${item.itemName}',
                            style: AppTextStyles.body,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(item.totalPriceInPaisa),
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                  ),
                const Divider(height: AppSizes.lg),
                _totalRow('Subtotal', order.subtotalInPaisa),
                _totalRow('Tax', order.taxInPaisa),
                if (order.discountInPaisa > 0)
                  _totalRow('Discount', order.discountInPaisa),
                const Divider(height: AppSizes.md),
                _totalRow('Total', order.totalInPaisa, emphasize: true),
                if (order.notes != null && order.notes!.trim().isNotEmpty) ...[
                  const SizedBox(height: AppSizes.md),
                  Text('Notes', style: AppTextStyles.subtitle),
                  const SizedBox(height: AppSizes.xs),
                  Text(order.notes!, style: AppTextStyles.bodySmall),
                ],
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: onPrint,
                icon: const Icon(Icons.receipt_long_outlined),
                label: const Text('Print Receipt'),
              ),
              if (_canComplete) ...[
                const SizedBox(height: AppSizes.sm),
                ElevatedButton.icon(
                  onPressed: onComplete,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Complete Order'),
                ),
              ],
              if (_canCancel) ...[
                const SizedBox(height: AppSizes.sm),
                OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                  ),
                  child: const Text('Cancel Order'),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: AppTextStyles.caption),
          ),
          Expanded(child: Text(value, style: AppTextStyles.body)),
        ],
      ),
    );
  }

  Widget _totalRow(String label, int amountInPaisa, {bool emphasize = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: AppTextStyles.bodySmall),
          ),
          Text(
            CurrencyFormatter.format(amountInPaisa),
            style: emphasize ? AppTextStyles.price : AppTextStyles.subtitle,
          ),
        ],
      ),
    );
  }
}

bool canCancelOrder(Order order) {
  if (!OrderStatus.isOpen(order.status)) return false;
  final created = order.createdAt;
  final now = DateTime.now();
  return created.year == now.year &&
      created.month == now.month &&
      created.day == now.day;
}

bool canCompleteOrder(Order order) => OrderStatus.isOpen(order.status);

Future<bool> confirmAndCompleteOrder(
  BuildContext context,
  WidgetRef ref,
  Order order,
) async {
  if (!canCompleteOrder(order)) return false;

  final confirmed = await showConfirmationDialog(
    context: context,
    title: 'Complete Order',
    message: 'Mark order ${order.orderNumber} as completed?',
    confirmLabel: 'Complete',
  );
  if (confirmed != true) return false;

  await ref.read(ordersNotifierProvider.notifier).completeOrder(order.id);
  return true;
}

Future<bool> confirmAndCancelOrder(
  BuildContext context,
  WidgetRef ref,
  Order order,
) async {
  if (!canCancelOrder(order)) {
    if (OrderStatus.isCancelled(order.status)) return false;
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Only today\'s orders can be cancelled'),
        ),
      );
    }
    return false;
  }

  final confirmed = await showConfirmationDialog(
    context: context,
    title: 'Cancel Order',
    message: 'Cancel order ${order.orderNumber}?',
    confirmLabel: 'Cancel Order',
  );
  if (confirmed != true) return false;

  await ref.read(ordersNotifierProvider.notifier).cancelOrder(order.id);
  return true;
}
