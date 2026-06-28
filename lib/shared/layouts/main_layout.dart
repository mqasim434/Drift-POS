import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../widgets/app_sidebar.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({
    super.key,
    required this.currentRoute,
    required this.child,
  });

  final String currentRoute;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          AppSidebar(
            currentRoute: currentRoute,
            onNavigate: context.go,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
