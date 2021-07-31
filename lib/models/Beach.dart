// ignore: file_names
import 'dart:convert';
import 'package:blue_waves/constants.dart';

String beachToMap(Beach data) => json.encode(data.toMap());

class Beach {
  Beach({
    this.latitude,
    this.description,
    this.longitude,
    this.id,
    this.name,
    this.averageRating,
    this.ratingCount,
    this.countryId,
  });

  double? latitude;
  String? description;
  String? countryId;
  double? longitude;
  String? id;
  String? name;
  int? ratingCount;
  num? averageRating;

  factory Beach.fromMap(Json json) => Beach(
        latitude: json['latitude'],
        description: json['description'],
        longitude: json['longitude'],
        id: json['_id'],
        name: json['name'],
        countryId: json['countryId'],
        averageRating: json['averageRating'] ?? 0.0,
        ratingCount: json['ratingCount'] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'description': description,
        'longitude': longitude,
        'countryId': countryId,
        'id': id,
        'name': name,
        'averageRating': averageRating,
        'ratingCount': ratingCount,
      };
}
