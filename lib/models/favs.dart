class FavsModel {
  final int? id;
  final String uuid;
  final String name;

  FavsModel({this.id, required this.uuid, required this.name});

  FavsModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        uuid = res['uuid'],
        name = res['name'];

  Map<String, Object?> toMap() {
    return {'id': id, 'uuid': uuid, 'name': name};
  }
}

class FavItemModel {
  final uuid;
  final symbol;
  final name;
  final iconUrl;

  final change;
  final price;

  FavItemModel(
      {required this.uuid,
      required this.symbol,
      required this.name,
      required this.iconUrl,
      required this.change,
      required this.price});
}

class FavItemModelforHome {
  final uuid;
  final symbol;
  final name;
  final iconUrl;

  final change;
  final price;
  final List<String> sparkdata;

  FavItemModelforHome(
      {required this.uuid,
      required this.symbol,
      required this.name,
      required this.iconUrl,
      required this.change,
      required this.price,
      required this.sparkdata});
}
