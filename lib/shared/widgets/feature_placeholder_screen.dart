import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/navigation/nav_item.dart';
import '../layouts/feature_scaffold.dart';

class FeaturePlaceholderScreen extends StatelessWidget {
  const FeaturePlaceholderScreen({
    super.key,
    required this.navItem,
  });

  final NavItem navItem;

  @override
  Widget build(BuildContext context) {
    return FeatureScaffold(
      title: navItem.label,
      body: ColoredBox(
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
              Text(
                'Coming soon',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
