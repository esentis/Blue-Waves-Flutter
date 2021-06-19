// To parse this JSON data, do
//
//     final beach = beachFromMap(jsonString);

import 'dart:convert';

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
  });

  double? latitude;
  String? description;
  double? longitude;
  List<String>? images;
  String? id;
  String? name;

  factory Beach.fromMap(Map<String, dynamic> json) => Beach(
        latitude: json['latitude'].toDouble(),
        description: json['description'],
        longitude: json['longitude'].toDouble(),
        images: List<String>.from(json['images'].map((x) => x)),
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'description': description,
        'longitude': longitude,
        'images': List<dynamic>.from(images!.map((x) => x)),
        'id': id,
        'name': name,
      };
}
