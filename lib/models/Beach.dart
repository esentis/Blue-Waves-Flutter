// To parse this JSON data, do
//
//     final beach = beachFromMap(jsonString);

import 'dart:convert';
import 'package:Blue_Waves/constants.dart';

Beach beachFromMap(String str) => Beach.fromMap(json.decode(str));

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
        latitude: json['latitude'].toDouble(),
        description: json['description'],
        longitude: json['longitude'].toDouble(),
        images: List<String>.from(json['images'].map((x) => x)),
        id: json['id'],
        name: json['name'],
        averageRating: json['averageRating'] != null
            ? json['averageRating'].toDouble()
            : 0.0,
        ratingCount: json['ratingCount'] ?? 0,
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
