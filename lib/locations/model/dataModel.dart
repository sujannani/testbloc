
class Data {
  late int id;
  late String startLoc;
  late String endLoc;
  late String image;
  late bool bookMarked;
  Data(
      {required this.id,
      required this.startLoc,
      required this.endLoc,
      required this.image,
      required this.bookMarked});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] as int,
      startLoc: json['start_loc'].toString(),
      endLoc: json['end_loc'].toString(),
      image: json['image'].toString(),
      bookMarked: json['bookmarked'] as bool,
    );
  }
}