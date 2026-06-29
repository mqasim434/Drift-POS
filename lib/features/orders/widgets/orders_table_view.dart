import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/database/app_database.dart';
import '../../../core/models/order_models.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import 'order_detail_dialog.dart';
import 'order_type_badge.dart';

abstract final class _OrdersTableLayout {
  static const orderFlex = 4;
  static const timeFlex = 2;
  static const typeFlex = 2;
  static const itemsFlex = 1;
  static const totalFlex = 2;
  static const actionsWidth = 196.0;
}

class OrdersTableView extends ConsumerWidget {
  const OrdersTableView({
    super.key,
    required this.orders,
  });

  final List<OrderSummary> orders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _OrdersTableHeader(),
          Expanded(
            child: ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppColors.border),
              itemBuilder: (context, index) {
                final summary = orders[index];
                final order = summary.order;
                final isCancelled = summary.isCancelled;
                final isCompleted = summary.isCompleted;
                final canCancel = canCancelOrder(order);
                final canComplete = canCompleteOrder(order);

                return Material(
                  color: isCancelled
                      ? AppColors.dangerBg.withValues(alpha: 0.35)
                      : isCompleted
                          ? AppColors.successBg.withValues(alpha: 0.2)
                          : Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.md,
                    ),
                    child: Row(
                      children: [
                        _OrdersFlexCell(
                          flex: _OrdersTableLayout.orderFlex,
                          child: Text(
                            order.orderNumber,
                            style: AppTextStyles.body.copyWith(
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                              color: isCancelled
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                              decoration: isCancelled
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _OrdersFlexCell(
                          flex: _OrdersTableLayout.timeFlex,
                          child: Text(
                            DateFormatter.formatTime24(order.createdAt),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isCancelled
                                  ? AppColors.textMuted
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                        _OrdersFlexCell(
                          flex: _OrdersTableLayout.typeFlex,
                          child: OrderTypeBadge(
                            orderType: order.orderType,
                            isCancelled: isCancelled,
                            isCompleted: isCompleted,
                          ),
                        ),
                        _OrdersFlexCell(
                          flex: _OrdersTableLayout.itemsFlex,
                          alignment: Alignment.center,
                          child: Text(
                            '${summary.itemCount}',
                            style: AppTextStyles.body.copyWith(
                              color: isCancelled
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        _OrdersFlexCell(
                          flex: _OrdersTableLayout.totalFlex,
                          alignment: Alignment.centerRight,
                          child: Text(
                            CurrencyFormatter.format(order.totalInPaisa),
                            style: AppTextStyles.price.copyWith(
                              fontSize: 14,
                              color: isCancelled
                                  ? AppColors.textMuted
                                  : AppColors.accent,
                              decoration: isCancelled
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(
                          width: _OrdersTableLayout.actionsWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _TableActionButton(
                                label: 'View',
                                onPressed: () => showOrderDetailDialog(
                                  context,
                                  ref,
                                  order.id,
                                ),
                              ),
                              if (canComplete) ...[
                                const SizedBox(width: AppSizes.xs),
                                _TableActionButton(
                                  label: 'Complete',
                                  isSuccess: true,
                                  onPressed: () => _completeFromTable(
                                    context,
                                    ref,
                                    order,
                                  ),
                                ),
                              ],
                              if (canCancel) ...[
                                const SizedBox(width: AppSizes.xs),
                                _TableActionButton(
                                  label: 'Cancel',
                                  isDanger: true,
                                  onPressed: () => _cancelFromTable(
                                    context,
                                    ref,
                                    order,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _completeFromTable(
    BuildContext context,
    WidgetRef ref,
    Order order,
  ) async {
    final completed = await confirmAndCompleteOrder(context, ref, order);
    if (completed && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order completed')),
      );
    }
  }

  Future<void> _cancelFromTable(
    BuildContext context,
    WidgetRef ref,
    Order order,
  ) async {
    final cancelled = await confirmAndCancelOrder(context, ref, order);
    if (cancelled && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order cancelled')),
      );
    }
  }
}

class _TableActionButton extends StatelessWidget {
  const _TableActionButton({
    required this.label,
    required this.onPressed,
    this.isDanger = false,
    this.isSuccess = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isDanger;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: isDanger
            ? AppColors.danger
            : isSuccess
                ? AppColors.success
                : AppColors.accent,
      ),
      child: Text(label, style: AppTextStyles.labelSmall),
    );
  }
}

class _OrdersTableHeader extends StatelessWidget {
  const _OrdersTableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevated,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _OrdersFlexCell(
            flex: _OrdersTableLayout.orderFlex,
            child: Text('Order #', style: AppTextStyles.label),
          ),
          _OrdersFlexCell(
            flex: _OrdersTableLayout.timeFlex,
            child: Text('Time', style: AppTextStyles.label),
          ),
          _OrdersFlexCell(
            flex: _OrdersTableLayout.typeFlex,
            child: Text('Type', style: AppTextStyles.label),
          ),
          _OrdersFlexCell(
            flex: _OrdersTableLayout.itemsFlex,
            alignment: Alignment.center,
            child: Text('Items', style: AppTextStyles.label, textAlign: TextAlign.center),
          ),
          _OrdersFlexCell(
            flex: _OrdersTableLayout.totalFlex,
            alignment: Alignment.centerRight,
            child: Text('Total', style: AppTextStyles.label, textAlign: TextAlign.right),
          ),
          SizedBox(
            width: _OrdersTableLayout.actionsWidth,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('Actions', style: AppTextStyles.label),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersFlexCell extends StatelessWidget {
  const _OrdersFlexCell({
    required this.flex,
    required this.child,
    this.alignment = Alignment.centerLeft,
  });

  final int flex;
  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignment,
        child: child,
      ),
    );
  }
}
