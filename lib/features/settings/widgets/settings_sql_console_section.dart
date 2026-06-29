import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/dev_sql_console.dart';
import '../../../core/models/sql_execution_result.dart';
import '../providers/sql_console_provider.dart';
import 'settings_section.dart';

class SettingsSqlConsoleSection extends ConsumerStatefulWidget {
  const SettingsSqlConsoleSection({super.key});

  @override
  ConsumerState<SettingsSqlConsoleSection> createState() =>
      _SettingsSqlConsoleSectionState();
}

class _SettingsSqlConsoleSectionState
    extends ConsumerState<SettingsSqlConsoleSection> {
  final _passwordController = TextEditingController();
  final _sqlController = TextEditingController();
  bool _obscurePassword = true;
  bool _isRunning = false;
  SqlExecutionResult? _lastResult;
  String? _passwordError;

  @override
  void dispose() {
    _passwordController.dispose();
    _sqlController.dispose();
    super.dispose();
  }

  void _unlock() {
    if (_passwordController.text == DevSqlConsole.unlockPassword) {
      setState(() {
        _passwordError = null;
      });
      ref.read(sqlConsoleUnlockedProvider.notifier).state = true;
      return;
    }

    setState(() {
      _passwordError = 'Incorrect password';
    });
  }

  void _lock() {
    ref.read(sqlConsoleUnlockedProvider.notifier).state = false;
    _passwordController.clear();
    setState(() {
      _passwordError = null;
      _lastResult = null;
    });
  }

  Future<void> _runSql() async {
    setState(() {
      _isRunning = true;
      _lastResult = null;
    });

    try {
      final result =
          await ref.read(sqlConsoleProvider).execute(_sqlController.text);
      if (mounted) setState(() => _lastResult = result);
    } finally {
      if (mounted) setState(() => _isRunning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = ref.watch(sqlConsoleUnlockedProvider);

    return SettingsSection(
      title: 'SQL Console',
      subtitle: unlocked
          ? 'Run read/write SQL directly against the local database.'
          : 'Developer tool — password required.',
      child: unlocked ? _buildConsole() : _buildLockGate(),
    );
  }

  Widget _buildLockGate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: _passwordError,
            suffixIcon: IconButton(
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              icon: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              ),
            ),
          ),
          onSubmitted: (_) => _unlock(),
        ),
        const SizedBox(height: AppSizes.md),
        ElevatedButton(
          onPressed: _unlock,
          child: const Text('Unlock SQL Console'),
        ),
      ],
    );
  }

  Widget _buildConsole() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Unlocked for this session',
                style: AppTextStyles.caption.copyWith(color: AppColors.success),
              ),
            ),
            TextButton(onPressed: _lock, child: const Text('Lock')),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        TextField(
          controller: _sqlController,
          decoration: const InputDecoration(
            labelText: 'SQL',
            hintText: 'SELECT * FROM orders LIMIT 10;',
            alignLabelWithHint: true,
          ),
          minLines: 4,
          maxLines: 8,
          style: const TextStyle(fontFamily: 'Courier', fontSize: 13),
        ),
        const SizedBox(height: AppSizes.md),
        ElevatedButton.icon(
          onPressed: _isRunning ? null : _runSql,
          icon: _isRunning
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.play_arrow_outlined),
          label: const Text('Run SQL'),
        ),
        if (_lastResult != null) ...[
          const SizedBox(height: AppSizes.lg),
          _ResultPanel(result: _lastResult!),
        ],
      ],
    );
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({required this.result});

  final SqlExecutionResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: result.isSuccess ? AppColors.border : AppColors.danger,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            result.summary,
            style: AppTextStyles.subtitle.copyWith(
              color: result.isSuccess ? AppColors.textPrimary : AppColors.danger,
            ),
          ),
          if (result.error != null) ...[
            const SizedBox(height: AppSizes.sm),
            SelectableText(
              result.error!,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger),
            ),
          ] else if (result.isQuery) ...[
            const SizedBox(height: AppSizes.sm),
            if (result.rows.isEmpty)
              Text('No rows returned.', style: AppTextStyles.bodySmall)
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _ResultsTable(rows: result.rows),
              ),
          ],
        ],
      ),
    );
  }
}

class _ResultsTable extends StatelessWidget {
  const _ResultsTable({required this.rows});

  final List<Map<String, Object?>> rows;

  @override
  Widget build(BuildContext context) {
    final columns = rows.first.keys.toList();

    return DataTable(
      headingRowHeight: 36,
      dataRowMinHeight: 32,
      dataRowMaxHeight: 48,
      columns: [
        for (final column in columns)
          DataColumn(label: Text(column, style: AppTextStyles.caption)),
      ],
      rows: [
        for (final row in rows.take(200))
          DataRow(
            cells: [
              for (final column in columns)
                DataCell(
                  Text(
                    '${row[column]}',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
