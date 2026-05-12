import 'package:clean_commerce/core/constansts.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OrderTrackline extends StatelessWidget {
  final OrderStatus status;

  const OrderTrackline({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final List<OrderStatus> steps = [
      OrderStatus.pending,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ];

    final currentIndex = steps.indexOf(status);

    return Row(
      children: List.generate(steps.length, (index) {
        final isCompleted = index <= currentIndex;
        final isLast = index == steps.length - 1;

        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _beforeTrackLine(index, isCompleted),
                  Container(
                    padding: EdgeInsets.all(14.sp),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? Colors.green.withAlpha(200)
                          : Colors.grey.withAlpha(200),
                      border: BoxBorder.all(
                        color: isCompleted ? Colors.green : Colors.grey,
                      ),
                    ),
                    child: Icon(
                      _getIcon(steps[index]),
                      size: 20.sp,
                      color: Colors.white,
                    ),
                  ),

                  _afterTrackLine(isLast, isCompleted),
                ],
              ),
              SizedBox(height: 4),
              Text(
                _getLabel(steps[index]),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isCompleted ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Expanded _afterTrackLine(bool isLast, bool isCompleted) {
    return !isLast
        ? Expanded(
            child: Container(
              height: 2,
              color: isCompleted ? Colors.green : Colors.grey,
            ),
          )
        : Expanded(child: SizedBox());
  }

  Expanded _beforeTrackLine(int index, bool isCompleted) {
    return index != 0
        ? Expanded(
            child: Container(
              height: 2,
              color: isCompleted ? Colors.green : Colors.grey,
            ),
          )
        : Expanded(child: SizedBox());
  }

  IconData _getIcon(OrderStatus step) {
    switch (step) {
      case OrderStatus.pending:
        return Icons.shopping_cart;
      case OrderStatus.processing:
        return Icons.check;
      case OrderStatus.shipped:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.home;
      case OrderStatus.reqCancel:
        return Icons.cancel_schedule_send_outlined;
      case OrderStatus.canceled:
        return Icons.cancel_outlined;
    }
  }

  String _getLabel(OrderStatus step) {
    switch (step) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.reqCancel:
        return 'reqCancel';
      case OrderStatus.canceled:
        return 'canceled';
    }
  }
}
