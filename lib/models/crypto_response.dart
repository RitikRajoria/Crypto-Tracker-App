import 'dart:convert';
import 'dart:developer';

import 'package:crypto_app_ui/models/crypto_page_response.dart';
import 'package:http/http.dart' as http;

class CryptoRepository {
  final baseUrl = 'api.coinranking.com';
  final client = http.Client();

  Future<CryptoPageResponse> getCryptoPage() async {
    final uri = Uri.https(baseUrl, '/v2/coins');

    final response = await http.get(uri);

    final json = jsonDecode(response.body);

    log(response.body);
  
    return CryptoPageResponse.fromJson(json);
    
  }
}

// coinranking2aa5a669d3dd00d08906ceca1120bdc28a28c040c27acaa5