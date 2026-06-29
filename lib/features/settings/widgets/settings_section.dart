import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.onTitleLongPress,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final VoidCallback? onTitleLongPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onLongPress: onTitleLongPress,
              behavior: HitTestBehavior.opaque,
              child: Text(title, style: AppTextStyles.subtitle),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSizes.xs),
              Text(subtitle!, style: AppTextStyles.caption),
            ],
            const SizedBox(height: AppSizes.md),
            child,
          ],
        ),
      ),
    );
  }
}

class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: AppTextStyles.body),
      subtitle:
          subtitle != null ? Text(subtitle!, style: AppTextStyles.caption) : null,
      value: value,
      onChanged: onChanged,
    );
  }
}
