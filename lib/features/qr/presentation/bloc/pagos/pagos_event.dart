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

class QrAmountPaymentEvent extends PagosEvent {
  final double monto;
  final String payload;

  const QrAmountPaymentEvent({required this.monto, required this.payload});
}

class TopUpEvent extends PagosEvent {
  final double monto;
  final int methodId;

  const TopUpEvent({required this.methodId, required this.monto});
}

class WithdrawEvent extends PagosEvent {
  final double monto;
  final int methodId;

  const WithdrawEvent({required this.methodId, required this.monto});
}

class GenerateAmountQrEvent extends PagosEvent {
  final double monto;

  const GenerateAmountQrEvent({required this.monto});
}
