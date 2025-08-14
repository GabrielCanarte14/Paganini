import 'package:paganini_wallet/core/constants/typedefs.dart';
import 'package:paganini_wallet/core/constants/utils.dart';
import 'package:paganini_wallet/features/history/domain/entities/entities.dart';

class RetiroModel extends Retiro {
  const RetiroModel({
    required super.banco,
    required super.tipo,
    required super.fecha,
    required super.titular,
    required super.amount,
  });

  factory RetiroModel.fromJson(Json json) {
    return RetiroModel(
      banco: json['nombreBanco'],
      tipo: stringToAccountType(json['tipoCuenta']),
      fecha: DateTime.parse(json['fecha'] as String),
      titular: json['titular'],
      amount: json['monto'] ?? -10.00,
    );
  }

  Json toJson() {
    return {
      'nombreBanco': banco,
      'tipoCuenta': accountTypeToString(tipo),
      'fecha': fecha,
      'titular': titular,
      'monto': amount,
    };
  }
}
