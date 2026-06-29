import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/tables_provider.dart';

class TableCard extends StatelessWidget {
  const TableCard({
    super.key,
    required this.viewModel,
    required this.onEdit,
    required this.onDelete,
  });

  final TableViewModel viewModel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final table = viewModel.table;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.table_restaurant_outlined,
              size: AppSizes.xl,
              color: table.isActive ? AppColors.accent : AppColors.textMuted,
            ),
            const SizedBox(height: AppSizes.sm),
            Text(table.name, style: AppTextStyles.subtitle),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Capacity: ${table.capacity} persons',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: AppSizes.sm),
            _StatusBadge(
              isActive: table.isActive,
              isOccupied: viewModel.isOccupied,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onEdit,
                    child: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDelete,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(color: AppColors.danger),
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.isActive,
    required this.isOccupied,
  });

  final bool isActive;
  final bool isOccupied;

  @override
  Widget build(BuildContext context) {
    if (!isActive) {
      return _badge('Inactive', AppColors.textMuted, AppColors.surface);
    }

    if (isOccupied) {
      return _badge('Occupied', AppColors.warning, AppColors.warningBg);
    }

    return _badge('Available', AppColors.success, AppColors.successBg);
  }

  Widget _badge(String label, Color textColor, Color backgroundColor) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
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
      ),
    );
  }
}
