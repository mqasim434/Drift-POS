import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/order_type.dart';

class OrderTypeBadge extends StatelessWidget {
  const OrderTypeBadge({
    super.key,
    required this.orderType,
    this.isCancelled = false,
  });

  final String orderType;
  final bool isCancelled;

  @override
  Widget build(BuildContext context) {
    if (isCancelled) {
      return _badge('Cancelled', AppColors.danger, AppColors.dangerBg);
    }

    final type = OrderType.fromDbValue(orderType);
    return switch (type) {
      OrderType.dineIn => _badge(type!.label, AppColors.dineIn, AppColors.dineInBg),
      OrderType.takeaway =>
        _badge(type!.label, AppColors.takeaway, AppColors.takeawayBg),
      OrderType.delivery =>
        _badge(type!.label, AppColors.delivery, AppColors.deliveryBg),
      null => _badge(orderType, AppColors.textSecondary, AppColors.surface),
    };
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
