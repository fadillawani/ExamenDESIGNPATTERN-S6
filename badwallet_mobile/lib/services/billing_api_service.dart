import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../models/bill.dart';

class BillingApiService {
  Future<List<Bill>> getCurrentBills(String walletCode, {String? unite}) async {
    final uri = Uri.parse('${ApiConstants.externalFactures}/$walletCode/current')
        .replace(
      queryParameters: unite == null || unite.isEmpty ? null : {'unite': unite},
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Impossible de charger les factures');
    }

    final List data = jsonDecode(response.body);
    return data.map((item) => Bill.fromJson(item)).toList();
  }
}