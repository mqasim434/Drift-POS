import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/navigation/nav_item.dart';
import '../../core/utils/date_formatter.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
  });

  final String currentRoute;
  final ValueChanged<String> onNavigate;

  static const double _itemPaddingH = AppSizes.sm + AppSizes.xs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.sidebarWidth,
      decoration: const BoxDecoration(
        color: AppColors.sidebar,
        border: Border(
          right: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SidebarBrand(),
          const SizedBox(height: AppSizes.md),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
              children: [
                for (final item in NavItem.mainItems)
                  _SidebarNavItem(
                    item: item,
                    isActive: currentRoute == item.route,
                    onNavigate: onNavigate,
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          const _SidebarClock(),
          _SidebarNavItem(
            item: NavItem.settings,
            isActive: currentRoute == NavItem.settings.route,
            onNavigate: onNavigate,
          ),
          const SizedBox(height: AppSizes.sm),
        ],
      ),
    );
  }
}

class _SidebarBrand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.lg,
        AppSizes.md,
        AppSizes.sm,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_fire_department,
            color: AppColors.accent,
            size: AppSizes.lg,
          ),
          const SizedBox(width: AppSizes.sm),
          Text(AppStrings.sidebarBrand, style: AppTextStyles.title),
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatefulWidget {
  const _SidebarNavItem({
    required this.item,
    required this.isActive,
    required this.onNavigate,
  });

  final NavItem item;
  final bool isActive;
  final ValueChanged<String> onNavigate;

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color =
        widget.isActive ? AppColors.accent : AppColors.textSecondary;
    final background = widget.isActive
        ? AppColors.accentBg
        : _hovered
            ? AppColors.surface
            : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.onNavigate(widget.item.route),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: AppSizes.controlHeight,
          margin: const EdgeInsets.symmetric(
            horizontal: AppSizes.sm,
            vertical: AppSizes.xs,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSidebar._itemPaddingH,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            border: widget.isActive
                ? const Border(
                    left: BorderSide(color: AppColors.accent, width: 3),
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(widget.item.icon, size: AppSizes.md + AppSizes.xs, color: color),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  widget.item.label,
                  style: AppTextStyles.subtitle.copyWith(color: color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarClock extends StatefulWidget {
  const _SidebarClock();

  @override
  State<_SidebarClock> createState() => _SidebarClockState();
}

class _SidebarClockState extends State<_SidebarClock> {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _now = DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.sm,
        AppSizes.md,
        AppSizes.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DateFormatter.formatDate(_now), style: AppTextStyles.caption),
          Text(DateFormatter.formatTime(_now), style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
