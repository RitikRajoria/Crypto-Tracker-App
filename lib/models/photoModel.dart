class Photo {
  int? id;
  String photoName;
  String name;

  Photo({this.id, required this.photoName, required this.name});

  Photo.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        photoName = map['photoName'];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'photoName': photoName,
    };
    return map;
  }
}
