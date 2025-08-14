import 'package:paganini_wallet/core/constants/typedefs.dart';
import 'package:paganini_wallet/features/history/domain/entities/entities.dart';

class RecargaModel extends Recarga {
  const RecargaModel({
    required super.red,
    required super.fecha,
    required super.amount,
  });

  factory RecargaModel.fromJson(Json json) {
    print(json);
    return RecargaModel(
      fecha: DateTime.parse(json['fecha'] as String),
      red: json['red'],
      amount: json['monto'],
    );
  }

  Json toJson() {
    return {
      'fecha': fecha,
      'red': red,
      'monto': amount,
    };
  }
}
