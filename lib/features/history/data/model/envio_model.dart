import 'package:paganini_wallet/core/constants/typedefs.dart';
import 'package:paganini_wallet/features/history/domain/entities/recibo.dart';

class EnvioModel extends Recibo {
  const EnvioModel({
    required super.nombre,
    required super.apellido,
    required super.fecha,
    required super.correo,
    required super.amount,
  });

  factory EnvioModel.fromJson(Json json) {
    return EnvioModel(
      nombre: json['receptorNombre'],
      apellido: json['receptorApellido'],
      fecha: json['fecha'],
      correo: json['emisorCorreo'],
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
