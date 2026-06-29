import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/order_models.dart';
import '../../../core/models/order_type.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../providers/orders_provider.dart';
import 'order_type_badge.dart';

class OrderDetailPanel extends ConsumerWidget {
  const OrderDetailPanel({
    super.key,
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(selectedOrderProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(left: BorderSide(color: AppColors.border)),
      ),
      child: detailAsync.when(
        data: (detail) {
          if (detail == null) {
            return Center(
              child: Text(
                'Select an order to view details',
                style: AppTextStyles.bodySmall,
              ),
            );
          }

          return _OrderDetailBody(
            detail: detail,
            onClose: onClose,
            onCancel: () => _cancelOrder(context, ref, detail),
            onPrint: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Receipt printing will be available in a later module'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: Text('Loading order...')),
        error: (error, _) => Center(
          child: Text(
            error.toString(),
            style: const TextStyle(color: AppColors.danger),
          ),
        ),
      ),
    );
  }

  Future<void> _cancelOrder(
    BuildContext context,
    WidgetRef ref,
    OrderWithItems detail,
  ) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Cancel Order',
      message: 'Cancel order ${detail.order.orderNumber}?',
      confirmLabel: 'Cancel Order',
    );
    if (confirmed != true) return;

    await ref.read(ordersNotifierProvider.notifier).cancelOrder(detail.order.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order cancelled')),
      );
    }
  }
}

class _OrderDetailBody extends StatelessWidget {
  const _OrderDetailBody({
    required this.detail,
    required this.onClose,
    required this.onCancel,
    required this.onPrint,
  });

  final OrderWithItems detail;
  final VoidCallback onClose;
  final VoidCallback onCancel;
  final VoidCallback onPrint;

  bool get _canCancel {
    if (detail.isCancelled) return false;
    final created = detail.order.createdAt;
    final now = DateTime.now();
    return created.year == now.year &&
        created.month == now.month &&
        created.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final order = detail.order;
    final orderType = OrderType.fromDbValue(order.orderType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSizes.md),
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
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OrderTypeBadge(
                  orderType: order.orderType,
                  isCancelled: detail.isCancelled,
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
