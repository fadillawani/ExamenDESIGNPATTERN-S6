import 'package:flutter/foundation.dart';

class ApiConstants {
  static final String baseUrl = kIsWeb
      ? 'http://localhost:8080'
      : 'http://10.0.2.2:8080';

  static final String wallets = '$baseUrl/api/wallets';
  static final String externalFactures = '$baseUrl/api/external/factures';
}