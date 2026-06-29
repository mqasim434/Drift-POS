import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:drift_pos/app.dart';
import 'package:drift_pos/core/database/app_database.dart';
import 'package:drift_pos/core/navigation/nav_item.dart';
import 'package:drift_pos/core/providers/database_init_provider.dart';
import 'package:drift_pos/core/providers/database_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  Future<ProviderContainer> createTestContainer() async {
    final db = AppDatabase.test();
    addTearDown(db.close);

    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
    );
    addTearDown(container.dispose);
    await container.read(databaseInitProvider.future);
    return container;
  }

  testWidgets('POSApp launches with sidebar navigation', (WidgetTester tester) async {
    final container = await createTestContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const POSApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(POSApp), findsOneWidget);
    expect(find.text('QuickPOS'), findsOneWidget);

    for (final item in NavItem.mainItems) {
      expect(find.text(item.label), findsWidgets);
    }
    expect(find.text(NavItem.settings.label), findsWidgets);
  });

  testWidgets('navigating to Menu updates the page', (WidgetTester tester) async {
    final container = await createTestContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const POSApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.text('Menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Cart (0 items)'), findsOneWidget);
    expect(find.text('Place Order'), findsOneWidget);
  });
}
