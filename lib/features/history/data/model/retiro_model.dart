import 'package:paganini_wallet/core/constants/typedefs.dart';
import 'package:paganini_wallet/features/history/domain/entities/entities.dart';

class RetiroModel extends Retiro {
  const RetiroModel({
    required super.banco,
    required super.tipo,
    required super.fecha,
    required super.titular,
  });

  factory RetiroModel.fromJson(Json json) {
    return RetiroModel(
      banco: json['nombreBanco'],
      tipo: json['tipoCuenta'],
      fecha: json['fecha'],
      titular: json['titular'],
      //amount: json['monto'],
    );
  }

  Json toJson() {
    return {
      'nombreBanco': banco,
      'tipoCuenta': tipo,
      'fecha': fecha,
      'titular': titular,
      //'monto': amount,
    };
  }
}
