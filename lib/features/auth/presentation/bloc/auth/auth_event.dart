part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}

class ChangePasswordEvent extends AuthEvent {
  final User user;
  final String currentPassword;
  final String newPassword;
  final String repeatPassword;

  const ChangePasswordEvent(
      {required this.user,
      required this.currentPassword,
      required this.newPassword,
      required this.repeatPassword});
}

class LogoutEvent extends AuthEvent {
  final User? user;
  const LogoutEvent({this.user});
}

class CheckAuthStatusEvent extends AuthEvent {}

class AuthErrorEvent extends AuthEvent {
  final String message;

  const AuthErrorEvent({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
