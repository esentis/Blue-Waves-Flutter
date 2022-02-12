import 'package:blue_waves/constants.dart';

class Favorite {
  final int beachId;
  final String userMail;
  final String? date;
  const Favorite({
    required this.beachId,
    required this.userMail,
    this.date,
  });

  factory Favorite.fromJson(Json json) => Favorite(
        beachId: json['beach'],
        date: json['created_at'],
        userMail: json['member'],
      );

  Map<String, dynamic> toJson() => {
        "beachId": beachId,
        "date": date,
        "userMail": userMail,
      };
}
