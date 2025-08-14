import 'package:paganini_wallet/core/constants/typedefs.dart';
import 'package:paganini_wallet/features/history/domain/entities/recibo.dart';

class TransactionModel extends Recibo {
  const TransactionModel({
    required super.nombre,
    required super.apellido,
    required super.fecha,
    required super.correo,
    required super.amount,
  });

  factory TransactionModel.fromJson(Json json) {
    return TransactionModel(
      nombre: json['emisorNombre'],
      apellido: json['emisorApellido'],
      fecha: json['fecha'],
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
