import 'dart:convert';
import 'dart:developer';

import 'package:crypto_app_ui/models/coin_detail_view.dart';
import 'package:crypto_app_ui/models/crypto_page_response.dart';
import 'package:http/http.dart' as http;

class CryptoRepository {
  final baseUrl = 'api.coinranking.com';
  final client = http.Client();

  Future<CryptoPageResponse> getCryptoPage() async {
    final uri = Uri.http(baseUrl, '/v2/coins');

    final response = await http.get(uri, headers: {
      "x-access-token":
          "coinranking2aa5a669d3dd00d08906ceca1120bdc28a28c040c27acaa5",
    });

    final json = jsonDecode(response.body);

    // log(response.body);

    return CryptoPageResponse.fromJson(json);
  }

  Future<CoinResponse> getCryptoCoinPage(
      {required String uuid, required var time}) async {
    final query = {'timePeriod': '$time'};
    final uri = Uri.http(baseUrl, '/v2/coin/$uuid', query);

    final response = await http.get(uri, headers: {
      "x-access-token":
          "coinranking2aa5a669d3dd00d08906ceca1120bdc28a28c040c27acaa5",
    });

    final json = jsonDecode(response.body);

    log(response.body);

    return CoinResponse.fromJson(json);
  }
}

// coinranking2aa5a669d3dd00d08906ceca1120bdc28a28c040c27acaa5