import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/sql_execution_result.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/services/sql_console_service.dart';

final sqlConsoleUnlockedProvider = StateProvider<bool>((ref) => false);

final sqlConsoleServiceProvider =
    Provider<SqlConsoleService>((ref) => const SqlConsoleService());

final sqlConsoleProvider = Provider<SqlConsoleController>((ref) {
  return SqlConsoleController(ref);
});

class SqlConsoleController {
  SqlConsoleController(this.ref);

  final Ref ref;

  Future<SqlExecutionResult> execute(String sql) async {
    final db = ref.read(databaseProvider);
    return ref.read(sqlConsoleServiceProvider).execute(db, sql);
  }
}
