class WalletTransaction {
  final int id;
  final String type;
  final double amount;
  final double fees;
  final String createdAt;

  WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.fees,
    required this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'],
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      fees: (json['fees'] as num).toDouble(),
      createdAt: json['createdAt'],
    );
  }
}