import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:drift_pos/app.dart';

void main() {
  testWidgets('POSApp launches blank window', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: POSApp(),
      ),
    );

    expect(find.byType(POSApp), findsOneWidget);
  });
}
