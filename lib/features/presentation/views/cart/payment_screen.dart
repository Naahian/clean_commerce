import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String paymentUrl;
  final String successUrl;
  final String failedUrl;
  final String cancelUrl;

  const PaymentScreen({
    super.key,
    required this.paymentUrl,
    required this.successUrl,
    required this.failedUrl,
    required this.cancelUrl,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final WebViewController _controller;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            final url = request.url;

            debugPrint("Redirect URL: $url");

            /// SUCCESS
            if (url.startsWith(widget.successUrl)) {
              Navigator.pop(context, {
                "success": true,
                "status": "success",
                "url": url,
              });

              return NavigationDecision.prevent;
            }

            /// FAILED
            if (url.startsWith(widget.failedUrl)) {
              Navigator.pop(context, {
                "success": false,
                "status": "failed",
                "url": url,
              });

              return NavigationDecision.prevent;
            }

            /// CANCELLED
            if (url.startsWith(widget.cancelUrl)) {
              Navigator.pop(context, {
                "success": false,
                "status": "cancelled",
                "url": url,
              });

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment"), centerTitle: true),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
