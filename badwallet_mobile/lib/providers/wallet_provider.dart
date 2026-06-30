import 'package:flutter/material.dart';

import '../models/wallet_balance.dart';
import '../models/wallet_transaction.dart';
import '../services/wallet_api_service.dart';
import '../models/bill.dart';
import '../services/billing_api_service.dart';

class WalletProvider extends ChangeNotifier {
  final WalletApiService _api = WalletApiService();
  final BillingApiService _billingApi = BillingApiService();
  String? phoneNumber;
  WalletBalance? balance;
  List<WalletTransaction> transactions = [];

  bool loading = false;
  String? error;
  List<Bill> bills = [];
Set<String> selectedBillReferences = {};
String selectedUnite = '';

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

  String walletCodeFromPhone(String phone) {
  final clean = phone.replaceAll(' ', '');
  final lastDigits = clean.substring(clean.length - 3);
  return 'WLT-0000$lastDigits';
}

Future<void> loadBills({String unite = ''}) async {
  if (phoneNumber == null) return;

  loading = true;
  error = null;
  selectedUnite = unite;
  selectedBillReferences.clear();
  notifyListeners();

  try {
    final walletCode = walletCodeFromPhone(phoneNumber!);
    bills = await _billingApi.getCurrentBills(
      walletCode,
      unite: unite.isEmpty ? null : unite,
    );
  } catch (e) {
    error = 'Impossible de charger les factures';
  }

  loading = false;
  notifyListeners();
}

void toggleBillSelection(String reference) {
  if (selectedBillReferences.contains(reference)) {
    selectedBillReferences.remove(reference);
  } else {
    selectedBillReferences.add(reference);
  }
  notifyListeners();
}

Future<bool> paySelectedBills() async {
  if (phoneNumber == null || selectedBillReferences.isEmpty) {
    error = 'Veuillez sélectionner au moins une facture';
    notifyListeners();
    return false;
  }

  loading = true;
  error = null;
  notifyListeners();

  try {
    final selectedBills = bills
        .where((bill) => selectedBillReferences.contains(bill.reference))
        .toList();

    final serviceName = selectedBills.isNotEmpty
        ? selectedBills.first.serviceName
        : 'ISM';

    await _api.payFactures(
      phoneNumber: phoneNumber!,
      serviceName: serviceName,
      factureReferences: selectedBillReferences.toList(),
    );

    await refresh();
    await loadBills(unite: selectedUnite);
    return true;
  } catch (e) {
    error = 'Erreur lors du paiement des factures';
    loading = false;
    notifyListeners();
    return false;
  }
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