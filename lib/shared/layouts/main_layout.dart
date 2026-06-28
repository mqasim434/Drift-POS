import 'package:flutter/material.dart';

/// App shell with sidebar and content area — implemented in Module 04.
class MainLayout extends StatelessWidget {
  const MainLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}
