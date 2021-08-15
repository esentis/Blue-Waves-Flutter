// ignore: file_names
import 'dart:convert';
import 'package:blue_waves/constants.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
// ignore: implementation_imports
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

String beachToMap(Beach data) => json.encode(data.toMap());

class Beach with ClusterItem {
  Beach({
    this.latitude,
    this.descriptionEl,
    this.descriptionEn,
    this.longitude,
    this.id,
    this.nameEl,
    this.nameEn,
    this.averageRating,
    this.ratingCount,
    this.countryId,
  });

  double? latitude;
  String? descriptionEl;
  String? descriptionEn;
  String? countryId;
  double? longitude;
  String? id;
  String? nameEl;
  String? nameEn;
  int? ratingCount;
  num? averageRating;

  factory Beach.fromMap(Json json) => Beach(
        latitude: json['latitude'],
        descriptionEl: json['description_el'],
        descriptionEn: json['description_en'],
        longitude: json['longitude'],
        id: json['_id'],
        nameEl: json['name_el'],
        nameEn: json['name_en'],
        countryId: json['countryId'],
        averageRating: json['averageRating'] ?? 0.0,
        ratingCount: json['ratingCount'] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'description_el': descriptionEl,
        'description_en': descriptionEn,
        'longitude': longitude,
        'countryId': countryId,
        'id': id,
        'name_el': nameEl,
        'name_en': nameEn,
        'averageRating': averageRating,
        'ratingCount': ratingCount,
      };

  @override
  LatLng get location => LatLng(latitude!, longitude!);
}
