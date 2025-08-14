import 'package:paganini_wallet/core/constants/typedefs.dart';
import 'package:paganini_wallet/features/history/domain/entities/entities.dart';

class EnvioModel extends Envio {
  const EnvioModel({
    required super.nombre,
    required super.apellido,
    required super.fecha,
    required super.correo,
    required super.amount,
  });

  factory EnvioModel.fromJson(Json json) {
    print(json);
    return EnvioModel(
      nombre: json['receptorNombre'],
      apellido: json['receptorApellido'],
      fecha: DateTime.parse(json['fecha'] as String),
      correo: json['receptorCorreo'],
      amount: json['monto'],
    );
  }

  Json toJson() {
    return {
      'receptorNombre': nombre,
      'receptorApellido': apellido,
      'fecha': fecha,
      'receptorCorreo': correo,
      'monto': amount,
    };
  }
}
