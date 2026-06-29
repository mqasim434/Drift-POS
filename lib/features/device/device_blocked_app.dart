import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/services/device_binding_service.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_logo.dart';
import '../settings/widgets/dev_password_dialog.dart';

class DeviceBlockedApp extends StatelessWidget {
  const DeviceBlockedApp({
    super.key,
    required this.reason,
    this.onReauthorized,
  });

  final String reason;
  final VoidCallback? onReauthorized;

  Future<void> _tryRebind(BuildContext context) async {
    final unlocked = await showDevPasswordDialog(context);
    if (!unlocked || !context.mounted) return;

    try {
      await DeviceBindingService.rebindCurrentDevice();
      if (!context.mounted) return;
      onReauthorized?.call();
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not rebind device: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onLongPress: () => _tryRebind(context),
                    child: const AppLogo(height: 72),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text(
                    'Device Not Authorized',
                    style: AppTextStyles.headline,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.md),
                  Text(
                    reason,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text(
                    'This installation can only run on the device where it was '
                    'first activated.',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
