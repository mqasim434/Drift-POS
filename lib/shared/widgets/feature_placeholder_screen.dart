import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/navigation/nav_item.dart';

class FeaturePlaceholderScreen extends StatelessWidget {
  const FeaturePlaceholderScreen({
    super.key,
    required this.navItem,
  });

  final NavItem navItem;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              navItem.icon,
              size: AppSizes.xxl,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: AppSizes.md),
            Text(navItem.label, style: AppTextStyles.headline),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Coming soon',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
