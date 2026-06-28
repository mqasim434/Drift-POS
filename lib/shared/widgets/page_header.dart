import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.actions = const [],
  });

  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.controlHeightLg + AppSizes.md,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: AppTextStyles.headline),
          ),
          if (actions.isNotEmpty) ...[
            const SizedBox(width: AppSizes.md),
            ...actions,
          ],
        ],
      ),
    );
  }
}
