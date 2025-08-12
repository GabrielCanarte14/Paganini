import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  final String nombre;
  final String apellido;
  final String correo;
  final String celular;

  const Contact(
      {required this.nombre,
      required this.apellido,
      required this.celular,
      required this.correo});

  @override
  List<Object?> get props => [nombre, apellido, correo];
}
