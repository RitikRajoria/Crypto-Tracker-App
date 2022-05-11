import 'package:http/http.dart' as http;
import 'dart:convert';

class CryptoSearchList {
  final uuid;
  final symbol;
  final name;
  final iconUrl;
  final rank;
  final sparkline;
  
  final price;

  CryptoSearchList(
      {required this.uuid,
      required this.symbol,
      required this.name,
      required this.iconUrl,
      required this.rank,
      required this.sparkline,
      
      required this.price});

  factory CryptoSearchList.fromJson(Map<String, dynamic> json) {
    final uuid = json['uuid'];
    final symbol = json['symbol'];
    final String iconUrl = json['iconUrl'];
    
    final price = json['price'];
    final sparkline = json['sparkline'];
    final rank = json['rank'];
    final name = json['name'];

    return CryptoSearchList(
        name: name,
        uuid: uuid,
        symbol: symbol,
        iconUrl: iconUrl,
        
        price: price,
        rank: rank,
        sparkline: sparkline);
  }
}

class CryptoSearchPageResponse {
  final List<CryptoSearchList> cryptoSearchList;

  CryptoSearchPageResponse({required this.cryptoSearchList});

  factory CryptoSearchPageResponse.fromJson(Map<String, dynamic> json) {
    final cryptoListing = (json['data']['coins'] as List)
        .map((listingjson) => CryptoSearchList.fromJson(listingjson))
        .toList();

    return CryptoSearchPageResponse(cryptoSearchList: cryptoListing);
  }
}
