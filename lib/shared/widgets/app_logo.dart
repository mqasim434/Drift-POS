import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';

/// DriftPOS brand mark used in sidebar, settings, and other app chrome.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.height = 48,
    this.fit = BoxFit.contain,
  });

  final double height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.appIcon,
      height: height,
      fit: fit,
      semanticLabel: 'DriftPOS',
    );
  }
}
