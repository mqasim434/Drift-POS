import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/providers/shop_settings_provider.dart';
import '../../core/models/shop_settings.dart';
import '../../shared/layouts/feature_scaffold.dart';
import 'models/settings_category.dart';
import 'widgets/settings_data_panel.dart';
import 'widgets/settings_printer_panel.dart';
import 'widgets/settings_receipt_panel.dart';
import 'widgets/settings_shop_info_panel.dart';
import 'widgets/settings_tax_panel.dart';

final settingsCategoryProvider =
    StateProvider<SettingsCategory>((ref) => SettingsCategory.shopInfo);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(shopSettingsNotifierProvider);
    final category = ref.watch(settingsCategoryProvider);

    return FeatureScaffold(
      title: 'Settings',
      body: settingsAsync.when(
        data: (settings) => Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 240,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: AppColors.border)),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                  children: [
                    for (final item in SettingsCategory.values)
                      _CategoryTile(
                        category: item,
                        selected: category == item,
                        onTap: () => ref
                            .read(settingsCategoryProvider.notifier)
                            .state = item,
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: _SettingsPanelContent(
                  category: category,
                  settings: settings,
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            error.toString(),
            style: const TextStyle(color: AppColors.danger),
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final SettingsCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      selectedTileColor: AppColors.accentBg,
      leading: Icon(
        category.icon,
        color: selected ? AppColors.accent : AppColors.textSecondary,
      ),
      title: Text(
        category.label,
        style: selected ? AppTextStyles.subtitle : AppTextStyles.body,
      ),
      onTap: onTap,
    );
  }
}

class _SettingsPanelContent extends StatelessWidget {
  const _SettingsPanelContent({
    required this.category,
    required this.settings,
  });

  final SettingsCategory category;
  final ShopSettings settings;

  @override
  Widget build(BuildContext context) {
    return switch (category) {
      SettingsCategory.shopInfo => SettingsShopInfoPanel(settings: settings),
      SettingsCategory.taxBilling => SettingsTaxPanel(settings: settings),
      SettingsCategory.receipt => SettingsReceiptPanel(settings: settings),
      SettingsCategory.printer => SettingsPrinterPanel(settings: settings),
      SettingsCategory.data => const SettingsDataPanel(),
    };
  }
}
