part of 'methods_bloc.dart';

sealed class MethodsEvent extends Equatable {
  const MethodsEvent();

  @override
  List<Object> get props => [];
}

class GetMethodsEvent extends MethodsEvent {
  final String email;

  const GetMethodsEvent({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}

class RegisterCardEvent extends MethodsEvent {
  final String number;
  final String titular;
  final int month;
  final int year;
  final String cvv;
  final String type;
  final String red;

  const RegisterCardEvent(
      {required this.number,
      required this.titular,
      required this.month,
      required this.year,
      required this.cvv,
      required this.type,
      required this.red});
}
