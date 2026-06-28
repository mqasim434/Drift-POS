import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/navigation/nav_item.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/page_header.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({
    super.key,
    required this.currentRoute,
    required this.child,
    this.actions = const [],
  });

  final String currentRoute;
  final Widget child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final navItem = NavItem.fromRoute(currentRoute);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          AppSidebar(
            currentRoute: currentRoute,
            onNavigate: context.go,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeader(
                  title: navItem?.label ?? 'Drift POS',
                  actions: actions,
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
