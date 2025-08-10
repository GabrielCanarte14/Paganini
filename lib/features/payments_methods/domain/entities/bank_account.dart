import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/constants/typedefs.dart';

class BankAccount extends Equatable {
  final String bank;
  final String number;
  final AccountType tipo;
  final String titular;
  final String identificacion;

  const BankAccount(
      {required this.number,
      required this.titular,
      required this.bank,
      required this.tipo,
      required this.identificacion});

  @override
  List<Object?> get props => [number, titular];
}
