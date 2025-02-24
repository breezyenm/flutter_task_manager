import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String hintText;
  final bool autofocus;
  final int? maxLines;
  final EdgeInsets? contentPadding;
  final String? Function(String?)? validator;

  const StyledTextField({
    super.key,
    required this.controller,
    this.label,
    required this.hintText,
    this.autofocus = false,
    this.maxLines = 1,
    this.contentPadding,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.36),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          autofocus: autofocus,
          maxLines: maxLines,
          validator: validator,
        ),
      ],
    );
  }
}
