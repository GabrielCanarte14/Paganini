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

class RegisterBankEvent extends MethodsEvent {
  final String number;
  final String titular;
  final String type;
  final String bank;
  final String identificacion;

  const RegisterBankEvent(
      {required this.number,
      required this.titular,
      required this.type,
      required this.bank,
      required this.identificacion});
}

class DeletePaymentEvent extends MethodsEvent {
  final int id;

  const DeletePaymentEvent({required this.id});
}
