import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class QuantityCounter extends StatefulWidget {
  final int quantity;
  final Function(int) onQuantityChanged;

  const QuantityCounter({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  State<QuantityCounter> createState() => _QuantityCounterState();
}

class _QuantityCounterState extends State<QuantityCounter> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 6.h,
      width: 35.w,
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            icon: Icons.remove,
            onPressed: widget.quantity > 1
                ? () => widget.onQuantityChanged(widget.quantity - 1)
                : null,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                widget.quantity.toString(),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          _QuantityButton(
            icon: Icons.add,
            onPressed: () => widget.onQuantityChanged(widget.quantity + 1),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _QuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 20,
        color: onPressed != null
            ? colorScheme.onSurface
            : colorScheme.secondary,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      splashRadius: 20,
    );
  }
}
