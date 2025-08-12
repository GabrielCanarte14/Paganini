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

class RegisterEvent extends AuthEvent {
  final String name;
  final String lastname;
  final String email;
  final String phone;
  final String password;

  const RegisterEvent(
      {required this.name,
      required this.lastname,
      required this.email,
      required this.phone,
      required this.password});
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent({required this.email});
}

class ResetPasswordEvent extends AuthEvent {
  final String email;
  final String password;
  final String codigo;

  const ResetPasswordEvent({
    required this.email,
    required this.password,
    required this.codigo,
  });
}

class CheckAuthStatusEvent extends AuthEvent {}

class GetUserDataEvent extends AuthEvent {}

class AuthErrorEvent extends AuthEvent {
  final String message;

  const AuthErrorEvent({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
