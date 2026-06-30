import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../models/wallet_balance.dart';
import '../models/wallet_transaction.dart';

class WalletApiService {
  Future<WalletBalance> getBalance(String phone) async {
    final encodedPhone = Uri.encodeComponent(phone);

    final response = await http.get(
      Uri.parse('${ApiConstants.wallets}/$encodedPhone/balance'),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur solde : ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    return WalletBalance.fromJson(decoded, phone);
  }

  Future<List<WalletTransaction>> getTransactions(String phone) async {
    final encodedPhone = Uri.encodeComponent(phone);

    final response = await http.get(
      Uri.parse('${ApiConstants.wallets}/$encodedPhone/transactions'),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final List data = jsonDecode(response.body);
    return data.map((item) => WalletTransaction.fromJson(item)).toList();
  }

  Future<void> transfer({
    required String senderPhone,
    required String receiverPhone,
    required double amount,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.wallets}/transfer'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'senderPhone': senderPhone,
        'receiverPhone': receiverPhone,
        'amount': amount,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur transfert : ${response.body}');
    }
  }
}