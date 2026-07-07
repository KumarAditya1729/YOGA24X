import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../services/commerce_service.dart';
import '../models/commerce_models.dart';

final commerceServiceProvider = Provider<CommerceService>((ref) {
  final dio = ref.watch(dioProvider);
  return CommerceService(dio);
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
