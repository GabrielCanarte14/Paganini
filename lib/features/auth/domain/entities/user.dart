import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final double saldo;
  final String celular;
  final String base64;

  const User(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.saldo,
      required this.celular,
      required this.base64});

  @override
  List<Object?> get props => [firstName, lastName, email, celular];
}
