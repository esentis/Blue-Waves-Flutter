// ignore: file_names
// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:blue_waves/constants.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
// ignore: implementation_imports
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

String beachToMap(Beach data) => json.encode(data.toMap());

class Beach with ClusterItem {
  Beach({
    this.latitude,
    this.description,
    this.longitude,
    this.id,
    this.name,
    this.averageRating,
    this.ratingCount,
    this.countryId,
    this.descriptionEn,
    this.descriptionSource,
    this.nameEn,
  });

  double? latitude;
  String? description;
  String? descriptionEn;
  Uri? descriptionSource;
  String? countryId;
  double? longitude;
  String? id;
  String? name;
  String? nameEn;
  int? ratingCount;
  num? averageRating;

  factory Beach.fromMap(Json json) => Beach(
        latitude: json['latitude'],
        description: json['description'],
        descriptionEn: json['description_en'],
        descriptionSource: Uri.tryParse(json['description_source']),
        longitude: json['longitude'],
        id: json['_id'],
        name: json['name'],
        nameEn: json['name_en'],
        countryId: json['countryId'],
        averageRating: json['averageRating'] ?? 0.0,
        ratingCount: json['ratingCount'] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'description': description,
        'description_en': descriptionEn,
        'description_source': descriptionSource.toString(),
        'longitude': longitude,
        'countryId': countryId,
        'id': id,
        'name_el': name,
        'name_en': nameEn,
        'averageRating': averageRating,
        'ratingCount': ratingCount,
      };

  @override
  LatLng get location => LatLng(latitude!, longitude!);
}
