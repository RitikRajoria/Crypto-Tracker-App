import 'dart:convert';

import 'package:http/http.dart' as http;

class DataService {
  void getData( uuids) async {
    final baseUrl = 'api.coinranking.com';
    final client = http.Client();

    // final query = {
    //   'uuid': 'Qwsogvtv82FCd',
    //     'symbol': 'BTC',
    // };

    final uri = Uri.https(baseUrl ,'/v2/coins');
   

    final response = await http.get(uri);
    print(response.body);
    
    
    
  }
}