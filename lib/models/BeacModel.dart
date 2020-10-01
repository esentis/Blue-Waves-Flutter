import 'package:flutter/material.dart';

class Beach {
  const Beach({
    @required this.description,
    @required this.latitude,
    @required this.longitute,
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
          longitute != null,
          'Longitude must not be null',
        ),
        assert(
          name != null,
          'Name must not be null',
        );
  final String name;
  final String description;
  final double latitude;
  final double longitute;
}
