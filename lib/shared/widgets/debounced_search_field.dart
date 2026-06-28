import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';

class DebouncedSearchField extends StatefulWidget {
  const DebouncedSearchField({
    super.key,
    required this.onChanged,
    this.hintText = 'Search products...',
    this.width = 300,
    this.delay = const Duration(milliseconds: 300),
  });

  final ValueChanged<String> onChanged;
  final String hintText;
  final double width;
  final Duration delay;

  @override
  State<DebouncedSearchField> createState() => _DebouncedSearchFieldState();
}

class _DebouncedSearchFieldState extends State<DebouncedSearchField> {
  final _controller = TextEditingController();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _timer?.cancel();
    _timer = Timer(widget.delay, () => widget.onChanged(value.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: AppSizes.controlHeight,
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
