import 'package:equatable/equatable.dart';

class Recibo extends Equatable {
  final String nombre;
  final String apellido;
  final String correo;
  final DateTime fecha;
  final double amount;

  const Recibo(
      {required this.nombre,
      required this.apellido,
      required this.fecha,
      required this.correo,
      required this.amount});

  @override
  List<Object?> get props => [nombre, apellido, amount];
}
