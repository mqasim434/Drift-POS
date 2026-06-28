import 'package:flutter/material.dart';

import '../widgets/page_header.dart';

/// Standard feature page layout: header + scrollable body.
class FeatureScaffold extends StatelessWidget {
  const FeatureScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
  });

  final String title;
  final Widget body;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(title: title, actions: actions),
        Expanded(child: body),
      ],
    );
  }
}
