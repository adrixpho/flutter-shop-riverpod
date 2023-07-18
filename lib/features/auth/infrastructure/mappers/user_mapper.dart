import 'package:teslo_shop/features/auth/domain/entities/user.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        fullname: json['fullName'],
        roles: List<String>.from(json['roles'].map((item) => item)),
        token: json['token'],
      );
}
