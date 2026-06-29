class SqlExecutionResult {
  const SqlExecutionResult({
    required this.durationMs,
    this.rows = const [],
    this.rowsAffected,
    this.error,
  });

  final List<Map<String, Object?>> rows;
  final int? rowsAffected;
  final String? error;
  final int durationMs;

  bool get isSuccess => error == null;
  bool get isQuery => rowsAffected == null && error == null;

  String get summary {
    if (error != null) return 'Error';
    if (rowsAffected != null) {
      return '$rowsAffected row(s) affected (${durationMs}ms)';
    }
    return '${rows.length} row(s) (${durationMs}ms)';
  }
}
