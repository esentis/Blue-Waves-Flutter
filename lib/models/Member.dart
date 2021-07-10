import 'package:blue_waves/constants.dart';

class Member {
  final String? id;
  final String? email;
  final String? password;
  final String displayName;
  final String? role;
  final String? photoUrl;
  final List<String>? favoriteBeaches;
  final String? joinDate;
  final int? karma;
  Member({
    required this.displayName,
    this.email,
    this.id,
    this.password,
    this.photoUrl,
    this.favoriteBeaches,
    this.joinDate,
    this.role,
    this.karma,
  });

  factory Member.fromJson(Json json) => Member(
        displayName: json['username'] as String,
        id: json['id'] as String?,
        joinDate: json['joinDate'] as String?,
        role: json['role'] as String?,
        karma: json['karma'] as int?,
      );
}
