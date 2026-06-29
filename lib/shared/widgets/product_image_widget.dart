import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/services/image_storage_service.dart';

class ProductImageWidget extends StatelessWidget {
  const ProductImageWidget({
    super.key,
    this.imagePath,
    required this.productName,
    this.placeholderColor = AppColors.surfaceElevated,
    this.size = AppSizes.controlHeightLg,
    this.borderRadius = AppSizes.buttonRadius,
    this.fill = false,
  });

  final String? imagePath;
  final String productName;
  final Color placeholderColor;
  final double size;
  final double borderRadius;
  final bool fill;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: ImageStorageService.resolveImageFile(imagePath),
      builder: (context, snapshot) {
        final file = snapshot.data;
        if (file != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: fill
                ? Image.file(
                    file,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    cacheWidth: 400,
                    errorBuilder: (_, __, ___) => _Placeholder(
                      productName: productName,
                      placeholderColor: placeholderColor,
                      size: size,
                      borderRadius: borderRadius,
                      fill: fill,
                    ),
                  )
                : Image.file(
                    file,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    cacheWidth: size.toInt() * 2,
                    cacheHeight: size.toInt() * 2,
                    errorBuilder: (_, __, ___) => _Placeholder(
                      productName: productName,
                      placeholderColor: placeholderColor,
                      size: size,
                      borderRadius: borderRadius,
                      fill: fill,
                    ),
                  ),
          );
        }

        return _Placeholder(
          productName: productName,
          placeholderColor: placeholderColor,
          size: size,
          borderRadius: borderRadius,
          fill: fill,
        );
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.productName,
    required this.placeholderColor,
    required this.size,
    required this.borderRadius,
    this.fill = false,
  });

  final String productName;
  final Color placeholderColor;
  final double size;
  final double borderRadius;
  final bool fill;

  @override
  Widget build(BuildContext context) {
    final initial =
        productName.isNotEmpty ? productName.characters.first.toUpperCase() : '?';

    return Container(
      width: fill ? double.infinity : size,
      height: fill ? double.infinity : size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: placeholderColor.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(borderRadius),
        border: fill ? null : Border.all(color: AppColors.border),
      ),
      child: Text(
        initial,
        style: AppTextStyles.title.copyWith(
          color: placeholderColor,
          fontSize: fill ? 28 : null,
        ),
      ),
    );
  }
}
