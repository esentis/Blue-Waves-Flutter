import 'package:flutter/material.dart';

class Beach {
  const Beach({
    @required this.description,
    @required this.latitude,
    @required this.longitude,
    @required this.name,
    @required this.images,
    @required this.id,
  })  : assert(
          description != null,
          'Description must not be null',
        ),
        assert(
          latitude != null,
          'Latitude must not be null',
        ),
        assert(
          longitude != null,
          'Longitude must not be null',
        ),
        assert(
          name != null,
          'Name must not be null',
        ),
        assert(
          images != null,
          'Images must not be null',
        );
  final String name;
  final String id;
  final String description;
  final double latitude;
  final double longitude;
  final List<dynamic> images;
}
