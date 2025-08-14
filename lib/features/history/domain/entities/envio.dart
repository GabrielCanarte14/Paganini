import 'package:equatable/equatable.dart';

class Envio extends Equatable {
  final String nombre;
  final String apellido;
  final String correo;
  final DateTime fecha;
  final double amount;

  const Envio(
      {required this.nombre,
      required this.apellido,
      required this.fecha,
      required this.correo,
      required this.amount});

  @override
  List<Object?> get props => [nombre, apellido, amount];
}
