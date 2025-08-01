part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class Empty extends AuthState {}

class Checking extends AuthState {}

class Registering extends AuthState {}

class Register extends AuthState {
  final String mensaje;

  const Register({this.mensaje = ''});

  @override
  List<Object> get props => [mensaje];
}

class Authenticated extends AuthState {
  final String mensaje;

  const Authenticated({this.mensaje = ''});

  @override
  List<Object> get props => [];
}

class Loginout extends AuthState {}

class Unauthenticated extends AuthState {}

class UserError extends AuthState {
  final String message;
  const UserError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

final class AuthInitial extends AuthState {}
