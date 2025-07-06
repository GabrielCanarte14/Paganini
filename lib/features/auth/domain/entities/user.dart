import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String token;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? celular;

  const User({
    required this.token,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.celular,
  });

  @override
  List<Object?> get props => [token, firstName, lastName, email, celular];
}
