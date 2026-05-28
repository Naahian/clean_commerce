import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  final String title;
  final String currentValue;
  final Function(String) onSave;
  final TextInputType inputType;
  final String? hintText;
  final String? Function(String)? validator;
  final bool isSelectable;
  final List<String>? options;

  const EditDialog({
    super.key,
    required this.title,
    required this.currentValue,
    required this.onSave,
    this.inputType = TextInputType.text,
    this.hintText,
    this.validator,
    this.isSelectable = false,
    this.options,
  });

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.currentValue;
    // Ensure selected value exists in options
    if (widget.isSelectable && widget.options != null) {
      _selectedValue = widget.options!.contains(widget.currentValue)
          ? widget.currentValue
          : widget.options!.first;
      _controller.text = _selectedValue;
    } else {
      _selectedValue = widget.currentValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(widget.title, style: theme.textTheme.titleLarge),
      content: Form(
        key: _formKey,
        child: widget.isSelectable
            ? DropdownButtonFormField<String>(
                initialValue: _selectedValue,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
                items: widget.options?.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value!;
                    _controller.text = value;
                  });
                },
                validator: (val) {
                  if (val == null) return "*required";
                  return null;
                },
              )
            : TextFormField(
                controller: _controller,
                keyboardType: widget.inputType,
                decoration: InputDecoration(
                  hintText: widget.hintText ?? 'Enter ${widget.title}',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
                autofocus: true,
                validator: (val) {
                  if (val == null) return "*required";
                  return null;
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(_controller.text.trim());
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Usage with selectable options
void _showSelectableEditDialog(
  BuildContext context,
  String title,
  String currentValue,
  Function(String) onSave,
  List<String> options,
) {
  showDialog(
    context: context,
    builder: (context) => EditDialog(
      title: title,
      currentValue: currentValue,
      onSave: onSave,
      inputType: TextInputType.text,
      isSelectable: true,
      options: options,
      validator: (val) {
        return null;
      },
    ),
  );
}

// Usage with text input
void _showEditDialog(
  BuildContext context,
  String title,
  String currentValue,
  Function(String) onSave,
  TextInputType inputType,
) {
  showDialog(
    context: context,
    builder: (context) => EditDialog(
      title: title,
      currentValue: currentValue,
      onSave: onSave,
      inputType: inputType,
      validator: (value) {
        if (value.isEmpty) {
          return 'This field cannot be empty';
        }
        if (title == 'Phone Number' && value.length < 10) {
          return 'Enter a valid phone number';
        }
        return null;
      },
    ),
  );
}
