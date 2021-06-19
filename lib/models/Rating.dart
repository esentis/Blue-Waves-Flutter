import 'package:Blue_Waves/constants.dart';

class Rating {
  final String? beachId;
  final double? rating;
  final String? userUid;
  final String? username;
  final String? beachName;
  final String? date;
  const Rating({
    this.beachId,
    this.rating,
    this.userUid,
    this.username,
    this.beachName,
    this.date,
  });

  factory Rating.fromJson(Json json) => Rating(
        beachId: json['beachId'],
        beachName: json['beachName'],
        date: json['date'],
        rating: json['rating'].toDouble(),
        username: json['username'],
        userUid: json['userId'],
      );
}
