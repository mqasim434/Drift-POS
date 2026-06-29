import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/database/app_database.dart';
import '../providers/tables_provider.dart';

class TableFormDialog extends ConsumerStatefulWidget {
  const TableFormDialog({super.key, this.table});

  final RestaurantTable? table;

  static Future<void> show(
    BuildContext context, {
    RestaurantTable? table,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => TableFormDialog(table: table),
    );
  }

  @override
  ConsumerState<TableFormDialog> createState() => _TableFormDialogState();
}

class _TableFormDialogState extends ConsumerState<TableFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _capacityController;
  bool _isActive = true;
  bool _isSaving = false;

  bool get _isEditing => widget.table != null;

  @override
  void initState() {
    super.initState();
    final table = widget.table;
    _nameController = TextEditingController(text: table?.name ?? '');
    _capacityController = TextEditingController(
      text: '${table?.capacity ?? 4}',
    );
    _isActive = table?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final capacity = int.tryParse(_capacityController.text.trim()) ?? 4;
      final notifier = ref.read(tablesNotifierProvider.notifier);

      if (_isEditing) {
        await notifier.updateTable(
          widget.table!.copyWith(
            name: _nameController.text.trim(),
            capacity: capacity,
            isActive: _isActive,
          ),
        );
      } else {
        await notifier.addTable(
          RestaurantTablesCompanion.insert(
            name: _nameController.text.trim(),
            capacity: Value(capacity),
            isActive: Value(_isActive),
          ),
        );
      }

      if (mounted) Navigator.of(context).pop();
    } on TableException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Table' : 'Add Table'),
      content: SizedBox(
        width: 360,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Table 1',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.md),
              TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(labelText: 'Capacity'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  final parsed = int.tryParse(value?.trim() ?? '');
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid capacity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.sm),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Active'),
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: AppSizes.md,
                  height: AppSizes.md,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
