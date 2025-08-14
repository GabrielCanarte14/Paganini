import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/constants/typedefs.dart';

class Retiro extends Equatable {
  final String banco;
  final AccountType tipo;
  final String titular;
  final DateTime fecha;
  final double amount;

  const Retiro(
      {required this.fecha,
      required this.banco,
      required this.titular,
      required this.tipo,
      required this.amount});

  @override
  List<Object?> get props => [titular];
}
