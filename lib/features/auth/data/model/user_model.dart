import 'package:paganini_wallet/core/constants/typedefs.dart';
import 'package:paganini_wallet/features/auth/domain/entities/entities.dart';

class UserModel extends User {
  const UserModel(
      {required super.email,
      required super.firstName,
      required super.lastName,
      required super.saldo,
      required super.celular,
      required super.base64});

  factory UserModel.fromJson(Json json) {
    return UserModel(
        email: json['correo'],
        firstName: json['nombre'],
        lastName: json['apellido'],
        saldo: json['saldo'],
        celular: json['telefono'],
        base64: json['codigoQr']);
  }

  Json toJson() {
    return {
      'nombre': firstName,
      'apellido': lastName,
      'correo': email,
      'telefono': celular,
      'saldo': saldo,
      'codigoQr': base64
    };
  }
}
