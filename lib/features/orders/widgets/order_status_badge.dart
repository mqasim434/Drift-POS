import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/order_status.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({
    super.key,
    required this.orderStatus,
  });

  final String orderStatus;

  @override
  Widget build(BuildContext context) {
    if (OrderStatus.isCancelled(orderStatus)) {
      return _badge('Cancelled', AppColors.danger, AppColors.dangerBg);
    }
    if (OrderStatus.isCompleted(orderStatus)) {
      return _badge('Completed', AppColors.success, AppColors.successBg);
    }
    return _badge(
      OrderStatus.labelFor(orderStatus),
      AppColors.accent,
      AppColors.accentBg,
    );
  }

  Widget _badge(String label, Color textColor, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.badgeRadius),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(color: textColor),
      ),
    );
  }
}
