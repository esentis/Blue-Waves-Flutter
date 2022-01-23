import 'package:blue_waves/constants.dart';

class Rating {
  final int beachId;
  final double rating;
  final String userMail;
  final String? date;
  final String? review;
  const Rating({
    required this.beachId,
    required this.rating,
    required this.userMail,
    this.date,
    this.review,
  });

  factory Rating.fromJson(Json json) => Rating(
        beachId: json['beach'],
        date: json['created_at'],
        rating: json['rating'],
        userMail: json['member'],
        review: json['review'],
      );

  Map<String, dynamic> toJson() => {
        "beachId": beachId,
        "date": date,
        "rating": rating,
        "userMail": userMail,
        "review": review,
      };
}
