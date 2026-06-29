import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/models/shop_settings.dart';
import '../../../core/providers/shop_settings_provider.dart';
import 'settings_section.dart';

class SettingsTaxPanel extends ConsumerStatefulWidget {
  const SettingsTaxPanel({super.key, required this.settings});

  final ShopSettings settings;

  @override
  ConsumerState<SettingsTaxPanel> createState() => _SettingsTaxPanelState();
}

class _SettingsTaxPanelState extends ConsumerState<SettingsTaxPanel> {
  late final TextEditingController _taxLabelController;
  late double _taxRate;

  @override
  void initState() {
    super.initState();
    _taxLabelController = TextEditingController(text: widget.settings.taxLabel);
    _taxRate = widget.settings.taxRatePercent.clamp(0, 30);
  }

  @override
  void didUpdateWidget(covariant SettingsTaxPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings) {
      _taxLabelController.text = widget.settings.taxLabel;
      _taxRate = widget.settings.taxRatePercent.clamp(0, 30);
    }
  }

  @override
  void dispose() {
    _taxLabelController.dispose();
    super.dispose();
  }

  Future<void> _saveTaxLabel() async {
    await ref.read(shopSettingsNotifierProvider.notifier).patch(
          (current) => current.copyWith(
            taxLabel: _taxLabelController.text.trim().isEmpty
                ? 'Tax'
                : _taxLabelController.text.trim(),
          ),
        );
  }

  Future<void> _saveTaxRate(double rate) async {
    setState(() => _taxRate = rate);
    await ref.read(shopSettingsNotifierProvider.notifier).patch(
          (current) => current.copyWith(taxRatePercent: rate),
        );
  }

  Future<void> _saveIncludeTax(bool value) async {
    await ref.read(shopSettingsNotifierProvider.notifier).patch(
          (current) => current.copyWith(includeTaxInPriceDisplay: value),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Tax & Billing',
      subtitle: 'Tax rate is applied to cart totals and saved on each order.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tax rate: ${_taxRate.toStringAsFixed(_taxRate.truncateToDouble() == _taxRate ? 0 : 1)}%',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Slider(
            value: _taxRate,
            min: 0,
            max: 30,
            divisions: 60,
            label: '${_taxRate.toStringAsFixed(1)}%',
            onChanged: _saveTaxRate,
          ),
          const SizedBox(height: AppSizes.md),
          TextField(
            controller: _taxLabelController,
            decoration: const InputDecoration(
              labelText: 'Tax label',
              hintText: 'GST, VAT, Tax',
            ),
            onSubmitted: (_) => _saveTaxLabel(),
            onTapOutside: (_) => _saveTaxLabel(),
          ),
          const SizedBox(height: AppSizes.sm),
          SettingsSwitchTile(
            title: 'Include tax in menu price display',
            subtitle: 'Shows tax-inclusive prices on the menu screen.',
            value: widget.settings.includeTaxInPriceDisplay,
            onChanged: _saveIncludeTax,
          ),
        ],
      ),
    );
  }
}
