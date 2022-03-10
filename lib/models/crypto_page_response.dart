import 'package:http/http.dart' as http;
import 'dart:convert';

class CryptoListing {
  final uuid;
  final symbol;
  final name;
  final iconUrl;
  final rank;
  final sparkline;
  final change;
  final price;

  CryptoListing(
      {required this.uuid,
      required this.symbol,
      required this.name,
      required this.iconUrl,
      required this.rank,
      required this.sparkline,
      required this.change,
      required this.price});

  factory CryptoListing.fromJson(Map<String, dynamic> json) {
    final uuid = json['uuid'];
    final symbol = json['symbol'];
    final String iconUrl = json['iconUrl'];
    final String change = json['change'];
    final price = json['price'];
    final sparkline = json['sparkline'];
    final rank = json['rank'];
    final name = json['name'];

    return CryptoListing(
        name: name,
        uuid: uuid,
        symbol: symbol,
        iconUrl: iconUrl,
        change: change,
        price: price,
        rank: rank,
        sparkline: sparkline);
  }
}

class CryptoPageResponse {
  final List<CryptoListing> cryptoListing;

  CryptoPageResponse({required this.cryptoListing});

  factory CryptoPageResponse.fromJson(Map<String, dynamic> json) {
    final cryptoListing = (json['data']['coins'] as List)
        .map((listingjson) => CryptoListing.fromJson(listingjson))
        .toList();

    return CryptoPageResponse(cryptoListing: cryptoListing);
  }
}



