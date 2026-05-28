import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  const PaymentScreen({super.key, required this.amount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final Future<PaymentConfiguration> _gpayConfig;

  // Define payment items
  late final List<PaymentItem> _paymentItems;

  @override
  void initState() {
    super.initState();
    _gpayConfig = PaymentConfiguration.fromAsset('google_pay_config.json');

    _paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: widget.amount.toStringAsFixed(2),
        status: PaymentItemStatus.final_price,
      ),
    ];
  }

  void _onGooglePayResult(paymentResult) {
    try {
      // Extract payment token
      final token =
          paymentResult['paymentMethodData']['tokenizationData']['token'];
      debugPrint('Payment Token: $token');

      // Send token to your backend for processing
      _processPaymentOnBackend(token);
    } catch (e) {
      debugPrint('Payment error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment failed. Please try again.')),
      );
    }
  }

  Future<void> _processPaymentOnBackend(String token) async {
    // Send token to your server to complete the transaction
    // Your backend will forward this to your payment processor
    debugPrint('Processing token: $token');
    // Show success and navigate
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Pay Checkout')),
      body: Center(
        child: FutureBuilder<PaymentConfiguration>(
          future: _gpayConfig,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const Text('Error loading Google Pay config');
            }

            return GooglePayButton(
              paymentConfiguration: snapshot.data!,
              paymentItems: _paymentItems,
              onPaymentResult: _onGooglePayResult,
              onError: (error) => debugPrint('Error: $error'),
              height: 48,
              type: GooglePayButtonType.buy,
              theme: GooglePayButtonTheme.dark,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}
