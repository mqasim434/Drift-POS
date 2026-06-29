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
    this.displayPriceInPaisa,
  }) : assert(product != null || deal != null);

  final MenuProduct? product;
  final DealWithItems? deal;
  final VoidCallback onAdd;
  final int? displayPriceInPaisa;

  bool get _isDeal => deal != null;

  String get _name => _isDeal ? deal!.name : product!.name;

  int get _priceInPaisa =>
      displayPriceInPaisa ??
      (_isDeal ? deal!.priceInPaisa : product!.displayPriceInPaisa);

  String get _priceLabel {
    if (_isDeal) return CurrencyFormatter.format(_priceInPaisa);
    if (product!.hasVariants) {
      return 'From ${CurrencyFormatter.format(_priceInPaisa)}';
    }
    return CurrencyFormatter.format(_priceInPaisa);
  }

  String? get _imagePath => _isDeal ? deal!.imagePath : product!.imagePath;

  Color get _placeholderColor => _isDeal
      ? AppColors.accent
      : ColorUtils.fromHex(product!.categoryColor);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onAdd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 13,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ProductImageWidget(
                    imagePath: _imagePath,
                    productName: _name,
                    placeholderColor: _placeholderColor,
                    borderRadius: 0,
                    fill: true,
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
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.sm,
                  AppSizes.sm,
                  AppSizes.sm,
                  AppSizes.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _name,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            _priceLabel,
                            style: AppTextStyles.price.copyWith(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSizes.xs),
                        Material(
                          color: AppColors.accentBg,
                          borderRadius:
                              BorderRadius.circular(AppSizes.buttonRadius),
                          child: InkWell(
                            onTap: onAdd,
                            borderRadius:
                                BorderRadius.circular(AppSizes.buttonRadius),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.sm,
                                vertical: AppSizes.xs,
                              ),
                              child: Icon(
                                Icons.add,
                                size: 18,
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                        ),
                      ],
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
