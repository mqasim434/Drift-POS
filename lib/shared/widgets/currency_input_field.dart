import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';

class CurrencyInputField extends FormField<int> {
  CurrencyInputField({
    super.key,
    int initialPaisa = 0,
    this.labelText = 'Price',
  }) : super(
          initialValue: initialPaisa,
          validator: (value) {
            if (value == null || value <= 0) {
              return 'Enter a valid price';
            }
            return null;
          },
          builder: (field) {
            return _CurrencyInputBody(
              field: field,
              labelText: labelText,
            );
          },
        );

  final String labelText;
}

class _CurrencyInputBody extends StatefulWidget {
  const _CurrencyInputBody({
    required this.field,
    required this.labelText,
  });

  final FormFieldState<int> field;
  final String labelText;

  @override
  State<_CurrencyInputBody> createState() => _CurrencyInputBodyState();
}

class _CurrencyInputBodyState extends State<_CurrencyInputBody> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: _formatDisplay(widget.field.value ?? 0),
    );
  }

  @override
  void didUpdateWidget(_CurrencyInputBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextValue = widget.field.value ?? 0;
    final currentPaisa = _parsePaisa(_controller.text) ?? 0;
    if (nextValue != currentPaisa) {
      _controller.text = _formatDisplay(nextValue);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDisplay(int paisa) {
    if (paisa == 0) return '';
    return CurrencyFormatter.paisaToRupees(paisa).toStringAsFixed(2);
  }

  int? _parsePaisa(String value) {
    final normalized = value.replaceAll(',', '').trim();
    if (normalized.isEmpty) return 0;
    final parsed = double.tryParse(normalized);
    if (parsed == null) return null;
    return CurrencyFormatter.rupeesToPaisa(parsed);
  }

  void _handleChanged(String value) {
    widget.field.didChange(_parsePaisa(value));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixText: 'PKR ',
        prefixStyle: AppTextStyles.body,
        errorText: widget.field.errorText,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      onChanged: _handleChanged,
    );
  }
}
