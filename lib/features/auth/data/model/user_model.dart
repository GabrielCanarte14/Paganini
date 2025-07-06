import 'package:paganini_wallet/core/constants/typedefs.dart';
import 'package:paganini_wallet/features/auth/domain/entities/entities.dart';

class UserModel extends User {
  const UserModel(
      {required super.token,
      required super.email,
      required super.firstName,
      required super.lastName,
      required super.celular});

  factory UserModel.fromJson(Json json) {
    return UserModel(
        token: json['token'] ?? '-',
        firstName: json['usuario']['firstName'],
        lastName: json['usuario']['lastName'],
        email: json['usuario']['email'],
        celular: json['detalleUsuario']['celular']);
  }

  Json toJson() {
    return {
      'token': token,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'celular': celular,
    };
  }
}
