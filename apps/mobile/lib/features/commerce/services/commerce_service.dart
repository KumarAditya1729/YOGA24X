import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/api_client.dart';
import '../models/commerce_models.dart';

class CommerceService {
  final ApiClient _apiClient;
  
  CommerceService(this._apiClient);

  // ── Wallet ──────────────────────────────────────────────────────────────
  
  Future<WalletBalance> getWalletBalance() async {
    final response = await _apiClient.get('/wallet');
    return WalletBalance.fromJson(response.data);
  }

  Future<List<Transaction>> getWalletHistory() async {
    final response = await _apiClient.get('/wallet/transactions');
    return (response.data as List).map((t) => Transaction.fromJson(t)).toList();
  }

  // ── Memberships ─────────────────────────────────────────────────────────

  Future<List<MembershipPlan>> getMembershipPlans() async {
    final response = await _apiClient.get('/memberships/plans');
    return (response.data as List).map((p) => MembershipPlan.fromJson(p)).toList();
  }

  Future<void> purchaseMembership(String planId) async {
    await _apiClient.post('/memberships/purchase', data: {'planId': planId});
  }
  
  // ── Payments & Checkout ──────────────────────────────────────────────────
  
  Future<Map<String, dynamic>> createOrder(int amountCents, String currency) async {
    final response = await _apiClient.post('/payments/orders', data: {
      'amountCents': amountCents,
      'currency': currency,
    });
    return response.data;
  }
  
  Future<void> verifyPayment(String paymentId, String orderId, String signature, String transactionId) async {
    await _apiClient.post('/payments/verify', data: {
      'razorpayPaymentId': paymentId,
      'razorpayOrderId': orderId,
      'razorpaySignature': signature,
      'paymentTransactionId': transactionId,
    });
  }
}
