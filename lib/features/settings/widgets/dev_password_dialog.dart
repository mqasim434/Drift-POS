import 'package:flutter/material.dart';

import '../../../core/constants/dev_sql_console.dart';

/// Prompts for the developer password used by SQL console and protected settings.
Future<bool> showDevPasswordDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => const _DevPasswordDialog(),
  );
  return result ?? false;
}

class _DevPasswordDialog extends StatefulWidget {
  const _DevPasswordDialog();

  @override
  State<_DevPasswordDialog> createState() => _DevPasswordDialogState();
}

class _DevPasswordDialogState extends State<_DevPasswordDialog> {
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_passwordController.text == DevSqlConsole.unlockPassword) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() => _error = 'Incorrect password');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter password'),
      content: TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Password',
          errorText: _error,
          suffixIcon: IconButton(
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          ),
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Unlock'),
        ),
      ],
    );
  }
}
