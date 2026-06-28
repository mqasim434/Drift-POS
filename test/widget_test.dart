import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:drift_pos/app.dart';
import 'package:drift_pos/core/navigation/nav_item.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('POSApp launches with sidebar navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: POSApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(POSApp), findsOneWidget);
    expect(find.text('QuickPOS'), findsOneWidget);

    for (final item in NavItem.mainItems) {
      expect(find.text(item.label), findsWidgets);
    }
    expect(find.text(NavItem.settings.label), findsWidgets);
  });

  testWidgets('navigating to Menu updates the page', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: POSApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();

    expect(find.text('Products'), findsWidgets);
    expect(find.text('Coming soon'), findsOneWidget);
  });
}
