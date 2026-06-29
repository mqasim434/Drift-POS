import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/shop_settings.dart';
import '../../../core/providers/shop_settings_provider.dart';
import 'dev_password_dialog.dart';
import 'settings_section.dart';

class SettingsShopInfoPanel extends ConsumerStatefulWidget {
  const SettingsShopInfoPanel({super.key, required this.settings});

  final ShopSettings settings;

  @override
  ConsumerState<SettingsShopInfoPanel> createState() =>
      _SettingsShopInfoPanelState();
}

class _SettingsShopInfoPanelState extends ConsumerState<SettingsShopInfoPanel> {
  late final TextEditingController _shopNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _currencyController;
  bool _isEditable = false;

  @override
  void initState() {
    super.initState();
    _shopNameController = TextEditingController(text: widget.settings.shopName);
    _addressController = TextEditingController(text: widget.settings.address);
    _phoneController = TextEditingController(text: widget.settings.phone);
    _currencyController =
        TextEditingController(text: widget.settings.currencySymbol);
  }

  @override
  void didUpdateWidget(covariant SettingsShopInfoPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings) {
      _shopNameController.text = widget.settings.shopName;
      _addressController.text = widget.settings.address;
      _phoneController.text = widget.settings.phone;
      _currencyController.text = widget.settings.currencySymbol;
    }
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  Future<void> _unlockEditing() async {
    if (_isEditable) return;
    final unlocked = await showDevPasswordDialog(context);
    if (unlocked && mounted) {
      setState(() => _isEditable = true);
    }
  }

  Future<void> _save() async {
    if (!_isEditable) return;
    await ref.read(shopSettingsNotifierProvider.notifier).patch(
          (current) => current.copyWith(
            shopName: _shopNameController.text.trim(),
            address: _addressController.text.trim(),
            phone: _phoneController.text.trim(),
            currencySymbol: _currencyController.text.trim().isEmpty
                ? 'PKR'
                : _currencyController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Shop Information',
      subtitle: _isEditable
          ? 'Editing enabled for this session. Shown at the top of printed receipts.'
          : 'Shown at the top of printed receipts.',
      onTitleLongPress: _unlockEditing,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_isEditable)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.md),
              child: Text(
                'Editing enabled',
                style: AppTextStyles.caption.copyWith(color: AppColors.success),
              ),
            ),
          TextField(
            controller: _shopNameController,
            readOnly: !_isEditable,
            decoration: const InputDecoration(labelText: 'Shop name'),
            onSubmitted: _isEditable ? (_) => _save() : null,
            onTapOutside: _isEditable ? (_) => _save() : null,
          ),
          const SizedBox(height: AppSizes.md),
          TextField(
            controller: _addressController,
            readOnly: !_isEditable,
            decoration: const InputDecoration(labelText: 'Address'),
            maxLines: 2,
            onSubmitted: _isEditable ? (_) => _save() : null,
            onTapOutside: _isEditable ? (_) => _save() : null,
          ),
          const SizedBox(height: AppSizes.md),
          TextField(
            controller: _phoneController,
            readOnly: !_isEditable,
            decoration: const InputDecoration(labelText: 'Phone number'),
            onSubmitted: _isEditable ? (_) => _save() : null,
            onTapOutside: _isEditable ? (_) => _save() : null,
          ),
          const SizedBox(height: AppSizes.md),
          TextField(
            controller: _currencyController,
            readOnly: !_isEditable,
            decoration: const InputDecoration(
              labelText: 'Currency symbol',
              hintText: 'PKR',
            ),
            onSubmitted: _isEditable ? (_) => _save() : null,
            onTapOutside: _isEditable ? (_) => _save() : null,
          ),
        ],
      ),
    );
  }
}
