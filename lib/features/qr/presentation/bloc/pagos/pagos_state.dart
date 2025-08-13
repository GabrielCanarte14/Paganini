part of 'pagos_bloc.dart';

sealed class PagosState extends Equatable {
  const PagosState();

  @override
  List<Object> get props => [];
}

class Revisando extends PagosState {}

class PaymentComplete extends PagosState {
  final String message;

  const PaymentComplete({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

final class PaymentInitial extends PagosState {}

class PaymentError extends PagosState {
  final String message;

  const PaymentError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
