import 'package:flutter/material.dart';

import '../models/wallet_balance.dart';
import '../models/wallet_transaction.dart';
import '../services/wallet_api_service.dart';

class WalletProvider extends ChangeNotifier {
  final WalletApiService _api = WalletApiService();

  String? phoneNumber;
  WalletBalance? balance;
  List<WalletTransaction> transactions = [];

  bool loading = false;
  String? error;

  Future<bool> loadWallet(String phone) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      phoneNumber = phone.replaceAll(' ', '');
      balance = await _api.getBalance(phoneNumber!);
      transactions = await _api.getTransactions(phoneNumber!);

      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = 'Portefeuille introuvable ou API indisponible';
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> refresh() async {
    if (phoneNumber == null) return;
    await loadWallet(phoneNumber!);
  }

  Future<bool> transfer({
    required String receiverPhone,
    required double amount,
  }) async {
    if (phoneNumber == null) return false;

    loading = true;
    error = null;
    notifyListeners();

    try {
      await _api.transfer(
        senderPhone: phoneNumber!,
        receiverPhone: receiverPhone.replaceAll(' ', ''),
        amount: amount,
      );

      await refresh();
      return true;
    } catch (e) {
      error = 'Erreur lors du transfert';
      loading = false;
      notifyListeners();
      return false;
    }
  }
}