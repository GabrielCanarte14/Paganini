import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/constants/typedefs.dart';

class Retiro extends Equatable {
  final String banco;
  final AccountType tipo;
  final String titular;
  final DateTime fecha;

  const Retiro(
      {required this.fecha,
      required this.banco,
      required this.titular,
      required this.tipo});

  @override
  List<Object?> get props => [titular];
}
