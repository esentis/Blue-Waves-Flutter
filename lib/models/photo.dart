import 'package:blue_waves/constants.dart';

class Photo {
  final int id;
  final int beachId;
  final DateTime createdAt;
  final Uri url;

  const Photo({
    required this.beachId,
    required this.createdAt,
    required this.id,
    required this.url,
  });

  factory Photo.fromJson(Json json) => Photo(
        beachId: json['beach'],
        createdAt: DateTime.parse(json['created_at']),
        id: json['id'],
        url: Uri.parse(json['url']),
      );

  Json toJson() => {
        "id": id,
        "beachId": beachId,
        "url": url,
        "createdAt": createdAt,
      };
}
