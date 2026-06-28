import 'package:go_router/go_router.dart';

import '../../core/navigation/nav_item.dart';
import '../../shared/layouts/main_layout.dart';
import '../../shared/widgets/feature_placeholder_screen.dart';

final appRouter = GoRouter(
  initialLocation: NavItem.dashboard.route,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(
          currentRoute: state.uri.path,
          child: child,
        );
      },
      routes: [
        for (final item in NavItem.values)
          GoRoute(
            path: item.route,
            builder: (context, state) => FeaturePlaceholderScreen(navItem: item),
          ),
      ],
    ),
  ],
);
