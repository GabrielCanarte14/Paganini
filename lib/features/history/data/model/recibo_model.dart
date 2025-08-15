import 'package:paganini_wallet/core/constants/typedefs.dart';
import 'package:paganini_wallet/features/history/domain/entities/recibo.dart';

class ReciboModel extends Recibo {
  const ReciboModel({
    required super.nombre,
    required super.apellido,
    required super.fecha,
    required super.correo,
    required super.amount,
  });

  factory ReciboModel.fromJson(Json json) {
    return ReciboModel(
      nombre: json['emisorNombre'],
      apellido: json['emisorApellido'],
      fecha: DateTime.parse(json['fecha'] as String),
      correo: json['emisorCorreo'],
      amount: json['monto'],
    );
  }

  Json toJson() {
    return {
      'emisorNombre': nombre,
      'emisorApellido': apellido,
      'fecha': fecha,
      'emisorCorreo': correo,
      'monto': amount,
    };
  }
}
