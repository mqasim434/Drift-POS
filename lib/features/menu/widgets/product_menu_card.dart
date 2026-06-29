import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/deal_with_items.dart';
import '../../../core/models/menu_catalog.dart';
import '../../../core/utils/color_utils.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/product_image_widget.dart';

class ProductMenuCard extends StatelessWidget {
  const ProductMenuCard({
    super.key,
    this.product,
    this.deal,
    required this.onAdd,
  }) : assert(product != null || deal != null);

  final MenuProduct? product;
  final DealWithItems? deal;
  final VoidCallback onAdd;

  bool get _isDeal => deal != null;

  String get _name => _isDeal ? deal!.name : product!.name;

  int get _priceInPaisa => _isDeal ? deal!.priceInPaisa : product!.priceInPaisa;

  String? get _imagePath => _isDeal ? deal!.imagePath : product!.imagePath;

  Color get _placeholderColor => _isDeal
      ? AppColors.accent
      : ColorUtils.fromHex(product!.categoryColor);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onAdd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: ProductImageWidget(
                    imagePath: _imagePath,
                    productName: _name,
                    placeholderColor: _placeholderColor,
                    size: 100,
                    borderRadius: 0,
                  ),
                ),
                if (_isDeal)
                  Positioned(
                    top: AppSizes.sm,
                    left: AppSizes.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: AppSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius:
                            BorderRadius.circular(AppSizes.badgeRadius),
                      ),
                      child: Text(
                        'DEAL',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _name,
                      style: AppTextStyles.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      CurrencyFormatter.format(_priceInPaisa),
                      style: AppTextStyles.price,
                    ),
                    const SizedBox(height: AppSizes.sm),
                    OutlinedButton(
                      onPressed: onAdd,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(AppSizes.controlHeight),
                        foregroundColor: AppColors.accent,
                        side: const BorderSide(color: AppColors.borderStrong),
                      ),
                      child: const Text('+ Add'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
