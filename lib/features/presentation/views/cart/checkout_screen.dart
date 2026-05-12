import 'package:clean_commerce/features/presentation/viewmodels/app_settings_notifier.dart';
import 'package:clean_commerce/features/presentation/views/cart/payment_screen.dart';
import 'package:clean_commerce/features/presentation/views/cart/widgets/order_progress.dart';
import 'package:clean_commerce/features/presentation/views/cart/widgets/payment_methods.dart';
import 'package:clean_commerce/features/presentation/views/cart/widgets/shipping_card.dart';
import 'package:clean_commerce/features/presentation/widgets/status_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class ShippingInfo {
  final String name;
  final String phone;
  final String address;

  const ShippingInfo({
    required this.name,
    required this.phone,
    required this.address,
  });

  factory ShippingInfo.defaultInfo() {
    return const ShippingInfo(
      name: 'John Doe',
      phone: '+1 234 567 8900',
      address: '123 Main Street, Apt 4B, New York, NY 10001, United States',
    );
  }

  ShippingInfo copyWith({String? name, String? phone, String? address}) {
    return ShippingInfo(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String selectedPaymentMethod = 'bKash';
  String currency = '\$';
  bool paid = true;
  bool submitted = false;

  final ShippingInfo shippingInfo = ShippingInfo.defaultInfo();

  double get _subtotal => 299;
  double get _shipping => 60;
  double get _total => _subtotal + _shipping;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(settingsProvider.notifier);
      setState(() {
        currency = settings.getCurrencyChar();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Progress indicator
            OrderProgress(progress: 3), // Content
            Padding(
              padding: EdgeInsets.all(6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shipping Information Card
                  _buildSectionHeader(
                    'Shipping Information',
                    Icons.local_shipping_outlined,
                  ),
                  SizedBox(height: 2.h),
                  ShippingCard(shippingInfo: shippingInfo),

                  SizedBox(height: 4.h),

                  // Payment Method
                  _buildSectionHeader('Payment Method', Icons.payment_outlined),
                  SizedBox(height: 2.h),
                  PaymentMethods(),

                  SizedBox(height: 4.h),

                  // Order Summary
                  _buildSectionHeader('Order Summary', Icons.receipt_outlined),
                  SizedBox(height: 2.h),
                  if (paid)
                    ListTile(
                      leading: StatusIcon(
                        icon: Icons.done,
                        color: Colors.green,
                      ),
                      title: Text("PAID"),
                      subtitle: Text("TXI-F2321FFWE"),
                      trailing: Text("$currency${_total.toStringAsFixed(2)}"),
                    ),
                  _buildOrderSummary(theme, colorScheme),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildCheckoutButton(theme, colorScheme),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        SizedBox(width: 2.w),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withAlpha(20)),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'Subtotal',
            '$currency${_subtotal.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            'Shipping',
            '$currency${_shipping.toStringAsFixed(2)}',
          ),
          Divider(height: 3.h, color: colorScheme.outline.withAlpha(20)),
          _buildSummaryRow(
            'Total',
            '$currency${_total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? theme.textTheme.titleMedium
                : theme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: isTotal
                ? theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  )
                : theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PaymentScreen(
                  paymentUrl: 'https://developer.bka.sh/',
                  failedUrl: 'https://developer.bka.sh/',
                  successUrl: '',
                  cancelUrl: '',
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 1.8.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                paid ? 'Place Order' : 'Pay Now ',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              if (!paid)
                Text(
                  '$currency${_total.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
