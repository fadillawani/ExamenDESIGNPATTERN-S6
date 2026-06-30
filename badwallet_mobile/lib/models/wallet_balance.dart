class WalletBalance {
  final String phoneNumber;
  final double balance;
  final String currency;

  WalletBalance({
    required this.phoneNumber,
    required this.balance,
    required this.currency,
  });

  factory WalletBalance.fromJson(dynamic json, String fallbackPhone) {
    if (json is num) {
      return WalletBalance(
        phoneNumber: fallbackPhone,
        balance: json.toDouble(),
        currency: 'XOF',
      );
    }

    return WalletBalance(
      phoneNumber: json['phoneNumber'] ?? fallbackPhone,
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] ?? 'XOF',
    );
  }
}