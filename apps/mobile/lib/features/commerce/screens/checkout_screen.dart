// ignore_for_file: unused_element, unused_local_variable, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/commerce_provider.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart'; // To be added when Razorpay SDK is installed

class CheckoutScreen extends ConsumerStatefulWidget {
  final int amountCents;
  final String description;

  const CheckoutScreen({
    super.key,
    required this.amountCents,
    required this.description,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  // late Razorpay _razorpay;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    // _razorpay.clear();
  }

  void _handlePaymentSuccess(/* PaymentSuccessResponse response */ dynamic response) async {
    try {
      /*
      await ref.read(commerceServiceProvider).verifyPayment(
        response.paymentId!,
        response.orderId!,
        response.signature!,
        _transactionId,
      );
      */
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment Successful!')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification Failed: $e')),
      );
      setState(() => _isProcessing = false);
    }
  }

  void _handlePaymentError(/* PaymentFailureResponse response */ dynamic response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Failed: ${response.message ?? "Unknown error"}')),
    );
    setState(() => _isProcessing = false);
  }

  void _handleExternalWallet(/* ExternalWalletResponse response */ dynamic response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
    setState(() => _isProcessing = false);
  }

  Future<void> _startCheckout() async {
    setState(() => _isProcessing = true);
    try {
      final orderData = await ref.read(commerceServiceProvider).createOrder(widget.amountCents, 'INR');
      
      // final options = {
      //   'key': 'rzp_test_YourKey', // Replace with Razorpay key
      //   'amount': widget.amountCents,
      //   'name': 'Yoga24X',
      //   'description': widget.description,
      //   'order_id': orderData['razorpayOrderId'],
      //   'prefill': {
      //     'contact': '9876543210',
      //     'email': 'user@example.com'
      //   }
      // };
      // _razorpay.open(options);
      
      // Simulate success for now without SDK
      await Future.delayed(const Duration(seconds: 2));
      _handlePaymentSuccess({});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initiating checkout: $e')),
      );
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            const Icon(Icons.shopping_cart_checkout, size: 80, color: Colors.grey),
            const SizedBox(height: 24),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              '₹${(widget.amountCents / 100).toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            _isProcessing
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _startCheckout,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Pay Now', style: TextStyle(fontSize: 18)),
                  ),
          ],
        ),
      ),
    );
  }
}
