import 'package:dio/dio.dart';
import '../models/commerce_models.dart';

class CommerceService {
  final Dio _dio;
  
  CommerceService(this._dio);

  // ── Wallet ──────────────────────────────────────────────────────────────
  
  Future<WalletBalance> getWalletBalance() async {
    final response = await _dio.get('/wallet');
    return WalletBalance.fromJson(response.data);
  }

  Future<List<Transaction>> getWalletHistory() async {
    final response = await _dio.get('/wallet/transactions');
    return (response.data as List).map((t) => Transaction.fromJson(t)).toList();
  }

  // ── Memberships ─────────────────────────────────────────────────────────

  Future<List<MembershipPlan>> getMembershipPlans() async {
    final response = await _dio.get('/memberships/plans');
    return (response.data as List).map((p) => MembershipPlan.fromJson(p)).toList();
  }

  Future<void> purchaseMembership(String planId) async {
    await _dio.post('/memberships/purchase', data: {'planId': planId});
  }
  
  // ── Payments & Checkout ──────────────────────────────────────────────────
  
  Future<Map<String, dynamic>> createOrder(int amountCents, String currency) async {
    final response = await _dio.post('/payments/orders', data: {
      'amountCents': amountCents,
      'currency': currency,
    });
    return response.data;
  }
  
  Future<void> verifyPayment(String paymentId, String orderId, String signature, String transactionId) async {
    await _dio.post('/payments/verify', data: {
      'razorpayPaymentId': paymentId,
      'razorpayOrderId': orderId,
      'razorpaySignature': signature,
      'paymentTransactionId': transactionId,
    });
  }
}
