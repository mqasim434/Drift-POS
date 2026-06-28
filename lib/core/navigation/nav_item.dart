import 'package:flutter/material.dart';

enum NavItem {
  dashboard(
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    route: '/',
  ),
  menu(
    label: 'Menu',
    icon: Icons.restaurant_menu,
    route: '/menu',
  ),
  orders(
    label: 'Orders',
    icon: Icons.receipt_long_outlined,
    route: '/orders',
  ),
  products(
    label: 'Products',
    icon: Icons.inventory_2_outlined,
    route: '/products',
  ),
  categories(
    label: 'Categories',
    icon: Icons.category_outlined,
    route: '/categories',
  ),
  deals(
    label: 'Deals',
    icon: Icons.local_offer_outlined,
    route: '/deals',
  ),
  tables(
    label: 'Tables',
    icon: Icons.table_restaurant_outlined,
    route: '/tables',
  ),
  analytics(
    label: 'Analytics',
    icon: Icons.bar_chart_outlined,
    route: '/analytics',
  ),
  settings(
    label: 'Settings',
    icon: Icons.settings_outlined,
    route: '/settings',
  );

  const NavItem({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;

  static NavItem? fromRoute(String route) {
    for (final item in NavItem.values) {
      if (item.route == route) return item;
    }
    return null;
  }

  static List<NavItem> get mainItems =>
      NavItem.values.where((item) => item != NavItem.settings).toList();
}
