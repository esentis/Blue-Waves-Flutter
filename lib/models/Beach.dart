// ignore: file_names
import 'dart:convert';
import 'package:blue_waves/constants.dart';

String beachToMap(Beach data) => json.encode(data.toMap());

class Beach {
  Beach({
    this.latitude,
    this.description,
    this.longitude,
    this.images,
    this.id,
    this.name,
    this.averageRating,
    this.ratingCount,
  });

  double? latitude;
  String? description;
  double? longitude;
  List<String>? images;
  String? id;
  String? name;
  int? ratingCount;
  double? averageRating;

  factory Beach.fromMap(Json json) => Beach(
        latitude: json['latitude'] as double,
        description: json['description'] as String,
        longitude: json['longitude'] as double,
        images: List<String>.from((json['images'] as List).map((x) => x)),
        id: json['id'] as String,
        name: json['name'] as String,
        averageRating: (json['averageRating'] as double?) ?? 0.0,
        ratingCount: (json['ratingCount'] as int?) ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'description': description,
        'longitude': longitude,
        'images': List<dynamic>.from(images!.map((x) => x)),
        'id': id,
        'name': name,
        'averageRating': averageRating,
        'ratingCount': ratingCount,
      };
}
