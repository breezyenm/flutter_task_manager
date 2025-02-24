import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final GlobalKey<FormState>? formKey;

  const StyledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (formKey?.currentState?.validate() ?? true) {
          onPressed();
        }
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        foregroundColor: isPrimary
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSurface,
        backgroundColor:
            isPrimary ? Theme.of(context).colorScheme.primary : null,
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Text(text),
    );
  }
}
