class CoinResponse {
  final String status;

  final Data data;

  CoinResponse({required this.status, required this.data});

  factory CoinResponse.fromJson(Map<String, dynamic> json) {
    final status = json['status'];

    final data = Data.fromJson(json['data']);

    return CoinResponse(status: status, data: data);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['status'] = this.status;

    if (this.data != null) {
      data['data'] = this.data.toJson();
    }

    return data;
  }
}

class Data {
  Coin coin;

  Data({required this.coin});

  factory Data.fromJson(Map<String, dynamic> json) {
    final coin = json['coin'] != null ? new Coin.fromJson(json['coin']) : null;

    return Data(coin: coin!);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.coin != null) {
      data['coin'] = this.coin.toJson();
    }

    return data;
  }
}

class Coin {
  String uuid;

  String? symbol;

  String? name;

  String? description;

  String? iconUrl;

  String? s24hVolume;

  String? marketCap;

  String? price;

  String? btcPrice;

  int? priceAt;

  String? change;

  int? rank;

  int? numberOfMarkets;

  int? numberOfExchanges;

  int? listedAt;

  List<String?> sparkline;

  AllTimeHigh allTimeHigh;

  String? coinrankingUrl;

  Coin(
      {required this.uuid,
      required this.symbol,
      required this.name,
      required this.description,
      required this.iconUrl,
      required this.s24hVolume,
      required this.marketCap,
      required this.price,
      required this.btcPrice,
      required this.priceAt,
      required this.change,
      required this.rank,
      required this.numberOfMarkets,
      required this.numberOfExchanges,
      required this.listedAt,
      required this.sparkline,
      required this.allTimeHigh,
      required this.coinrankingUrl});

  factory Coin.fromJson(Map<String, dynamic> json) {
    final uuid = json['uuid'];

    final symbol = json['symbol'];

    final name = json['name'];

    final description = json['description'];

    final color = json['color'];

    final iconUrl = json['iconUrl'];

    final s24hVolume = json['24hVolume'];

    final marketCap = json['marketCap'];

    final price = json['price'];

    final btcPrice = json['btcPrice'];

    final priceAt = json['priceAt'];

    final change = json['change'];

    final rank = json['rank'];

    final numberOfMarkets = json['numberOfMarkets'];

    final numberOfExchanges = json['numberOfExchanges'];

    final listedAt = json['listedAt'];

    final sparkline = json['sparkline'].cast<String?>();

    final allTimeHigh = json['allTimeHigh'] != null
        ? new AllTimeHigh.fromJson(json['allTimeHigh'])
        : null;

    final coinrankingUrl = json['coinrankingUrl'];

    return Coin(
        uuid: uuid,
        symbol: symbol,
        name: name,
        description: description,
        iconUrl: iconUrl,
        s24hVolume: s24hVolume,
        marketCap: marketCap,
        price: price,
        btcPrice: btcPrice,
        priceAt: priceAt,
        change: change,
        rank: rank,
        numberOfMarkets: numberOfMarkets,
        numberOfExchanges: numberOfExchanges,
        listedAt: listedAt,
        sparkline: sparkline,
        allTimeHigh: allTimeHigh!,
        coinrankingUrl: coinrankingUrl);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['uuid'] = this.uuid;

    data['symbol'] = this.symbol;

    data['name'] = this.name;

    data['description'] = this.description;

    data['iconUrl'] = this.iconUrl;

    data['24hVolume'] = this.s24hVolume;

    data['marketCap'] = this.marketCap;

    data['price'] = this.price;

    data['btcPrice'] = this.btcPrice;

    data['priceAt'] = this.priceAt;

    data['change'] = this.change;

    data['rank'] = this.rank;

    data['numberOfMarkets'] = this.numberOfMarkets;

    data['numberOfExchanges'] = this.numberOfExchanges;

    data['listedAt'] = this.listedAt;

    data['sparkline'] = this.sparkline;

    if (this.allTimeHigh != null) {
      data['allTimeHigh'] = this.allTimeHigh.toJson();
    }

    data['coinrankingUrl'] = this.coinrankingUrl;

    return data;
  }
}

class AllTimeHigh {
  String price;

  int timestamp;

  AllTimeHigh({required this.price, required this.timestamp});

  factory AllTimeHigh.fromJson(Map<String, dynamic> json) {
    final price = json['price'];

    final timestamp = json['timestamp'];

    return AllTimeHigh(price: price, timestamp: timestamp);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['price'] = this.price;

    data['timestamp'] = this.timestamp;

    return data;
  }
}
