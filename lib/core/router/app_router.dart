import 'package:go_router/go_router.dart';

import '../../core/navigation/nav_item.dart';
import '../../features/analytics/analytics_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/categories/categories_screen.dart';
import '../../features/deals/deal_form_screen.dart';
import '../../features/deals/deals_screen.dart';
import '../../features/orders/orders_screen.dart';
import '../../features/menu/menu_screen.dart';
import '../../features/tables/tables_screen.dart';
import '../../features/products/products_screen.dart';
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
        GoRoute(
          path: NavItem.dashboard.route,
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: NavItem.menu.route,
          builder: (context, state) => const MenuScreen(),
        ),
        GoRoute(
          path: NavItem.orders.route,
          builder: (context, state) => const OrdersScreen(),
        ),
        GoRoute(
          path: NavItem.products.route,
          builder: (context, state) => const ProductsScreen(),
        ),
        GoRoute(
          path: NavItem.categories.route,
          builder: (context, state) => const CategoriesScreen(),
        ),
        GoRoute(
          path: NavItem.deals.route,
          builder: (context, state) => const DealsScreen(),
          routes: [
            GoRoute(
              path: 'create',
              builder: (context, state) => const DealFormScreen(),
            ),
            GoRoute(
              path: 'edit/:id',
              builder: (context, state) => DealFormScreen(
                dealId: int.parse(state.pathParameters['id']!),
              ),
            ),
          ],
        ),
        GoRoute(
          path: NavItem.tables.route,
          builder: (context, state) => const TablesScreen(),
        ),
        GoRoute(
          path: NavItem.analytics.route,
          builder: (context, state) => const AnalyticsScreen(),
        ),
        GoRoute(
          path: NavItem.settings.route,
          builder: (context, state) =>
              const FeaturePlaceholderScreen(navItem: NavItem.settings),
        ),
      ],
    ),
  ],
);
