import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController textController;
  final FormFieldValidator<String?> validator;
  final String label;
  final String hint;
  final bool obscureText;
  final IconData prefixIcon;
  final TextInputType keyboardType;

  const CustomTextFormField({
    super.key,
    required this.textController,
    required this.validator,
    required this.label,
    required this.hint,
    required this.obscureText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.emailAddress,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: widget.textController,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      style: theme.textTheme.bodyMedium,
      obscureText: widget.obscureText ? obscure : false,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: Icon(widget.prefixIcon, color: colorScheme.primary),

        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  setState(() => obscure = !obscure);
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withAlpha(50),
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
