import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class QuantityCounter extends StatefulWidget {
  final int quantity;
  final ColorScheme colorScheme;
  final Function(int) onQuantityChanged;

  const QuantityCounter({
    Key? key,
    required this.quantity,
    required this.colorScheme,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<QuantityCounter> createState() => _QuantityCounterState();
}

class _QuantityCounterState extends State<QuantityCounter> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.quantity.toString());
  }

  @override
  void didUpdateWidget(QuantityCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _controller.text = widget.quantity.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateQuantity(int value) {
    if (value < 1) value = 1;
    widget.onQuantityChanged(value);
  }

  void _decreaseQuantity() {
    if (widget.quantity > 1) {
      _updateQuantity(widget.quantity - 1);
    }
  }

  void _increaseQuantity() {
    _updateQuantity(widget.quantity + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      width: 35.w,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.colorScheme.outline.withOpacity(0.2),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            icon: Icons.remove,
            onPressed: widget.quantity > 1 ? _decreaseQuantity : null,
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
          _QuantityButton(icon: Icons.add, onPressed: _increaseQuantity),
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
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 20,
        color: onPressed != null ? Colors.black87 : Colors.grey[400],
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      splashRadius: 20,
    );
  }
}
