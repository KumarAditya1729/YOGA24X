import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../services/commerce_service.dart';
import '../models/commerce_models.dart';

final commerceServiceProvider = Provider<CommerceService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CommerceService(apiClient);
});

final walletBalanceProvider = FutureProvider<WalletBalance>((ref) async {
  final service = ref.watch(commerceServiceProvider);
  return service.getWalletBalance();
});

final walletHistoryProvider = FutureProvider<List<Transaction>>((ref) async {
  final service = ref.watch(commerceServiceProvider);
  return service.getWalletHistory();
});

final membershipPlansProvider = FutureProvider<List<MembershipPlan>>((ref) async {
  final service = ref.watch(commerceServiceProvider);
  return service.getMembershipPlans();
});
