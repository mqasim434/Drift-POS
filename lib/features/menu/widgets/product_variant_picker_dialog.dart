import 'package:flutter/material.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/menu_catalog.dart';
import '../../../core/utils/currency_formatter.dart';

Future<MenuProductVariant?> showProductVariantPicker(
  BuildContext context,
  MenuProduct product,
) {
  return showDialog<MenuProductVariant>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Choose variant — ${product.name}'),
      content: SizedBox(
        width: 320,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: product.variants.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final variant = product.variants[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(variant.name, style: AppTextStyles.body),
              trailing: Text(
                CurrencyFormatter.format(variant.priceInPaisa),
                style: AppTextStyles.price,
              ),
              onTap: () => Navigator.of(context).pop(variant),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}
