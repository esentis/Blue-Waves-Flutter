import 'package:flutter/material.dart';

class Beach {
  const Beach({
    @required this.description,
    @required this.latitude,
    @required this.longitude,
    @required this.name,
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
        );
  final String name;
  final String description;
  final double latitude;
  final double longitude;
}
