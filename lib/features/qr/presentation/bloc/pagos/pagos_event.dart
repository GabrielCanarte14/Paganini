part of 'pagos_bloc.dart';

sealed class PagosEvent extends Equatable {
  const PagosEvent();

  @override
  List<Object> get props => [];
}

class PaymentEvent extends PagosEvent {
  final String correo;
  final double monto;

  const PaymentEvent({required this.correo, required this.monto});
}
