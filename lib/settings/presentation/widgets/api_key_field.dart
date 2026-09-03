import 'package:flutter/material.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class ApiKeyField extends StatefulWidget {
  const ApiKeyField({
    super.key,
    required this.currentApiKey,
    required this.onRegistrationRequested,
  });

  final String? currentApiKey;
  final VoidCallback onRegistrationRequested;

  @override
  State<ApiKeyField> createState() => _ApiKeyFieldState();
}

class _ApiKeyFieldState extends State<ApiKeyField> {
  late final TextEditingController _controller;
  bool _obscureText = true;

  String get _currentApiKey => widget.currentApiKey ?? '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _currentApiKey);
  }

  @override
  void didUpdateWidget(ApiKeyField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentApiKey != widget.currentApiKey) {
      _controller.text = _currentApiKey;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: context.t.onboarding.apiKeyLabel,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => setState(() => _obscureText = !_obscureText),
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
            ),
            IconButton(
              onPressed: widget.onRegistrationRequested,
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
