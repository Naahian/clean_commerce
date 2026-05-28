import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/features/domain/entities/profile_entity.dart';
import 'package:clean_commerce/features/presentation/viewmodels/auth_controller.dart';
import 'package:clean_commerce/features/presentation/viewmodels/cart_controller.dart';
import 'package:clean_commerce/features/presentation/viewmodels/models/shipping_info.dart';
import 'package:clean_commerce/features/presentation/viewmodels/settings_notifier.dart';
import 'package:clean_commerce/features/presentation/viewmodels/transaction_controller.dart';
import 'package:clean_commerce/features/presentation/views/cart/payment_screen.dart';
import 'package:clean_commerce/features/presentation/views/cart/widgets/checkout_btn.dart';
import 'package:clean_commerce/features/presentation/views/cart/widgets/order_progress.dart';
import 'package:clean_commerce/features/presentation/views/cart/widgets/payment_methods.dart';
import 'package:clean_commerce/features/presentation/views/cart/widgets/shipping_card.dart';
import 'package:clean_commerce/features/presentation/widgets/status_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final double subtotal;
  const CheckoutScreen({super.key, required this.subtotal});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  PaymentMethod selectedPaymentMethod = PaymentMethod.google_pay;
  bool paid = false;
  bool submitted = false;
  bool _isLoadingProfile = true;
  String? _profileError;

  double get _total => widget.subtotal + Constants.shippingFee;

  @override
  void initState() {
    super.initState();
    // Load profile after first frame to avoid build-time provider modification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoadingProfile = true;
      _profileError = null;
    });

    try {
      final authController = ref.read(authControllerProvider.notifier);
      await authController.getProfile();

      if (mounted) {
        setState(() {
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProfile = false;
          _profileError = e.toString();
        });
      }
    }
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
            OrderProgress(progress: 3),
            Padding(
              padding: EdgeInsets.all(6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    'Shipping Information',
                    Icons.local_shipping_outlined,
                  ),
                  SizedBox(height: 2.h),
                  _buildShippingInfoCard(),
                  SizedBox(height: 4.h),

                  _buildSectionHeader('Payment Method', Icons.payment_outlined),
                  SizedBox(height: 2.h),
                  _buildPaymentMethods(),
                  SizedBox(height: 4.h),

                  _buildSectionHeader('Order Summary', Icons.receipt_outlined),
                  SizedBox(height: 2.h),
                  if (paid)
                    ListTile(
                      leading: StatusIcon(
                        icon: Icons.done,
                        color: Colors.green,
                      ),
                      title: const Text("PAID"),
                      subtitle: const Text("TXI-F2321FFWE"),
                      trailing: Consumer(
                        builder: (_, ref, _) {
                          String currency = ref.read(currencyProvider);
                          return Text("$currency${_total.toStringAsFixed(2)}");
                        },
                      ),
                    ),
                  _buildOrderSummary(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildCheckoutButton(),
    );
  }

  Widget _buildShippingInfoCard() {
    // Watch the profile data
    final userInfo = ref.watch(authControllerProvider).profile;

    if (_isLoadingProfile) {
      return _buildLoadingShippingCard();
    }

    if (_profileError != null || userInfo == null) {
      return _buildErrorShippingCard(_profileError ?? 'Failed to load profile');
    }

    final shippingInfo = _createShippingInfoFromProfile(userInfo);
    return ShippingCard(shippingInfo: shippingInfo);
  }

  Widget _buildLoadingShippingCard() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          const CircularProgressIndicator(),
          SizedBox(width: 4.w),
          Text(
            'Loading shipping information...',
            style: TextStyle(fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorShippingCard(String error) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Failed to load shipping info',
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            error,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: _loadProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              minimumSize: Size(double.infinity, 4.h),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  ShippingInfo _createShippingInfoFromProfile(ProfileEntity? profile) {
    return ShippingInfo(
      name: profile?.fullName ?? 'Not provided',
      address: profile?.address ?? 'Not provided',
      phone: profile?.phone ?? 'Not provided',
    );
  }

  Widget _buildCheckoutButton() {
    final userInfo = ref.watch(authControllerProvider).profile;
    final isLoading = _isLoadingProfile;
    final hasError = _profileError != null;

    if (isLoading) {
      return _buildDisabledButton('Loading...');
    }

    if (hasError || userInfo == null) {
      return _buildDisabledButton('Unable to proceed');
    }

    final shippingInfo = _createShippingInfoFromProfile(userInfo);
    final shouldPayNow =
        !paid && selectedPaymentMethod != PaymentMethod.cashOnDelivery;
    final label = shouldPayNow ? 'Pay Now' : 'Place Order';

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: CheckoutBtn(
        label: label,
        onTap: () => _handleCheckout(shippingInfo, shouldPayNow),
      ),
    );
  }

  Widget _buildDisabledButton(String label) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          minimumSize: Size(double.infinity, 5.h),
        ),
        child: Text(label),
      ),
    );
  }

  Future<void> _handleCheckout(
    ShippingInfo shippingInfo,
    bool shouldPayNow,
  ) async {
    if (shouldPayNow) {
      // Navigate to payment screen
      final result = await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => PaymentScreen(amount: _total)));

      if (result == true && mounted) {
        setState(() => paid = true);
      }
    } else {
      // Place order
      await _placeOrder(shippingInfo);
    }
  }

  Future<void> _placeOrder(ShippingInfo shippingInfo) async {
    final controller = ref.read(orderProvider.notifier);
    final cartItems = ref.read(cartProvider).items;

    try {
      await controller.createOrderFromCart(
        shippingInfo: shippingInfo,
        paymentMethod: selectedPaymentMethod.toString(),
        totalAmount: _total,
        cartItems: cartItems,
      );

      if (mounted) {
        _showOrderSuccessDialog(
          cartItems.map((item) => item.product.name).toList(),
        );
        setState(() => submitted = true);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order: $error')),
        );
      }
    }
  }

  void _showOrderSuccessDialog(List<String> productNames) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Order Placed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your order has been confirmed.'),
            SizedBox(height: 2.h),
            const Text('Items:'),
            ...productNames.map(
              (name) => Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Text('• $name'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  Wrap _buildPaymentMethods() {
    return Wrap(
      spacing: 2.w,
      runSpacing: 2.h,
      children: PaymentMethod.values.map((method) {
        final isSelected = selectedPaymentMethod == method;
        final color = method.color;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedPaymentMethod = method;
            });
          },
          child: MethodCard(
            isSelected: isSelected,
            color: color,
            method: method,
          ),
        );
      }).toList(),
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

  Widget _buildOrderSummary() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withAlpha(20)),
      ),
      child: Consumer(
        builder: (_, ref, __) {
          String currency = ref.read(currencyProvider);
          return Column(
            children: [
              _buildSummaryRow(
                'Subtotal',
                '$currency${widget.subtotal.toStringAsFixed(2)}',
              ),
              _buildSummaryRow(
                'Shipping',
                '$currency${Constants.shippingFee.toStringAsFixed(2)}',
              ),
              Divider(height: 3.h, color: colorScheme.outline.withAlpha(20)),
              _buildSummaryRow(
                'Total',
                '$currency${(widget.subtotal + Constants.shippingFee).toStringAsFixed(2)}',
                isTotal: true,
              ),
              _buildSummaryRow('Payment Status', paid ? 'PAID' : 'DUE'),
            ],
          );
        },
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
}
