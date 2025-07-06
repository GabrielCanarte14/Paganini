part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class Empty extends AuthState {}

class Checking extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  final String mensaje;

  const Authenticated({required this.user, this.mensaje = ''});

  @override
  List<Object> get props => [user];
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
