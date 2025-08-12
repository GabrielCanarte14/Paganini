import 'package:paganini_wallet/core/constants/typedefs.dart';
import 'package:paganini_wallet/features/qr/domain/entities/contact.dart';

class ContactModel extends Contact {
  const ContactModel(
      {required super.nombre,
      required super.apellido,
      required super.celular,
      required super.correo});

  factory ContactModel.fromJson(Json json) {
    return ContactModel(
      nombre: json['nombre'],
      apellido: json['apellido'],
      celular: json['telefono'],
      correo: json['correo'],
    );
  }

  Json toJson() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'telefono': celular,
      'correo': correo,
    };
  }
}
