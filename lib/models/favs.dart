class FavsModel {
  final int? id;
  final String uuid;

  FavsModel({this.id, required this.uuid});

  FavsModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        uuid = res['uuid'];

  Map<String, Object?> toMap() {
    return {'id': id, 'uuid': uuid};
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
