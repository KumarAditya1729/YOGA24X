class WalletBalance {
  final int balanceCents;
  final String currency;

  WalletBalance({required this.balanceCents, required this.currency});

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    return WalletBalance(
      balanceCents: json['balanceCents'] ?? 0,
      currency: json['currency'] ?? 'INR',
    );
  }

  double get balance => balanceCents / 100;
}

class Transaction {
  final String id;
  final int amountCents;
  final String type; // CREDIT, DEBIT
  final String description;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.amountCents,
    required this.type,
    required this.description,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amountCents: json['amountCents'],
      type: json['type'],
      description: json['metadata']?['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  double get amount => amountCents / 100;
}

class MembershipPlan {
  final String id;
  final String name;
  final String membershipType;
  final int priceCents;
  final int durationDays;

  MembershipPlan({
    required this.id,
    required this.name,
    required this.membershipType,
    required this.priceCents,
    required this.durationDays,
  });

  factory MembershipPlan.fromJson(Map<String, dynamic> json) {
    return MembershipPlan(
      id: json['id'],
      name: json['name'],
      membershipType: json['membershipType'],
      priceCents: json['priceCents'],
      durationDays: json['durationDays'],
    );
  }
}
