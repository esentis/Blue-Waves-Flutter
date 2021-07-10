import 'package:blue_waves/constants.dart';

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
        beachId: json['beachId'].toString(),
        beachName: json['beachName'].toString(),
        date: json['date'].toString(),
        rating: double.tryParse(json['rating'].toString()),
        username: json['username'].toString(),
        userUid: json['userId'].toString(),
      );
}
