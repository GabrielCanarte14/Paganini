import 'package:equatable/equatable.dart';

class Recarga extends Equatable {
  final String red;
  final DateTime fecha;
  final double amount;

  const Recarga({required this.fecha, required this.red, required this.amount});

  @override
  List<Object?> get props => [amount];
}
