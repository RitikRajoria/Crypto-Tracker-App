class SearchModel {
  final uuid;
  final symbol;
  final name;
  final iconUrl;
  final rank;
  final sparkline;
  final change;
  final price;

  SearchModel(
      {required this.uuid,
      required this.symbol,
      required this.name,
      required this.iconUrl,
      required this.rank,
      required this.sparkline,
      required this.change,
      required this.price});
}
