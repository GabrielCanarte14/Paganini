import 'package:paganini_wallet/core/constants/typedefs.dart';
import 'package:paganini_wallet/core/constants/utils.dart';
import 'package:paganini_wallet/features/payments_methods/domain/entities/bank_account.dart';

class BankAccountModel extends BankAccount {
  const BankAccountModel(
      {required super.id,
      required super.number,
      required super.titular,
      required super.bank,
      required super.identificacion,
      required super.tipo});

  factory BankAccountModel.fromJson(Json json) {
    return BankAccountModel(
        id: json['id'],
        number: json['numeroCuenta'],
        titular: json['titular'],
        bank: json['nombreBanco'],
        identificacion: json['identificacion'],
        tipo: stringToAccountType(json['tipoCuenta']));
  }

  Json toJson() {
    return {
      'id': id,
      'numeroCuenta': number,
      'titular': titular,
      'nombreBanco': bank,
      'identificacion': identificacion,
      'tipoCuenta': accountTypeToString(tipo),
    };
  }
}
