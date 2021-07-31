import 'package:blue_waves/constants.dart';

class Rating {
  final String? beachId;
  final double? rating;
  final String? userUid;
  final String? date;
  final String? review;
  const Rating({
    this.beachId,
    this.rating,
    this.userUid,
    this.date,
    this.review,
  });

  factory Rating.fromJson(Json json) => Rating(
        beachId: json['beachId'],
        date: json['date'],
        rating: json['rating'],
        userUid: json['userId'],
        review: json['review'],
      );
}
