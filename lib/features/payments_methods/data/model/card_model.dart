import 'package:paganini_wallet/core/constants/typedefs.dart';
import 'package:paganini_wallet/features/payments_methods/domain/entities/entities.dart';

class CardModel extends Card {
  const CardModel(
      {required super.number,
      required super.titular,
      required super.month,
      required super.year});

  factory CardModel.fromJson(Json json) {
    return CardModel(
        number: json['numeroTarjeta'],
        titular: json['titular'],
        month: json['mes'].toString(),
        year: json['year'].toString());
  }

  Json toJson() {
    return {
      'numeroTarjeta': number,
      'titular': titular,
      'mes': month,
      'year': year,
    };
  }
}
