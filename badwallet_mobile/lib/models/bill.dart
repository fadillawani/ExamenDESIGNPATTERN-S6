class Bill {
  final int id;
  final String reference;
  final String walletCode;
  final String serviceName;
  final String unite;
  final double amount;
  final String dueDate;
  final bool paid;

  Bill({
    required this.id,
    required this.reference,
    required this.walletCode,
    required this.serviceName,
    required this.unite,
    required this.amount,
    required this.dueDate,
    required this.paid,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      reference: json['reference'],
      walletCode: json['walletCode'],
      serviceName: json['serviceName'],
      unite: json['unite'],
      amount: (json['amount'] as num).toDouble(),
      dueDate: json['dueDate'],
      paid: json['paid'],
    );
  }
}