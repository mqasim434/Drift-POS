import '../database/app_database.dart';
import '../models/sql_execution_result.dart';

class SqlConsoleService {
  const SqlConsoleService();

  Future<SqlExecutionResult> execute(AppDatabase db, String sql) async {
    final trimmed = sql.trim();
    if (trimmed.isEmpty) {
      return const SqlExecutionResult(
        durationMs: 0,
        error: 'SQL is empty.',
      );
    }

    final started = DateTime.now();
    try {
      if (_isReadQuery(trimmed)) {
        final rows = await db.customSelect(trimmed).get();
        return SqlExecutionResult(
          durationMs: DateTime.now().difference(started).inMilliseconds,
          rows: rows.map((row) => row.data).toList(),
        );
      }

      await db.customStatement(trimmed);
      db.notifyStreamQueriesOfExternalWrite();
      final meta = await db
          .customSelect(
            'SELECT changes() AS affected, last_insert_rowid() AS rowid',
          )
          .getSingle();
      final affected = meta.read<int>('affected');
      final rowId = meta.read<int>('rowid');

      return SqlExecutionResult(
        durationMs: DateTime.now().difference(started).inMilliseconds,
        rowsAffected: affected,
        rows: rowId > 0
            ? [
                {'last_insert_rowid': rowId, 'changes': affected},
              ]
            : const [],
      );
    } catch (error) {
      return SqlExecutionResult(
        durationMs: DateTime.now().difference(started).inMilliseconds,
        error: error.toString(),
      );
    }
  }

  bool _isReadQuery(String sql) {
    final head = sql.trimLeft().toUpperCase();
    return head.startsWith('SELECT') ||
        head.startsWith('WITH') ||
        head.startsWith('PRAGMA') ||
        head.startsWith('EXPLAIN');
  }
}
