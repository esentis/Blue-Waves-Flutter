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

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        beachId: json['beach'],
        createdAt: DateTime.parse(json['created_at']),
        id: json['id'],
        url: Uri.parse(json['url']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "beachId": beachId,
        "url": url,
        "createdAt": createdAt,
      };
}
