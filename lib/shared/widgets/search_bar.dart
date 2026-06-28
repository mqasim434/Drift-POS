import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';

/// Reusable search input — implemented in later modules.
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.hintText = 'Search...',
    this.onChanged,
  });

  final String hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.controlHeight,
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
